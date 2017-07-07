/*
 * NIST Healthcare
 * TestPackage.java Mar 19, 2013
 *
 * This code was produced by the National Institute of Standards and
 * Technology (NIST). See the "nist.disclaimer" file given in the distribution
 * for information on the use and redistribution of this software.
 */
package gov.nist.healthcare.mu.loi;

import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestStep;
import gov.nist.validation.report.Entry;
import gov.nist.validation.report.Report;
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
import java.util.Set;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.IOFileFilter;
import org.apache.commons.io.filefilter.SuffixFileFilter;
import org.apache.commons.io.filefilter.TrueFileFilter;
import org.apache.log4j.Logger;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 * @author Caroline Rosin (NIST)
 */
// @Ignore
public class TestPackageNEW {

    private static Logger logger = Logger.getLogger(TestPackageNEW.class.getName());

    private static LOIContext loiContext;

    @BeforeClass
    public static void setUp() {
        loiContext = new LOIContext();

    }

    @Test
    public void testValidatePackage() throws Exception {
        // File f = new File(loiContext.getTESTCASE_DIR_F());
        File f = new File("./src/test/resources/messages");

        IOFileFilter msgFilter = new SuffixFileFilter("Message.txt");
        IOFileFilter conformanceContextFilter = new SuffixFileFilter(
                "Constraints.xml");

        Collection<File> messages = FileUtils.listFiles(f, msgFilter,
                TrueFileFilter.INSTANCE);

        for (File message : messages) {
            String folderName = message.getParentFile().getName();
            String messageString = FileUtils.readFileToString(message);

            // get conformance context
            Collection<File> confCtxts = FileUtils.listFiles(
                    message.getParentFile(), conformanceContextFilter,
                    TrueFileFilter.INSTANCE);

            File json = new File(message.getParentFile(), "TestStep.json");
            if (!json.exists()) {
                json = new File(message.getParentFile(), "TestObject.json");
            }
            // read profile
            String jsonSt = FileUtils.readFileToString(json);
            JTestStep js = JTestStep.fromJson(jsonSt);
            String profile = js.getMessageId();
            if (profile != null) {
                if (confCtxts.size() == 0) {
                    SyncHL7Validator validator = createValidator(
                            "/Global/Profiles/LOI_integration_profile.xml",
                            "/Global/Tables/LOI_ValueSet_Library.xml");

                    System.out.println("Validating " + folderName);
                    Report report = validator.check(messageString, profile);
                    Set<String> keys = report.getEntries().keySet();
                    for (String key : keys) {
                        List<Entry> entries = report.getEntries().get(key);
                        if (entries != null && entries.size() > 0) {
                            System.out.println("*** " + key + " ***");
                            for (Entry entry : entries) {
//                                printEntry(entry);
                                 if
                                 (entry.getClassification().equals("Error")) {
                                 printEntry(entry);
                                 }
                                 if
                                 (entry.getClassification().equals("Alert")) {
                                 printEntry(entry);
                                 }
                            }
                        }
                    }

                }
                for (File confCtxt : confCtxts) {
                    FileInputStream fis = new FileInputStream(confCtxt);
                    SyncHL7Validator validator = createValidator(
                            "/Global/Profiles/LOI_integration_profile.xml",
                            fis, "/Global/Tables/LOI_ValueSet_Library.xml");

                    System.out.println("Validating " + folderName);
                    Report report = validator.check(messageString, profile);
                    Set<String> keys = report.getEntries().keySet();
                    for (String key : keys) {
                        List<Entry> entries = report.getEntries().get(key);
                        if (entries != null && entries.size() > 0) {
                            System.out.println("*** " + key + " ***");
                            for (Entry entry : entries) {
                                printEntry(entry);
                                // if
                                // (entry.getClassification().equals("Error")) {
                                // printEntry(entry);
                                //
                                // }
                                // if
                                // (entry.getClassification().equals("Alert")) {
                                // printEntry(entry);
                                // }
                            }
                        }
                    }
                    // System.out.println(report.toText());
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
        InputStream profileXML = TestPackageNEW.class.getResourceAsStream(profileFileName);

        // ### [Update]
        // The conformance context file XML

        // default constraint file
        InputStream contextXML2 = TestPackageNEW.class.getResourceAsStream(loiContext.getCONFORMANCE_CONTEXT());
        List<InputStream> confContexts = Arrays.asList(constraints, contextXML2);
        // List<InputStream> confContexts = Arrays.asList(constraints);

        ConformanceContext context = DefaultConformanceContext.apply(
                confContexts).get();

        // The get() at the end will throw an exception if something goes wrong
        Profile profile = XMLDeserializer.deserialize(profileXML).get();

        InputStream vsLibXML = TestPackageNEW.class.getResourceAsStream(valueSetLibFileName);
        ValueSetLibrary valueSetLibrary = ValueSetLibraryImpl.apply(vsLibXML).get();

        // A java friendly version of an HL7 validator
        // This should be a singleton for a specific tool. We create it once and
        // reuse it across validations
        return new SyncHL7Validator(profile, valueSetLibrary, context);
    }

    private static SyncHL7Validator createValidator(String profileFileName,
            String valueSetLibFileName) throws Exception {

        // The profile in XML
        InputStream profileXML = TestPackageNEW.class.getResourceAsStream(profileFileName);

        // ### [Update]
        // The conformance context file XML

        // default constraint file
        InputStream contextXML2 = TestPackageNEW.class.getResourceAsStream(loiContext.getCONFORMANCE_CONTEXT());
        List<InputStream> confContexts = Arrays.asList(contextXML2);
        // List<InputStream> confContexts = Arrays.asList(constraints);

        ConformanceContext context = DefaultConformanceContext.apply(
                confContexts).get();

        // The get() at the end will throw an exception if something goes wrong
        Profile profile = XMLDeserializer.deserialize(profileXML).get();

        InputStream vsLibXML = TestPackageNEW.class.getResourceAsStream(valueSetLibFileName);
        ValueSetLibrary valueSetLibrary = ValueSetLibraryImpl.apply(vsLibXML).get();

        // A java friendly version of an HL7 validator
        // This should be a singleton for a specific tool. We create it once and
        // reuse it across validations
        return new SyncHL7Validator(profile, valueSetLibrary, context);
    }

}
