/*
 * NIST Healthcare
 * LOIConstants.java Mar 11, 2013
 *
 * This code was produced by the National Institute of Standards and
 * Technology (NIST). See the "nist.disclaimer" file given in the distribution
 * for information on the use and redistribution of this software.
 */
package gov.nist.healthcare.mu.edos;

import gov.nist.healthcare.mu.bundle.BundleContext;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * eDOS configuration
 * 
 * @author Caroline Rosin (NIST)
 */
public class EDOSContext implements BundleContext {

    private static final String DOMAIN = "eDOS";

    private static final String RESOURCE_DIR_F = "./src/main/resources";
    private static final String TESTCASE_DIR = "/Contextbased";
    private static final String TESTCASE_DIR_F = RESOURCE_DIR_F + TESTCASE_DIR;

    // spreadsheet-processing related
    private static final String SPREADSHEET_DIR = "/OLD_Documentation/Test_Case_Spreadsheet";

    private static final String SPREADSHEET = SPREADSHEET_DIR
            + "/eDOS_Data_V1.0_SEPT14-2016_CR.xlsx";

    // private static final String[] EDOS_TSV_LISTINGS = {
    // "Message Description",
    // "M04 Messages", "M08 Messages", "M10 Messages", "Metadata", "MSH",
    // "MFI", "MFE", "OM1", "OM2", "OM3", "OM4", "OM5", "CDM",
    // "TestCaseFilters" };

    private static final String[] EDOS_WORKSHEET_SEGMENTS = { "MSH", "MFI",
            "NTE", "MFE", "OM1", "OM2", "OM3", "OM4", "OM5", "CDM", "MSA",
            "ERR", "PM1", "OMC", "MCP" };

    private static final String[] EDOS_WORKSHEET_MESSAGES = { "M04 Messages",
            "M08 Messages", "M10 Messages", "M18 Messages", "MFK Messages" };

    private static final String[] EDOS_WORKSHEET_MESSAGE_DESCRIPTION = {
            "Message Description", "MFK Message Description" };

    // validation and generation artifacts
    private static final String CONFORMANCE_PROFILE = "/Global/Profiles/eDOS_integration_profile.xml";
    private static final String CONFORMANCE_CONTEXT = "/Global/Constraints/eDOS_conformance_context.xml";
    private static final String EMPTY_CONFORMANCE_CONTEXT = "/Global/empty/empty_conformance_context.xml";

    // private static final String DISPLAY = "Datasheet display";

    // validation and generation artifacts
    private static final Map<String, String> GROUP_STRUCTURE;
    private static final Map<String, String> GROUP_TRIGGER;

    // private static final Map<String, String> PROFILES;
    private static final String[] TABLES = {

    "/Global/tables/eDOS_constrained_HL7_tables.xml",
            "/Global/tables/eDOS_unconstrained_code_systems.xml",
            "/Global/tables/eDOS_external.xml",
            "/Global/tables/eDOS_merged.xml", "/Global/tables/eDOS_0396.xml",
            "/Global/tables/HL7tableV2.5.1.xml" };
    // private static final Map<String, String> DYNAMIC_DATATYPES;
    // private static final List<String> TABLE_EXCLUSIONS;

    // documentation
    private static final String EMPTY_XML = "/Global/xslt/empty.xml";

    private static final String TEST_STORY_XSLT = "/xslt/test-story-generic.xslt";
    // private static final String DATASHEET_XSLT =
    // "/xslt/datasheet-generic.xslt";
    // private static final String DATASHEET_TO_XSLT =
    // "/xslt/datasheet-to-xml.xslt";
    private static final String MESSAGE_CONTENT_XSLT = "/Global/xslt/message-content-generic_PDF.xsl";

    private static final String PACKAGE_AGGREGATOR_XSLT = "/Global/xslt/package-aggregator.xslt";
    private static final String ER7_XSLT = "/Global/xslt/er7.xslt";

    private static final String TESTDATASPEC_XSLT = "/Global/xslt/testdata-specification-HTML.xsl";
    private static final String TESTDATASPEC_GENERIC_HTML = "/Global/html/TestDataSpecification_generic.html";

    private static final String JUROR_XSLT = "/Global/xslt/JurorSpec_v2_10272015.xsl";
    private static final String JUROR_FILTER_XSLT = "/Global/xslt/juror_filter.xslt";
    static {
        GROUP_STRUCTURE = new HashMap<String, String>();
        GROUP_STRUCTURE.put("MFN_M04_GU", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFN_M04_NG", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFN_M08_GU", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFN_M08_NG", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFN_M10_GU", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFN_M10_NG", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFN_M18_GU", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFN_M18_NG", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFK_M04_GU", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFK_M04_NG", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFK_M08_GU", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFK_M08_NG", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFK_M10_GU", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFK_M10_NG", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFK_M18_GU", "/ProfileLibraries/json/groups.json");
        GROUP_STRUCTURE.put("MFK_M18_NG", "/ProfileLibraries/json/groups.json");

        GROUP_TRIGGER = new HashMap<String, String>();
        GROUP_TRIGGER.put("MFN_M04_GU", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFN_M04_NG", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFN_M08_GU", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFN_M08_NG", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFN_M10_GU", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFN_M10_NG", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFN_M18_GU", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFN_M18_NG", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFK_M04_GU", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFK_M04_NG", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFK_M08_GU", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFK_M08_NG", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFK_M10_GU", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFK_M10_NG", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFK_M18_GU", "/ProfileLibraries/json/trigger.json");
        GROUP_TRIGGER.put("MFK_M18_NG", "/ProfileLibraries/json/trigger.json");

        // PROFILES = new HashMap<String, String>();
        // PROFILES.put("M04_GU", "/Global/profiles/M04/eDOS_MFN_M04_GU.xml");
        // PROFILES.put("M04_NG", "/Global/profiles/M04/eDOS_MFN_M04_NG.xml");
        //
        // PROFILES.put("M08_GU", "/Global/profiles/M08/eDOS_MFN_M08_GU.xml");
        // PROFILES.put("M08_NG", "/Global/profiles/M08/eDOS_MFN_M08_NG.xml");
        //
        // PROFILES.put("M10_GU", "/Global/profiles/M10/eDOS_MFN_M10_GU.xml");
        // PROFILES.put("M10_NG", "/Global/profiles/M10/eDOS_MFN_M10_NG.xml");
        //
        // PROFILES.put("MFK_M04_GU",
        // "/Global/profiles/M04/eDOS_MFK_M04_GU.xml");
        // PROFILES.put("MFK_M04_NG",
        // "/Global/profiles/M04/eDOS_MFK_M04_NG.xml");
        //
        // PROFILES.put("MFK_M08_GU",
        // "/Global/profiles/M08/eDOS_MFK_M08_GU.xml");
        // PROFILES.put("MFK_M08_NG",
        // "/Global/profiles/M08/eDOS_MFK_M08_NG.xml");
        //
        // PROFILES.put("MFK_M10_GU",
        // "/Global/profiles/M10/eDOS_MFK_M10_GU.xml");
        // PROFILES.put("MFK_M10_NG",
        // "/Global/profiles/M10/eDOS_MFK_M10_NG.xml");

        // DYNAMIC_DATATYPES = new HashMap<String, String>();
        //
        // TABLE_EXCLUSIONS = new ArrayList<String>();
        // TABLE_EXCLUSIONS.add("SNOMED_CT;HL70487");
        // TABLE_EXCLUSIONS.add("9999");
        // // TMP
        // TABLE_EXCLUSIONS.add("eDOS_HL70088");

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

    // public String[] getTSV_LISTINGS() {
    // return EDOS_TSV_LISTINGS;
    // }

    public String[] getWORKSHEET_SEGMENTS() {
        return EDOS_WORKSHEET_SEGMENTS;
    }

    public String[] getWORKSHEET_MESSAGES() {
        return EDOS_WORKSHEET_MESSAGES;
    }

    public String[] getWORKSHEET_MESSAGE_DESCRIPTION() {
        return EDOS_WORKSHEET_MESSAGE_DESCRIPTION;
    }

    // public Map<String, String> getPROFILES() {
    // return PROFILES;
    // }

    public String[] getTABLES() {
        return TABLES;
    }

    // public Map<String, String> getDYNAMIC_DATATYPES() {
    // return DYNAMIC_DATATYPES;
    // }

    public String getEMPTY_XML() {
        return EMPTY_XML;
    }

    public String getTEST_STORY_XSLT() {
        return TEST_STORY_XSLT;
    }

    // public String getDATASHEET_XSLT() {
    // return DATASHEET_XSLT;
    // }

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

    public String getJUROR_FILTER_XSLT() {
        return JUROR_FILTER_XSLT;
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
    public String getCONFORMANCE_PROFILE() {
        return CONFORMANCE_PROFILE;
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
    public String getEMPTY_CONFORMANCE_CONTEXT() {
        return EMPTY_CONFORMANCE_CONTEXT;
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
