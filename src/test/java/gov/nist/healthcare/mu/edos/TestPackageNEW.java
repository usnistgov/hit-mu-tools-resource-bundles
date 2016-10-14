/*
 * NIST Healthcare
 * TestPackage.java Mar 19, 2013
 *
 * This code was produced by the National Institute of Standards and
 * Technology (NIST). See the "nist.disclaimer" file given in the distribution
 * for information on the use and redistribution of this software.
 */
package gov.nist.healthcare.mu.edos;

import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestStep;
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

    private static EDOSContext edosContext;

    @BeforeClass
    public static void setUp() {
        edosContext = new EDOSContext();
    }

    @Test
    public void testValidatePackage() throws Exception {
        File f = new File(edosContext.getTESTCASE_DIR_F());

        File ehr = new File(f, "EHR");
        File ehrGU = new File(ehr, "1-GU");
        File ehrGUedos0 = new File(ehrGU, "1-EDOS_0");

        File ehrNG = new File(ehr, "2-NG");

        File lis = new File(f, "LIS");
        File lisGU = new File(lis, "1-GU");
        File lisNG = new File(lis, "2-NG");

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
                            "/Global/Profiles/eDOS_integration_profile.xml",
                            fis, "/Global/Tables/edos.xml");

                    // ValueSetLibraryImpl lib = (ValueSetLibraryImpl)
                    // validator.valueSetLibrary();
                    // System.err.println(lib.library().keySet());

                    // System.out.println(messageString);
                    Report report = validator.check(messageString, profile);

                    // report.toJson();
                    System.out.println(folderName);
                    System.out.println(report.toText());
                    // System.out.println(report.toJson());
                }
            }
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
        InputStream contextXML2 = TestPackageNEW.class.getResourceAsStream(edosContext.getCONFORMANCE_CONTEXT());
        // List<InputStream> confContexts = Arrays.asList(constraints,
        // contextXML2);
        List<InputStream> confContexts = Arrays.asList(contextXML2, constraints);
        // List<InputStream> confContexts = Arrays.asList(constraints);
        // List<InputStream> confContexts = Arrays.asList(contextXML2);

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
