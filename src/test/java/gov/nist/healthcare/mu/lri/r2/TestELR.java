package gov.nist.healthcare.mu.lri.r2;

/*
 * NIST Healthcare
 * TestPackage.java Mar 19, 2013
 *
 * This code was produced by the National Institute of Standards and
 * Technology (NIST). See the "nist.disclaimer" file given in the distribution
 * for information on the use and redistribution of this software.
 */

import gov.nist.validation.report.Entry;
import gov.nist.validation.report.Report;
import hl7.v2.profile.XMLDeserializer;
import hl7.v2.validation.SyncHL7Validator;
import hl7.v2.validation.content.ConformanceContext;
import hl7.v2.validation.content.DefaultConformanceContext;
import hl7.v2.validation.vs.ValueSetLibrary;
import hl7.v2.validation.vs.ValueSetLibraryImpl;
import java.io.File;
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
 * @author Caroline Rosin (NIST) //
 */
// @Ignore
public class TestELR {

    private static Logger logger = Logger.getLogger(TestELR.class.getName());

    private static LRIContext elrContext;

    @BeforeClass
    public static void setUp() {
        elrContext = new LRIContext();
    }

    @Test
    public void testValidatePackage() throws Exception {
        File f = new File("./src/main/resources/ELR");

        IOFileFilter msgFilter = new SuffixFileFilter("Message.txt");
        IOFileFilter conformanceContextFilter = new SuffixFileFilter(
                "Constraints.xml");

        Collection<File> messages = FileUtils.listFiles(f, msgFilter,
                TrueFileFilter.INSTANCE);

        for (File message : messages) {
            String folderName = message.getParentFile().getName();
            String messageString = FileUtils.readFileToString(message);

            // read profile

            String profile = "ORU_R01:LRI_GU_FRU_PH";
            if (profile != null) {

                SyncHL7Validator validator = createValidator(
                        "/ELR/ELR_integration_profile.xml",
                        "/ELR/ELR_ValueSet_Library.xml");

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
                                // printEntry(entry);
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
            String valueSetLibFileName) throws Exception {

        // The profile in XML
        InputStream profileXML = TestELR.class.getResourceAsStream(profileFileName);

        // ### [Update]
        // The conformance context file XML

        // default constraint file
        InputStream contextXML2 = TestELR.class.getResourceAsStream("/ELR/ELR_conformance_context.xml");

        ConformanceContext context = DefaultConformanceContext.apply(
                Arrays.asList(contextXML2)).get();

        // The get() at the end will throw an exception if something goes wrong
        hl7.v2.profile.Profile profile = XMLDeserializer.deserialize(profileXML).get();

        InputStream vsLibXML = TestELR.class.getResourceAsStream(valueSetLibFileName);
        ValueSetLibrary valueSetLibrary = ValueSetLibraryImpl.apply(vsLibXML).get();

        // A java friendly version of an HL7 validator
        // This should be a singleton for a specific tool. We create it once and
        // reuse it across validations
        return new SyncHL7Validator(profile, valueSetLibrary, context);
    }

}
