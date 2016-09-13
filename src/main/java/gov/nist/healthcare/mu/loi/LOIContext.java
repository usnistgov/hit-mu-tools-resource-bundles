/*
 * NIST Healthcare
 * LOIConstants.java Mar 11, 2013
 *
 * This code was produced by the National Institute of Standards and
 * Technology (NIST). See the "nist.disclaimer" file given in the distribution
 * for information on the use and redistribution of this software.
 */
package gov.nist.healthcare.mu.loi;

import gov.nist.healthcare.mu.bundle.BundleContext;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * LOI configuration
 * 
 * @author Caroline Rosin (NIST)
 */
public class LOIContext implements BundleContext {

    private static final String DOMAIN = "loi";

    private static final String RESOURCE_DIR_F = "./src/main/resources";
    private static final String TESTCASE_DIR = "/Contextbased";
    private static final String TESTCASE_DIR_F = RESOURCE_DIR_F + TESTCASE_DIR;

    // spreadsheet-processing related
    private static final String SPREADSHEET_DIR = "/OLD_Documentation/Test_Case_Spreadsheet";
    private static final String SPREADSHEET = SPREADSHEET_DIR
            + "/LOI_Data_V1.0_SEPT08-2016_CR.xlsx";

    private static final String[] LOI_WORKSHEET_SEGMENTS = { "MSH", "PID",
            "NK1", "PV1", "IN1", "GT1", "ORC", "TQ1", "OBR", "NTE", "PRT",
            "DG1", "OBX", "SPM", "MSA", "ERR" };

    private static final String[] LOI_WORKSHEET_MESSAGES = { "Messages",
            "Smoke_ORL Messages", "Smoke Acks Messages" };
    private static final String[] LOI_WORKSHEET_MESSAGE_DESCRIPTION = {
            "Message Description", "Message Description ORL",
            "Message Description ACK" };

    // private static final String[] LOI_WORKSHEET_MESSAGES = {
    // "Smoke_ORL Messages" };
    // private static final String[] LOI_WORKSHEET_MESSAGE_DESCRIPTION = {
    // "Message Description ORL" };
    // private static final String[] LOI_WORKSHEET_MESSAGES = {
    // "Smoke Acks Messages" };
    // private static final String[] LOI_WORKSHEET_MESSAGE_DESCRIPTION = {
    // "Message Description ACK" };

    // validation and generation artifacts
    private static final String CONFORMANCE_PROFILE = "/Global/Profiles/LOI_integration_profile.xml";
    private static final String EMPTY_CONFORMANCE_CONTEXT = "/Global/Constraints/empty_conformance_context.xml";
    private static final String CONFORMANCE_CONTEXT = "/Global/Constraints/LOI_conformance_context.xml";

    // documentation
    private static final String EMPTY_XML = "/Global/xslt/empty.xml";

    private static final String TEST_STORY_XSLT = "/Global/xslt/test-story-generic.xslt";
    private static final String MESSAGE_CONTENT_XSLT = "/Global/xslt/message-content-generic.xsl";

    private static final String PACKAGE_AGGREGATOR_XSLT = "/Global/xslt/package-aggregator.xslt";
    private static final String ER7_XSLT = "/Global/xslt/er7.xslt";

    private static final String TESTDATASPEC_XSLT = "/Global/xslt/testdata-specification-2.xsl";

    private static final Map<String, String> GROUP_STRUCTURE;
    private static final Map<String, String> GROUP_TRIGGER;

    static {
        // profile to group structure
        GROUP_STRUCTURE = new HashMap<String, String>();
        GROUP_STRUCTURE.put("OML_O21:LOI_GU",
                "/ProfileLibraries/json/new and append - groups.json");
        GROUP_STRUCTURE.put("OML_O21:LOI_GU_PRU",
                "/ProfileLibraries/json/new and append - groups.json");
        GROUP_STRUCTURE.put("OML_O21:LOI_GU_PRN",
                "/ProfileLibraries/json/new and append - groups.json");
        GROUP_STRUCTURE.put("OML_O21:LOI_GU_PH",
                "/ProfileLibraries/json/new and append - groups.json");
        GROUP_STRUCTURE.put("OML_O21:LOI_GU_FI",
                "/ProfileLibraries/json/new and append - groups.json");

        GROUP_STRUCTURE.put("OML_O21:LOI_NG",
                "/ProfileLibraries/json/new and append - groups.json");
        GROUP_STRUCTURE.put("OML_O21:LOI_NG_PRU",
                "/ProfileLibraries/json/new and append - groups.json");
        GROUP_STRUCTURE.put("OML_O21:LOI_NG_PRN",
                "/ProfileLibraries/json/new and append - groups.json");
        GROUP_STRUCTURE.put("OML_O21:LOI_NG_PH",
                "/ProfileLibraries/json/new and append - groups.json");
        GROUP_STRUCTURE.put("OML_O21:LOI_NG_FI",
                "/ProfileLibraries/json/new and append - groups.json");

        GROUP_STRUCTURE.put("OML_O21:LOI_GU_C",
                "/ProfileLibraries/json/cancel - groups.json");
        GROUP_STRUCTURE.put("OML_O21:LOI_NG_C",
                "/ProfileLibraries/json/cancel - groups.json");

        GROUP_STRUCTURE.put("ORL_O22:LOI_GU",
                "/ProfileLibraries/json/orl - groups.json");
        GROUP_STRUCTURE.put("ORL_O22:LOI_NG",
                "/ProfileLibraries/json/orl - groups.json");

        GROUP_STRUCTURE.put("ACK_O21:LOI_GU",
                "/ProfileLibraries/json/ack - groups.json");
        GROUP_STRUCTURE.put("ACK_O21:LOI_NG",
                "/ProfileLibraries/json/ack - groups.json");
        GROUP_STRUCTURE.put("ACK_O22:LOI_GU",
                "/ProfileLibraries/json/ack - groups.json");
        GROUP_STRUCTURE.put("ACK_O22:LOI_NG",
                "/ProfileLibraries/json/ack - groups.json");

        // profile to group trigger
        GROUP_TRIGGER = new HashMap<String, String>();
        GROUP_TRIGGER.put("OML_O21:LOI_GU",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("OML_O21:LOI_GU_PRU",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("OML_O21:LOI_GU_PRN",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("OML_O21:LOI_GU_PH",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("OML_O21:LOI_GU_FI",
                "/ProfileLibraries/json/group triggers.json");

        GROUP_TRIGGER.put("OML_O21:LOI_NG",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("OML_O21:LOI_NG_PRU",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("OML_O21:LOI_NG_PRN",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("OML_O21:LOI_NG_PH",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("OML_O21:LOI_NG_FI",
                "/ProfileLibraries/json/group triggers.json");

        GROUP_TRIGGER.put("OML_O21:LOI_GU_C",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("OML_O21:LOI_NG_C",
                "/ProfileLibraries/json/group triggers.json");

        GROUP_TRIGGER.put("ORL_O22:LOI_GU",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("ORL_O22:LOI_NG",
                "/ProfileLibraries/json/group triggers.json");

        GROUP_TRIGGER.put("ACK_O21:LOI_GU",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("ACK_O21:LOI_NG",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("ACK_O22:LOI_GU",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("ACK_O22:LOI_NG",
                "/ProfileLibraries/json/group triggers.json");

    }

    private Set<String> testCases;

    public String getDOMAIN() {
        return DOMAIN;
    }

    public String getTESTCASE_DIR_F() {
        return TESTCASE_DIR_F;
    }

    public String getSPREADSHEET() {
        return SPREADSHEET;
    }

    public String[] getWORKSHEET_SEGMENTS() {
        return LOI_WORKSHEET_SEGMENTS;
    }

    public String[] getWORKSHEET_MESSAGES() {
        return LOI_WORKSHEET_MESSAGES;
    }

    public String[] getWORKSHEET_MESSAGE_DESCRIPTION() {
        return LOI_WORKSHEET_MESSAGE_DESCRIPTION;
    }

    public String getEMPTY_XML() {
        return EMPTY_XML;
    }

    public String getTEST_STORY_XSLT() {
        return TEST_STORY_XSLT;
    }

    public String getDATASHEET_XSLT() {
        return MESSAGE_CONTENT_XSLT;
    }

    public String getPACKAGE_AGGREGATOR_XSLT() {
        return PACKAGE_AGGREGATOR_XSLT;
    }

    public String getER7_XSLT() {
        return ER7_XSLT;
    }

    @Override
    public void setTestCases(Set<String> testCases) {
        this.testCases = testCases;
    }

    @Override
    public Set<String> getTestCases() {
        return testCases;
    }

    @Override
    public String getCONFORMANCE_CONTEXT() {
        return CONFORMANCE_CONTEXT;
    }

    @Override
    public String getCONFORMANCE_PROFILE() {
        return CONFORMANCE_PROFILE;
    }

    @Override
    public Map<String, String> getGROUP_STRUCTURE() {
        return GROUP_STRUCTURE;
    }

    @Override
    public Map<String, String> getGROUP_TRIGGER() {
        return GROUP_TRIGGER;
    }

    @Override
    public String getMESSAGE_CONTENT_XSLT() {
        return MESSAGE_CONTENT_XSLT;
    }

    @Override
    public String getEMPTY_CONFORMANCE_CONTEXT() {
        return EMPTY_CONFORMANCE_CONTEXT;
    }

    @Override
    public String getTESTDATASPEC_XSLT() {
        return TESTDATASPEC_XSLT;
    }

    @Override
    public String getTESTDATASPEC_GENERIC_HMTL() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public String getJUROR_XSLT() {
        // TODO Auto-generated method stub
        return null;
    }

}
