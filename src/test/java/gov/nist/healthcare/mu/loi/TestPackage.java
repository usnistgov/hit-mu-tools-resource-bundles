/*
 * NIST Healthcare
 * TestPackage.java Mar 19, 2013
 *
 * This code was produced by the National Institute of Standards and
 * Technology (NIST). See the "nist.disclaimer" file given in the distribution
 * for information on the use and redistribution of this software.
 */
package gov.nist.healthcare.mu.loi;

import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestObject;
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
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

/**
 * @author Caroline Rosin (NIST)
 */
// @Ignore
public class TestPackage {

    private static Logger logger = Logger.getLogger(TestPackage.class.getName());

    private static LOIContext loiContext;
    private static String globalFolder = "/Global";

    private static String profiles;
    private static String constraints;
    private static String valueSets;

    @BeforeClass
    public static void setUp() {
        loiContext = new LOIContext();
        profiles = StringUtils.join(globalFolder, "/Profiles",
                "/LOI_integration_profile.xml");
        constraints = StringUtils.join(globalFolder, "/Constraints",
                "/LOI_Constraints.xml");
        valueSets = StringUtils.join(globalFolder, "/Tables",
                "/LOI_ValueSet_Library.xml");

    }

    @Test
    @Ignore
    public void testValidateTestMessage() throws Exception {
        System.out.println("*** Validate test messages ***");
        File f = new File("./src/test/resources/messages");
        validateRepository(f);
    }

    @Test
    @Ignore
    public void testValidateContextFree() throws Exception {
        System.out.println("*** Validate context-free messages ***");
        File f = new File(loiContext.getCONTEXT_FREE_DIR_F());
        validateRepository(f);
    }

    @Test
    public void testValidateContextBased() throws Exception {
        System.out.println("*** Validate context-based messages ***");
        File f = new File(loiContext.getTESTCASE_DIR_F());
        validateRepository(f);
    }

    private static void validateRepository(File f) throws Exception {

        IOFileFilter msgFilter = new SuffixFileFilter("Message.txt");
        Collection<File> messages = FileUtils.listFiles(f, msgFilter,
                TrueFileFilter.INSTANCE);

        for (File message : messages) {
            String folderName = message.getParentFile().getName();
            String messageString = FileUtils.readFileToString(message);

            // get conformance context
            File confCtxt = new File(message.getParentFile(), "Constraints.xml");
            File json = new File(message.getParentFile(), "TestStep.json");
            if (!json.exists()) {
                json = new File(message.getParentFile(), "TestObject.json");
            }
            // read profile
            String jsonSt = FileUtils.readFileToString(json);
            JTestStep js = JTestStep.fromJson(jsonSt);
            String profile = js.getMessageId();
            if (profile == null) {
                JTestObject jo = JTestObject.fromJson(jsonSt);
                profile = jo.getMessageId();
            }
            if (profile != null) {
                // create validator
                SyncHL7Validator validator = createValidator(profiles,
                        constraints, confCtxt, valueSets);

                System.out.println("Validating " + folderName);
                System.out.println(messageString);

                Report report = validator.check(messageString, profile);

                Set<String> keys = report.getEntries().keySet();
                for (String key : keys) {
                    List<Entry> entries = report.getEntries().get(key);
                    if (entries != null && entries.size() > 0) {
                        System.out.println("*** " + key + " ***");
                        for (Entry entry : entries) {
                            switch (entry.getClassification()) {
                            case "Error":
                                // case "Alert":
                                printEntry(entry);
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

    private static SyncHL7Validator createValidator(
            String globalProfileFileName, String globalConstraintsFileName,
            File specificConstraintsFile, String globalValueSetLibFileName)
            throws Exception {

        // The profile in XML
        InputStream profileXML = TestPackage.class.getResourceAsStream(globalProfileFileName);

        // The default conformance context file XML
        InputStream contextXML = TestPackage.class.getResourceAsStream(globalConstraintsFileName);

        // The test case specific conformance context file XML
        List<InputStream> confContexts = null;
        if (specificConstraintsFile != null && specificConstraintsFile.exists()) {
            InputStream specificContextXML = new FileInputStream(
                    specificConstraintsFile);
            confContexts = Arrays.asList(contextXML, specificContextXML);
        } else {

            confContexts = Arrays.asList(contextXML);
        }

        ConformanceContext context = DefaultConformanceContext.apply(
                confContexts).get();

        // The value set library file XML
        InputStream vsLibXML = TestPackage.class.getResourceAsStream(globalValueSetLibFileName);

        // The get() at the end will throw an exception if something goes wrong

        hl7.v2.profile.Profile profile = XMLDeserializer.deserialize(profileXML).get();
        ValueSetLibrary valueSetLibrary = ValueSetLibraryImpl.apply(vsLibXML).get();
        // A java friendly version of an HL7 validator
        // This should be a singleton for a specific tool. We create it once
        // and
        // reuse it across validations
        return new SyncHL7Validator(profile, valueSetLibrary, context);

    }
}
