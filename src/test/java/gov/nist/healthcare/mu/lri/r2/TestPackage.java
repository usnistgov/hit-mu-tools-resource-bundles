package gov.nist.healthcare.mu.lri.r2;

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
import java.util.Set;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.IOFileFilter;
import org.apache.commons.io.filefilter.SuffixFileFilter;
import org.apache.commons.io.filefilter.TrueFileFilter;
import org.apache.log4j.Logger;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

/**
 * @author Caroline Rosin (NIST) //
 */
// @Ignore
public class TestPackage {

    private static Logger logger = Logger.getLogger(TestPackage.class.getName());

    private static LRIContext lriContext;

    @BeforeClass
    public static void setUp() {
        lriContext = new LRIContext();
    }

    @Test
    public void testValidatePackage() throws Exception {
        File f = new File(lriContext.getTESTCASE_DIR_F());

        File ehr = new File(f, "EHR");
        File ehrGU = new File(ehr, "1-GU");
        File ehrGU_LRI_0 = new File(ehrGU, "1-PT_and_INR");

        // File ehrNG = new File(ehr, "2-NG");
        // File lis = new File(f, "LIS");
        // File lisGU = new File(lis, "1-GU");
        // File lisNG = new File(lis, "2-NG");

        IOFileFilter msgFilter = new SuffixFileFilter("Message.txt");
        IOFileFilter conformanceContextFilter = new SuffixFileFilter(
                "Constraints.xml");

        Collection<File> messages = FileUtils.listFiles(ehr, msgFilter,
                TrueFileFilter.INSTANCE);

        for (File message : messages) {
            String folderName = message.getParentFile().getName();
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
                    // System.err.println(confCtxt.getName());
                    FileInputStream fis = new FileInputStream(confCtxt);
                    SyncHL7Validator validator = createValidator(
                            "/Global/Profiles/LRI_Integration_Profile.xml",
                            fis, "/Global/Tables/LRI_ValueSet_Library.xml");

                    System.out.println("Validating " + folderName);
                    Report report = validator.check(messageString, profile);
                    System.out.println(messageString);
                    // System.out.println(report.toText());

                    Set<String> keys = report.getEntries().keySet();
                    for (String key : keys) {
                        List<Entry> entries = report.getEntries().get(key);
                        if (entries != null && entries.size() > 0) {
                            System.out.println("*** " + key + " ***");
                            for (Entry entry : entries) {

                                if (entry.getClassification().equals("Error")) {
                                    printEntry(entry);

                                }
                                if (entry.getClassification().equals("Alert")) {
                                    printEntry(entry);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private static void printEntry(Entry entry) {
        if (entry instanceof gov.nist.validation.report.impl.EntryImpl) {
            System.out.println(entry);
        } else if (entry instanceof hl7.v2.validation.vs.EnhancedEntry) {
            System.out.println(entry.toText());
        }
    }

    private static SyncHL7Validator createValidator(String profileFileName,
            InputStream constraints, String valueSetLibFileName)
            throws Exception {

        // The profile in XML
        InputStream profileXML = TestPackage.class.getResourceAsStream(profileFileName);

        // ### [Update]
        // The conformance context file XML

        // default constraint file
        InputStream contextXML2 = TestPackage.class.getResourceAsStream(lriContext.getCONFORMANCE_CONTEXT());
        // List<InputStream> confContexts = Arrays.asList(constraints,
        // contextXML2);
        List<InputStream> confContexts = Arrays.asList(contextXML2, constraints);
        // List<InputStream> confContexts = Arrays.asList(constraints);
        // List<InputStream> confContexts = Arrays.asList(contextXML2);

        ConformanceContext context = DefaultConformanceContext.apply(
                confContexts).get();

        // The get() at the end will throw an exception if something goes wrong
        hl7.v2.profile.Profile profile = XMLDeserializer.deserialize(profileXML).get();

        InputStream vsLibXML = TestPackage.class.getResourceAsStream(valueSetLibFileName);
        ValueSetLibrary valueSetLibrary = ValueSetLibraryImpl.apply(vsLibXML).get();

        // A java friendly version of an HL7 validator
        // This should be a singleton for a specific tool. We create it once and
        // reuse it across validations
        return new SyncHL7Validator(profile, valueSetLibrary, context);
    }

    @Test
    @Ignore
    public void testSimple() throws Exception {
        // The profile in XML
        ClassLoader classLoader = getClass().getClassLoader();

        InputStream profileXML = classLoader.getResourceAsStream("test_profile.xml");
        hl7.v2.profile.Profile profile = XMLDeserializer.deserialize(profileXML).get();

        InputStream vsLibXML = classLoader.getResourceAsStream("test_vs.xml");
        ValueSetLibrary valueSetLibrary = ValueSetLibraryImpl.apply(vsLibXML).get();

        InputStream contextXML = classLoader.getResourceAsStream("test_context.xml");
        List<InputStream> confContexts = Arrays.asList(contextXML);
        ConformanceContext context = DefaultConformanceContext.apply(
                confContexts).get();

        String messageString = FileUtils.readFileToString(new File(
                classLoader.getResource("test_message.txt").toURI()));

        SyncHL7Validator val = new SyncHL7Validator(profile, valueSetLibrary,
                context);
        System.out.println("Validating ...");
        Report report = val.check(messageString, "ORU_R01:LRI_GU_FRU");
        System.out.println(messageString);
        System.out.println(report.toText());
    }

}
