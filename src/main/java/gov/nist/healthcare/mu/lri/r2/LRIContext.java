/*
 * NIST Healthcare
 * LRIContext.java Dec 15, 2014
 *
 * This code was produced by the National Institute of Standards and
 * Technology (NIST). See the "nist.disclaimer" file given in the distribution
 * for information on the use and redistribution of this software.
 */

package gov.nist.healthcare.mu.lri.r2;

import gov.nist.healthcare.mu.bundle.BundleContext;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * LRI R2 configuration
 * 
 * @author Caroline Rosin (NIST)
 */
public class LRIContext implements BundleContext {

    private static final String DOMAIN = "lri-r2";

    private static final String RESOURCE_DIR_F = "./src/main/resources";
    private static final String TESTCASE_DIR = "/Contextbased";
    private static final String TESTCASE_DIR_F = RESOURCE_DIR_F + TESTCASE_DIR;

    // spreadsheet-processing related
    private static final String SPREADSHEET_DIR = "/OLD_Documentation/Test_Case_Spreadsheet";
    private static final String SPREADSHEET = SPREADSHEET_DIR
            + "/LRI-R2-Template.xlsx";
    private static final String[] LRI_WORKSHEET_SEGMENTS = { "MSH", "PID",
            "ORC", "OBR", "NTE", "TQ1", "OBX", "SPM", "MSA", "ERR" };

    private static final String[] LRI_WORKSHEET_MESSAGES = { "Messages",
            "NTEHandling_Messages", "Pos Smoke ACKS Messages" };

    private static final String[] LRI_WORKSHEET_MESSAGE_DESCRIPTION = {
            "Message Description", "ACK Message description" };
    // "Message Description", "NTEHandling_Message_Descrip" };

    // validation and generation artifacts
    private static final String CONFORMANCE_PROFILE = "/Global/Profiles/LRI_Integration_Profile.xml";
    private static final String EMPTY_CONFORMANCE_CONTEXT = "/Global/Constraints/empty_conformance_context.xml";
    private static final String CONFORMANCE_CONTEXT = "/Global/Constraints/LRI_Constraints.xml";

    // documentation
    private static final String EMPTY_XML = "/Global/xslt/empty.xml";

    private static final String TEST_STORY_XSLT = "/Global/xslt/test-story-generic.xslt";
    private static final String MESSAGE_CONTENT_XSLT = "/Global/xslt/message-content-generic.xsl";

    private static final String DATASHEET_XSLT = "/xslt/datasheet-generic.xslt";

    private static final String PACKAGE_AGGREGATOR_XSLT = "/Global/xslt/package-aggregator.xslt";
    private static final String ER7_XSLT = "/Global/xslt/er7.xslt";

    private static final String TESTDATASPEC_XSLT = "/Global/xslt/common_tdspec.xsl";
    private static final String TESTDATASPEC_GENERIC_HTML = "/Global/html/TestDataSpecification_generic.html";

    private static final String JUROR_XSLT = "/Global/xslt/jurorDoc_LRIv2.xsl";

    private static final Map<String, String> GROUP_STRUCTURE;
    private static final Map<String, String> GROUP_TRIGGER;

    static {
        // profile to group structure
        GROUP_STRUCTURE = new HashMap<String, String>();
        GROUP_STRUCTURE.put("ORU_R01:LRI_GU_FRU",
                "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("ORU_R01:LRI_GU_FRN",
                "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("ORU_R01:LRI_NG_FRU",
                "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("ORU_R01:LRI_NG_FRN",
                "/ProfileLibraries/json/groups.json");

        GROUP_STRUCTURE.put("ACK_ACC:LRI_GU",
                "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("ACK_ACC:LRI_NG",
                "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("ACK_APP:LRI_GU",
                "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("ACK_APP:LRI_NG",
                "/ProfileLibraries/json/groups.json");

        // profile to group trigger
        GROUP_TRIGGER = new HashMap<String, String>();
        GROUP_TRIGGER.put("ORU_R01:LRI_GU_FRU",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("ORU_R01:LRI_GU_FRN",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("ORU_R01:LRI_NG_FRU",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("ORU_R01:LRI_NG_FRN",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("ACK_ACC:LRI_GU",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("ACK_ACC:LRI_NG",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("ACK_APP:LRI_GU",
                "/ProfileLibraries/json/group triggers.json");
        GROUP_TRIGGER.put("ACK_APP:LRI_NG",
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
        return LRI_WORKSHEET_SEGMENTS;
    }

    public String[] getWORKSHEET_MESSAGES() {
        return LRI_WORKSHEET_MESSAGES;
    }

    public String[] getWORKSHEET_MESSAGE_DESCRIPTION() {
        return LRI_WORKSHEET_MESSAGE_DESCRIPTION;
    }

    // public Map<String, String> getPROFILES() {
    // return PROFILES;
    // }

    // public String[] getTABLES() {
    // return TABLES;
    // }

    // public Map<String, String> getDYNAMIC_DATATYPES() {
    // return DYNAMIC_DATATYPES;
    // }

    public String getEMPTY_XML() {
        return EMPTY_XML;
    }

    public String getTEST_STORY_XSLT() {
        return TEST_STORY_XSLT;
    }

    public String getDATASHEET_XSLT() {
        return DATASHEET_XSLT;
    }

    public String getPACKAGE_AGGREGATOR_XSLT() {
        return PACKAGE_AGGREGATOR_XSLT;
    }

    public String getER7_XSLT() {
        return ER7_XSLT;
    }

    // public List<String> getTABLE_EXCLUSIONS() {
    // return TABLE_EXCLUSIONS;
    // }

    // @Override
    // public String getVENDOR_DATASHEET_XSLT() {
    // return VENDOR_DATASHEET_XSLT;
    // }

    @Override
    public void setTestCases(Set<String> testCases) {
        this.testCases = testCases;
    }

    @Override
    public Set<String> getTestCases() {
        return testCases;
    }

    @Override
    public String getCONFORMANCE_PROFILE() {
        return CONFORMANCE_PROFILE;
    }

    @Override
    public String getEMPTY_CONFORMANCE_CONTEXT() {
        return EMPTY_CONFORMANCE_CONTEXT;
    }

    @Override
    public String getCONFORMANCE_CONTEXT() {
        return CONFORMANCE_CONTEXT;
    }

    @Override
    public String getMESSAGE_CONTENT_XSLT() {
        return MESSAGE_CONTENT_XSLT;
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
    public String getTESTDATASPEC_XSLT() {
        return TESTDATASPEC_XSLT;
    }

    @Override
    public String getTESTDATASPEC_GENERIC_HMTL() {
        return TESTDATASPEC_GENERIC_HTML;
    }

    @Override
    public String getJUROR_XSLT() {
        return JUROR_XSLT;
    }

}
