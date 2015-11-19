package gov.nist.healthcare.mu.ss.r2.test;

/*
 * NIST Healthcare
 * TestPackage.java Mar 19, 2013
 *
 * This code was produced by the National Institute of Standards and
 * Technology (NIST). See the "nist.disclaimer" file given in the distribution
 * for information on the use and redistribution of this software.
 */

import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestStep;
import gov.nist.validation.report.Entry;
import gov.nist.validation.report.Report;
import gov.nist.validation.report.Trace;
import hl7.v2.profile.Profile;
import hl7.v2.profile.XMLDeserializer;
import hl7.v2.validation.SyncHL7Validator;
import hl7.v2.validation.content.ConformanceContext;
import hl7.v2.validation.content.DefaultConformanceContext;
import hl7.v2.validation.vs.ValueSetLibrary;
import hl7.v2.validation.vs.ValueSetLibraryImpl;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.IOFileFilter;
import org.apache.commons.io.filefilter.SuffixFileFilter;
import org.apache.commons.io.filefilter.TrueFileFilter;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 * @author Caroline Rosin (NIST)
 */
// @Ignore
public class TestBundle {

    private static Logger logger = Logger.getLogger(TestBundle.class.getName());
    private static String testCaseDir = "./src/main/resources/Contextbased";
    private static String integrationProfile = "/Global/Profiles/Profile.xml";
    private static String conformanceContext = "/Global/Constraints/Constraints.xml";
    private static String tableLibrary = "/Global/Tables/ValueSetLibrary_SS_CB.xml";

    @BeforeClass
    public static void setUp() {
    }

    @Test
    public void testValidatePackage() throws Exception {
        File f = new File(testCaseDir);

        IOFileFilter msgFilter = new SuffixFileFilter("Message.txt");
        IOFileFilter conformanceContextFilter = new SuffixFileFilter(
                "Constraints.xml");

        // TODO : change directory to test here
        Collection<File> messages = FileUtils.listFiles(f, msgFilter,
                TrueFileFilter.INSTANCE);

        for (File message : messages) {
            String folderName = message.getParentFile().getAbsolutePath();
            String messageString = FileUtils.readFileToString(message);

            // get conformance context
            Collection<File> confCtxts = FileUtils.listFiles(
                    message.getParentFile(), conformanceContextFilter,
                    TrueFileFilter.INSTANCE);

            File json = new File(message.getParentFile(), "TestStep.json");
            // read profile
            String jsonSt = FileUtils.readFileToString(json);
            JTestStep js = JTestStep.fromJson(jsonSt);
            String profile = js.getMessageId();
            if (profile != null) {
                for (File confCtxt : confCtxts) {
                    // System.err.println(FileUtils.readFileToString(confCtxt));
                    FileInputStream fis = new FileInputStream(confCtxt);
                    SyncHL7Validator validator = createValidator(
                            integrationProfile, fis, tableLibrary);

                    // ValueSetLibraryImpl lib = (ValueSetLibraryImpl)
                    // validator.valueSetLibrary();
                    // System.err.println(lib.library().keySet());

                    // System.out.println(messageString);
                    Report report = validator.check(messageString, profile);

                    // report.toJson();
                    System.out.println(folderName);
                    // System.out.println(report.toText());

                    Map<String, List<Entry>> entries = report.getEntries();
                    for (String key : entries.keySet()) {
                        List<Entry> entryList = entries.get(key);
                        System.out.println(key);

                        // error = "Error"
                        // warning = "Warning"
                        // alert = "Alert"
                        // informational = "Informational"
                        // affirmative = "Affirmative"

                        boolean error = true;
                        boolean warning = true;
                        boolean alert = true;
                        boolean informational = false;
                        boolean affirmative = false;

                        for (Entry entry : entryList) {
                            String path = entry.getPath();
                            String category = entry.getCategory();
                            String classification = entry.getClassification();
                            String description = entry.getDescription();
                            List<Trace> stack = entry.getStackTrace();

                            boolean print = false;
                            if ("Error".equals(classification) && error) {
                                print = true;
                            } else if ("Warning".equals(classification)
                                    && warning) {
                                print = true;
                            } else if ("Alert".equals(classification) && alert) {
                                print = true;
                            } else if ("Informational".equals(classification)
                                    && informational) {
                                print = true;
                            } else if ("Affirmative".equals(classification)
                                    && affirmative) {
                                print = true;
                            }

                            if (print) {
                                System.out.println(String.format(
                                        "[%s] [%s] [%s] : %s", classification,
                                        category, path, description));
                                if ("Error".equals(classification)
                                        && stack != null && stack.size() > 0) {
                                    System.out.println(entry.getStackTrace());
                                }
                            }
                        }
                        System.out.println();
                    }
                    // System.out.println(report.toJson());
                }
            }
        }
    }

    private static SyncHL7Validator createValidator(String profileFileName,
            InputStream constraints, String valueSetLibFileName)
            throws Exception {

        // The profile in XML
        InputStream profileXML = TestBundle.class.getResourceAsStream(profileFileName);

        // ### [Update]
        // The conformance context file XML

        // default constraint file
        InputStream contextXML2 = TestBundle.class.getResourceAsStream(conformanceContext);
        // List<InputStream> confContexts = Arrays.asList(constraints,
        // contextXML2);
        List<InputStream> confContexts = Arrays.asList(contextXML2, constraints);
        // List<InputStream> confContexts = Arrays.asList(constraints);
        // List<InputStream> confContexts = Arrays.asList(contextXML2);

        ConformanceContext context = DefaultConformanceContext.apply(
                confContexts).get();

        // The get() at the end will throw an exception if something goes wrong
        Profile profile = XMLDeserializer.deserialize(profileXML).get();

        InputStream vsLibXML = TestBundle.class.getResourceAsStream(valueSetLibFileName);
        ValueSetLibrary valueSetLibrary = ValueSetLibraryImpl.apply(vsLibXML).get();

        // A java friendly version of an HL7 validator
        // This should be a singleton for a specific tool. We create it once and
        // reuse it across validations
        return new SyncHL7Validator(profile, valueSetLibrary, context);
    }
}
