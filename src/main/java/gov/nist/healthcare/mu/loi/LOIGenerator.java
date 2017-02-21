/*
 * NIST Healthcare
 * BundleGenerator.java Mar 11, 2013
 *
 * This code was produced by the National Institute of Standards and
 * Technology (NIST). See the "nist.disclaimer" file given in the distribution
 * for information on the use and redistribution of this software.
 */
package gov.nist.healthcare.mu.loi;

import gov.nist.healthcare.mu.bundle.BundleGenerator;
import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestCase;
import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestCaseGroup;
import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestPlan;
import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestStep;
import gov.nist.healthcare.mu.bundle.util.PDFUtil;
import gov.nist.healthcare.mu.spreadsheet.model.TestCaseMetadata;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Random;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.AndFileFilter;
import org.apache.commons.io.filefilter.FileFilterUtils;
import org.apache.commons.io.filefilter.IOFileFilter;
import org.apache.commons.io.filefilter.NameFileFilter;
import org.apache.commons.io.filefilter.NotFileFilter;
import org.apache.commons.io.filefilter.PrefixFileFilter;
import org.apache.commons.io.filefilter.SuffixFileFilter;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * LOI resource bundle generator
 * 
 * @author Caroline Rosin (NIST)
 */
public class LOIGenerator extends BundleGenerator {

    private static Logger logger = Logger.getLogger(LOIGenerator.class.getName());
    private static String[] zipExclusion = { "LOI_8", "LOI_5.1", "LOI_3.1" };

    private static Map<String, String> folderMapping;

    static {
        folderMapping = new HashMap<String, String>();
        /* GU */
        folderMapping.put("LOI_0.0_1.1-GU", "/1-GU/1-PT/1-");
        folderMapping.put("ACK_0.0_1.1-GU", "/1-GU/1-PT/2-");
        folderMapping.put("ORL_0.0_1.1-GU", "/1-GU/1-PT/3-");
        folderMapping.put("ACK_0.0_2.1-GU", "/1-GU/1-PT/4-");

        folderMapping.put("LOI_1.0_1.1-GU", "/1-GU/2-Sed Rate/1-");
        folderMapping.put("LOI_1.0_2.1-GU_CP", "/1-GU/2-Sed Rate/2-");
        // folderMapping.put("LOI_1.0_3.1-GU_CL", "/1-GU/2-Sed Rate/3-");

        folderMapping.put("LOI_2.0_1.1-GU", "/1-GU/3-CBC/1-");
        folderMapping.put("LOI_2.0_2.1-GU_CL", "/1-GU/3-CBC/2-");

        folderMapping.put("LOI_3.0_1.1-GU", "/1-GU/4-Lipid Panel/1-");
        folderMapping.put("LOI_3.1_1.1-GU_FI", "/1-GU/4-Lipid Panel/2-");

        folderMapping.put("LOI_4.0_1.1-GU", "/1-GU/5-Culture and Suscep/1-");

        folderMapping.put("LOI_5.0_1.1-GU", "/1-GU/6-Reflex Hepatitis/1-");
        folderMapping.put("LOI_5.1_1.1-GU_PH", "/1-GU/6-Reflex Hepatitis/2-");

        folderMapping.put("LOI_6.0_1.1-GU", "/1-GU/7-Pap Smear/1-");

        folderMapping.put("LOI_7.0_1.1-GU_PRU", "/1-GU/8-GHP/1-PRU/1-");
        folderMapping.put("LOI_7.0_2.1-GU_PRU", "/1-GU/8-GHP/1-PRU/2-");
        folderMapping.put("LOI_7.0_1.1-GU_PRN", "/1-GU/8-GHP/2-PRN/1-");
        folderMapping.put("LOI_7.0_2.1-GU_PRN", "/1-GU/8-GHP/2-PRN/2-");

        folderMapping.put("LOI_8.0_1.1-GU", "/1-GU/9-Diabetic Profile/1-");

        folderMapping.put("LOI_9.0_1.1-GU_PRU",
                "/1-GU/10-Creatinine Clearance/1-PRU/1-");
        folderMapping.put("LOI_9.0_1.1-GU_PRN",
                "/1-GU/10-Creatinine Clearance/2-PRN/1-");

        folderMapping.put("LOI_10.0_1.1-GU", "/1-GU/11-Prostate Biopsy/1-");
        /* NG */
        folderMapping.put("LOI_0.0_1.1-NG", "/2-NG/1-PT/1-");
        folderMapping.put("ACK_0.0_1.1-NG", "/2-NG/1-PT/2-");
        folderMapping.put("ORL_0.0_1.1-NG", "/2-NG/1-PT/3-");
        folderMapping.put("ACK_0.0_2.1-NG", "/2-NG/1-PT/4-");

        folderMapping.put("LOI_1.0_1.1-NG", "/2-NG/2-Sed Rate/1-");
        folderMapping.put("LOI_1.0_2.1-NG_CP", "/2-NG/2-Sed Rate/2-");
        // folderMapping.put("LOI_1.0_3.1-NG_CL", "/2-NG/2-Sed Rate/3-");

        folderMapping.put("LOI_2.0_1.1-NG", "/2-NG/3-CBC/1-");
        folderMapping.put("LOI_2.0_2.1-NG_CL", "/2-NG/3-CBC/2-");

        folderMapping.put("LOI_3.0_1.1-NG", "/2-NG/4-Lipid Panel/1-");
        folderMapping.put("LOI_3.1_1.1-NG_FI", "/2-NG/4-Lipid Panel/2-");

        folderMapping.put("LOI_4.0_1.1-NG", "/2-NG/5-Culture and Suscep/1-");

        folderMapping.put("LOI_5.0_1.1-NG", "/2-NG/6-Reflex Hepatitis/1-");
        folderMapping.put("LOI_5.1_1.1-NG_PH", "/2-NG/6-Reflex Hepatitis/2-");

        folderMapping.put("LOI_6.0_1.1-NG", "/2-NG/7-Pap Smear/1-");

        folderMapping.put("LOI_7.0_1.1-NG_PRU", "/2-NG/8-GHP/1-PRU/1-");
        folderMapping.put("LOI_7.0_2.1-NG_PRU", "/2-NG/8-GHP/1-PRU/2-");
        folderMapping.put("LOI_7.0_1.1-NG_PRN", "/2-NG/8-GHP/2-PRN/1-");
        folderMapping.put("LOI_7.0_2.1-NG_PRN", "/2-NG/8-GHP/2-PRN/2-");

        folderMapping.put("LOI_8.0_1.1-NG", "/2-NG/9-Diabetic Profile/1-");

        folderMapping.put("LOI_9.0_1.1-NG_PRU",
                "/2-NG/10-Creatinine Clearance/1-PRU/1-");
        folderMapping.put("LOI_9.0_1.1-NG_PRN",
                "/2-NG/10-Creatinine Clearance/2-PRN/1-");

        folderMapping.put("LOI_10.0_1.1-NG", "/2-NG/11-Prostate Biopsy/1-");
    }

    /**
     * @param args
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {

        long startTime = System.currentTimeMillis();
        LOIGenerator generator = new LOIGenerator();

        File contextBased = new File(generator.getContext().getTESTCASE_DIR_F());
        File contextFree = new File(
                generator.getContext().getCONTEXT_FREE_DIR_F());

        String[] loi = { "LOI" };
        String[] orl = { "ORL" };
        String[] ack = { "ACK" };

        // deleteFiles("TestDataSpecification", ".html", contextBased);
        // deleteFiles("TestDataSpecification", ".pdf", contextBased);

        // copyFile("JurorDocument_", "JurorDocument.html", f);
        // deleteFiles("JurorDocument_", ".html", f);
        // deleteFiles("Juror", ".xml", f);
        // deleteFiles("JurorDocument", ".html", f);
        // deleteFiles("JurorDocument", ".pdf", f);

        deleteFiles("TestStory", ".html", contextBased);
        deleteFiles("TestStory", ".pdf", contextBased);
        deleteFiles("TestStory", ".json", contextBased);

        sortStories(contextBased);
        copyFile("TestStory_", "TestStory.xml", contextBased);
        deleteFiles("TestStory_", ".xml", contextBased);

        // deleteFiles("Constraints.", ".json", f);
        // deleteFiles("Constraints.", ".xml", f);

        // deleteFiles("Message.", ".txt", f);
        // deleteFiles("Message.", ".xml", f);
        // deleteFiles("Message.", ".html", f);

        // deleteFiles("MessageContent", ".xml", f);
        // deleteFiles("MessageContent", ".html", f);
        // deleteFiles("MessageContent", ".pdf", f);

        // generator.init(loi, "LOI-EHR");
        // generator.init(orl, "LOI-EHR");
        // generator.init(ack, "LOI-EHR");

        /* XML MESSAGES */
        // generator.generateMessageXML(f);
        // generator.generateMessage_HTML(f);

        /* MESSAGE CONTENT */
        // generator.generateMessageContent_HTML(f);

        /* TEST DATA SPECIFICATION */
        // String[] ehrsToLis = { "*LOI*" };
        // String[] lisToEhrs = { "*ORL*", "*ACK*" };
        //
        // List<String> all = new ArrayList<String>();
        // String[] none = { "" };
        //
        // all.addAll(Arrays.asList(ehrsToLis));
        // all.addAll(Arrays.asList(lisToEhrs));
        //
        // IOFileFilter autoTds = new WildcardFileFilter(all);
        // IOFileFilter genericTds = new WildcardFileFilter(none);
        // generator.generateTDS(contextBased, autoTds, genericTds);

        /* JUROR DOCUMENTS */

        /* TEST STORIES */
        generator.generateTestStory_HTML(contextBased);

        // generate PDFs
        IOFileFilter tdsFilter = new NameFileFilter(
                "TestDataSpecification_pdf.html");
        generator.generatePDFs(contextBased, tdsFilter);

        IOFileFilter messageContentFilter = new NameFileFilter(
                "MessageContent.html");
        generator.generatePDFs(contextBased, messageContentFilter);

        IOFileFilter jurorDocumentFilter = new NameFileFilter(
                "JurorDocument.html");
        generator.generatePDFs(contextBased, jurorDocumentFilter);

        IOFileFilter testStory = new NameFileFilter("TestStory.html");
        generator.generatePDFs(contextBased, testStory);

        // generator.update(f);
        generator.setIds(contextFree, contextBased);

        long endTime = System.currentTimeMillis();
        logger.info("total time : " + (endTime - startTime) / 1000 + " seconds");

        File zip = new File("loi-xml-messages.zip");
        zip("Message.xml", zip, contextBased);

        /* Generate test package at test step level */
        IOFileFilter testCaseFilter = new NameFileFilter("TestStep.json");
        Collection<File> testSteps = FileUtils.listFiles(contextBased,
                testCaseFilter, FileFilterUtils.trueFileFilter());

        for (File testStep : testSteps) {
            File stepDir = testStep.getParentFile();
            File pdfFile = new File(stepDir, "TestPackage.pdf");
            List<File> files = new ArrayList<File>();
            File ts = new File(stepDir, "TestStory.html");
            File mc = new File(stepDir, "MessageContent.html");
            File tds = new File(stepDir, "TestDataSpecification_pdf.html");
            File jd = new File(stepDir, "JurorDocument.html");
            File m = new File(stepDir, "Message.html");

            if (ts.exists()) {
                files.add(ts);
            }
            if (mc.exists()) {
                files.add(mc);
            }
            if (tds.exists()) {
                files.add(tds);
            }
            if (jd.exists()) {
                files.add(jd);
            }
            if (m.exists()) {
                files.add(m);
            }
            if (files.size() > 0) {
                PDFUtil.genPDF(files, pdfFile);
            }
        }
    }

    public LOIGenerator() {
        context = new LOIContext();
    }

    private static void sortStories(File contextBased) throws IOException {

        // GU
        File GU = new File(contextBased, "GU");

        moveIfExists(FileUtils.getFile(GU, "TestStory_GU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU"));

        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI-EHR Test Plan.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR"));

        // PT INR
        moveIfExists(FileUtils.getFile(GU, "TestStory_PT and INR.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "1-PT"));
        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_0.0_1.1-GU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "1-PT",
                        "1-LOI_0.0_1.1-GU"));
        moveIfExists(FileUtils.getFile(GU, "TestStory_ACK_0.0_1.1-GU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "1-PT",
                        "2-ACK_0.0_1.1-GU"));
        moveIfExists(FileUtils.getFile(GU, "TestStory_ORL_0.0_1.1-GU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "1-PT",
                        "3-ORL_0.0_1.1-GU"));
        moveIfExists(FileUtils.getFile(GU, "TestStory_ACK_0.0_2.1-GU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "1-PT",
                        "4-ACK_0.0_2.1-GU"));

        // Sed rate
        moveIfExists(
                FileUtils.getFile(GU, "TestStory_Sed Rate.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "2-Sed Rate"));
        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_1.0_1.1-GU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "2-Sed Rate", "1-LOI_1.0_1.1-GU"));

        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_1.0_2.1-GU_CP.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "2-Sed Rate", "2-LOI_1.0_2.1-GU_CP"));

        // CBC
        moveIfExists(FileUtils.getFile(GU, "TestStory_CBC.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "3-CBC"));
        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_2.0_1.1-GU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "3-CBC",
                        "1-LOI_2.0_1.1-GU"));

        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_2.0_2.1-GU_CL.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "3-CBC",
                        "2-LOI_2.0_2.1-GU_CL"));

        // LipidPanel
        moveIfExists(FileUtils.getFile(GU, "TestStory_Lipid Panel.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "4-Lipid Panel"));
        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_3.0_1.1-GU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "4-Lipid Panel", "1-LOI_3.0_1.1-GU"));

        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_3.1_1.1-GU_FI.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "4-Lipid Panel", "2-LOI_3.1_1.1-GU_FI"));

        // Culture and Suscep
        moveIfExists(FileUtils.getFile(GU, "TestStory_Culture_and_Suscep.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "5-Culture and Suscep"));
        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_4.0_1.1-GU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "5-Culture and Suscep", "1-LOI_4.0_1.1-GU"));

        // Reflex Hepatitis
        moveIfExists(FileUtils.getFile(GU, "TestStory_Reflex_Hepatitis.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "6-Reflex Hepatitis"));

        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_5.0_1.1-GU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "6-Reflex Hepatitis", "1-LOI_5.0_1.1-GU"));

        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_5.1_1.1-GU-PH.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "6-Reflex Hepatitis", "2-LOI_5.1_1.1-GU_PH"));

        // Pap Smear
        moveIfExists(FileUtils.getFile(GU, "TestStory_Pap_Smear.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "7-Pap Smear"));
        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_6.0_1.1-GU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "7-Pap Smear", "1-LOI_6.0_1.1-GU"));

        // GHP
        moveIfExists(FileUtils.getFile(GU, "TestStory_GHP_Header.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "8-GHP"));
        moveIfExists(FileUtils.getFile(GU, "TestStory_GHP_PRU_Header.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "8-GHP",
                        "1-PRU"));
        moveIfExists(FileUtils.getFile(GU, "TestStory_GHP_PRN_Header.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "8-GHP",
                        "2-PRN"));

        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_7.0_1.1-GU_PRU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "8-GHP",
                        "1-PRU", "1-LOI_7.0_1.1-GU_PRU"));

        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_7.0_2.1-GU_PRU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "8-GHP",
                        "1-PRU", "2-LOI_7.0_2.1-GU_PRU"));

        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_7.0_1.1-GU_PRN.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "8-GHP",
                        "2-PRN", "1-LOI_7.0_1.1-GU_PRN"));

        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_7.0_2.1-GU_PRN.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU", "8-GHP",
                        "2-PRN", "2-LOI_7.0_2.1-GU_PRN"));

        // Creatinine Clearance
        moveIfExists(FileUtils.getFile(GU,
                "TestStory_Creatinine_Clearance_Header.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "10-Creatinine Clearance"));

        moveIfExists(FileUtils.getFile(GU,
                "TestStory_Creatinine_Clearance_PRU_Header.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "10-Creatinine Clearance", "1-PRU"));

        moveIfExists(FileUtils.getFile(GU,
                "TestStory_Creatinine_Clearance_PRN_Header.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "10-Creatinine Clearance", "2-PRN"));

        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_9.0_1.1-GU_PRU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "10-Creatinine Clearance", "1-PRU",
                        "1-LOI_9.0_1.1-GU_PRU"));

        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_9.0_1.1-GU_PRN.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "10-Creatinine Clearance", "2-PRN",
                        "1-LOI_9.0_1.1-GU_PRN"));

        // Prostate Biopsy
        moveIfExists(FileUtils.getFile(GU,
                "TestStory_Prostate_Biopsy_Header.xml"), FileUtils.getFile(
                contextBased, "LOI-EHR", "1-GU", "11-Prostate Biopsy"));
        moveIfExists(FileUtils.getFile(GU, "TestStory_LOI_10.0_1.1-GU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "1-GU",
                        "11-Prostate Biopsy", "1-LOI_10.0_1.1-GU"));

        if (GU.exists()) {
            deleteFiles(
                    "TestStory_New test case names - message IDs in template",
                    "xml", GU);
            deleteFiles("TestStory_NG", "xml", GU);
            if (GU.list().length == 0) {
                FileUtils.deleteDirectory(GU);

            }
        }

        // NG
        File NG = new File(contextBased, "NG");

        moveIfExists(FileUtils.getFile(NG, "TestStory_NG.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG"));

        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI-EHR Test Plan.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR"));

        // PT INR
        moveIfExists(FileUtils.getFile(NG, "TestStory_PT and INR.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "1-PT"));
        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_0.0_1.1-NG.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "1-PT",
                        "1-LOI_0.0_1.1-NG"));
        moveIfExists(FileUtils.getFile(NG, "TestStory_ACK_0.0_1.1-NG.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "1-PT",
                        "2-ACK_0.0_1.1-NG"));
        moveIfExists(FileUtils.getFile(NG, "TestStory_ORL_0.0_1.1-NG.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "1-PT",
                        "3-ORL_0.0_1.1-NG"));
        moveIfExists(FileUtils.getFile(NG, "TestStory_ACK_0.0_2.1-NG.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "1-PT",
                        "4-ACK_0.0_2.1-NG"));

        // Sed rate
        moveIfExists(
                FileUtils.getFile(NG, "TestStory_Sed Rate.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "2-Sed Rate"));
        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_1.0_1.1-NG.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "2-Sed Rate", "1-LOI_1.0_1.1-NG"));

        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_1.0_2.1-NG_CP.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "2-Sed Rate", "2-LOI_1.0_2.1-NG_CP"));

        // CBC
        moveIfExists(FileUtils.getFile(NG, "TestStory_CBC.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "3-CBC"));
        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_2.0_1.1-NG.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "3-CBC",
                        "1-LOI_2.0_1.1-NG"));

        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_2.0_2.1-NG_CL.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "3-CBC",
                        "2-LOI_2.0_2.1-NG_CL"));

        // LipidPanel
        moveIfExists(FileUtils.getFile(NG, "TestStory_Lipid Panel.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "4-Lipid Panel"));
        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_3.0_1.1-NG.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "4-Lipid Panel", "1-LOI_3.0_1.1-NG"));

        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_3.1_1.1-NG_FI.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "4-Lipid Panel", "2-LOI_3.1_1.1-NG_FI"));

        // Culture and Suscep
        moveIfExists(FileUtils.getFile(NG, "TestStory_Culture_and_Suscep.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "5-Culture and Suscep"));
        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_4.0_1.1-NG.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "5-Culture and Suscep", "1-LOI_4.0_1.1-NG"));

        // Reflex Hepatitis
        moveIfExists(FileUtils.getFile(NG, "TestStory_Reflex_Hepatitis.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "6-Reflex Hepatitis"));

        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_5.0_1.1-NG.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "6-Reflex Hepatitis", "1-LOI_5.0_1.1-NG"));

        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_5.1_1.1-NG-PH.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "6-Reflex Hepatitis", "2-LOI_5.1_1.1-NG_PH"));

        // Pap Smear
        moveIfExists(FileUtils.getFile(NG, "TestStory_Pap_Smear.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "7-Pap Smear"));
        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_6.0_1.1-NG.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "7-Pap Smear", "1-LOI_6.0_1.1-NG"));

        // GHP
        moveIfExists(FileUtils.getFile(NG, "TestStory_GHP_Header.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "8-GHP"));
        moveIfExists(FileUtils.getFile(NG, "TestStory_GHP_PRU_Header.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "8-GHP",
                        "1-PRU"));
        moveIfExists(FileUtils.getFile(NG, "TestStory_GHP_PRN_Header.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "8-GHP",
                        "2-PRN"));

        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_7.0_1.1-NG_PRU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "8-GHP",
                        "1-PRU", "1-LOI_7.0_1.1-NG_PRU"));

        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_7.0_2.1-NG_PRU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "8-GHP",
                        "1-PRU", "2-LOI_7.0_2.1-NG_PRU"));

        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_7.0_1.1-NG_PRN.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "8-GHP",
                        "2-PRN", "1-LOI_7.0_1.1-NG_PRN"));

        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_7.0_2.1-NG_PRN.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG", "8-GHP",
                        "2-PRN", "2-LOI_7.0_2.1-NG_PRN"));

        // Creatinine Clearance
        moveIfExists(FileUtils.getFile(NG,
                "TestStory_Creatinine_Clearance_Header.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "10-Creatinine Clearance"));

        moveIfExists(FileUtils.getFile(NG,
                "TestStory_Creatinine_Clearance_PRU_Header.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "10-Creatinine Clearance", "1-PRU"));

        moveIfExists(FileUtils.getFile(NG,
                "TestStory_Creatinine_Clearance_PRN_Header.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "10-Creatinine Clearance", "2-PRN"));

        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_9.0_1.1-NG_PRU.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "10-Creatinine Clearance", "1-PRU",
                        "1-LOI_9.0_1.1-NG_PRU"));

        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_9.0_1.1-NG_PRN.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "10-Creatinine Clearance", "2-PRN",
                        "1-LOI_9.0_1.1-NG_PRN"));

        // Prostate Biopsy
        moveIfExists(FileUtils.getFile(NG,
                "TestStory_Prostate_Biopsy_Header.xml"), FileUtils.getFile(
                contextBased, "LOI-EHR", "2-NG", "11-Prostate Biopsy"));
        moveIfExists(FileUtils.getFile(NG, "TestStory_LOI_10.0_1.1-NG.xml"),
                FileUtils.getFile(contextBased, "LOI-EHR", "2-NG",
                        "11-Prostate Biopsy", "1-LOI_10.0_1.1-NG"));

        if (NG.exists()) {
            deleteFiles(
                    "TestStory_New test case names - message IDs in template",
                    "xml", NG);
            deleteFiles("TestStory_GU", "xml", NG);
            if (NG.list().length == 0) {
                FileUtils.deleteDirectory(NG);

            }
        }

    }

    private static void moveIfExists(File source, File destDir)
            throws IOException {
        if (source.exists()) {
            File f = new File(destDir, source.getName());
            if (f.exists()) {
                FileUtils.deleteQuietly(f);
            }
            FileUtils.moveFileToDirectory(source, destDir, false);
        }
    }

    private void setIds(File contextFree, File contextBased) throws IOException {
        List<String> names = Arrays.asList("TestObject.json", "TestPlan.json",
                "TestCaseGroup.json", "TestCase.json", "TestStep.json");
        NameFileFilter filter = new NameFileFilter(names);

        Collection<File> files = FileUtils.listFiles(contextFree, filter,
                FileFilterUtils.trueFileFilter());
        files.addAll(FileUtils.listFiles(contextBased, filter,
                FileFilterUtils.trueFileFilter()));

        ObjectMapper mapper = new ObjectMapper();
        mapper.enable(SerializationFeature.INDENT_OUTPUT);
        Random r = new Random();
        for (File file : files) {
            JsonNode root = mapper.readTree(file);
            long l = r.nextLong();
            ((ObjectNode) root).put("id", l);
            mapper.writeValue(file, root);
        }
    }

    private static void copyFile(String prefixFilter, String name,
            File rootDirectory) throws IOException {
        IOFileFilter filter = new PrefixFileFilter(prefixFilter);
        Collection<File> files = FileUtils.listFiles(rootDirectory, filter,
                FileFilterUtils.trueFileFilter());
        for (File file : files) {
            File dest = new File(file.getParent(), name);
            logger.info(String.format("Copying %s to %s",
                    file.getAbsoluteFile(), dest.getAbsolutePath()));
            FileUtils.copyFile(file, dest);
        }
    }

    private static void deleteFiles(String prefixFilter, String suffixFilter,
            File rootDirectory) {
        IOFileFilter pFilter = new PrefixFileFilter(prefixFilter);
        IOFileFilter sFilter = new SuffixFileFilter(suffixFilter);
        IOFileFilter and = new AndFileFilter(pFilter, sFilter);
        Collection<File> files = FileUtils.listFiles(rootDirectory, and,
                FileFilterUtils.trueFileFilter());
        for (File file : files) {
            logger.info(String.format("Delete %s", file.getAbsoluteFile()));
            FileUtils.deleteQuietly(file);
        }
    }

    private static void zip(String suffix, File dest, File root)
            throws IOException {
        IOFileFilter filter = new SuffixFileFilter(suffix);
        Collection<File> files = FileUtils.listFiles(root, filter,
                FileFilterUtils.trueFileFilter());
        ZipOutputStream out = new ZipOutputStream(new FileOutputStream(dest));
        for (File file : files) {
            if (file.isFile()) {
                FileInputStream in = new FileInputStream(file);
                String path = file.getPath();
                String trim = root.getPath() + "\\";
                String zipPath = path.substring(path.indexOf(trim)
                        + trim.length());
                out.putNextEntry(new ZipEntry(zipPath));
                // buffer size
                byte[] b = new byte[1024];
                int count;
                while ((count = in.read(b)) > 0) {
                    out.write(b, 0, count);
                }
                in.close();
            }
        }
        out.close();
    }

    // TODO find a better name...
    private void update(File f) throws IOException {
        // create the test plans
        CustomFilter custom = new CustomFilter(f);
        Collection<File> testPlans = FileUtils.listFilesAndDirs(f,
                FileFilterUtils.falseFileFilter(), custom);
        int idx = 0;
        for (File testPlan : testPlans) {
            idx++;
            // create test plan.json
            File fTestPlan = new File(testPlan, "TestPlan.json");
            JTestPlan jTestPlan = createTestPlanJson(testPlan.getName());
            // JTestPlan jTestPlan = createTestPlanJson("LOI-EHR");
            jTestPlan.setPosition(idx);
            FileUtils.writeStringToFile(fTestPlan, jTestPlan.toJson(), false);
        }
        // create/update the test steps
        Set<File> testCaseFolders = new HashSet<File>();
        Collection<File> testSteps = FileUtils.listFiles(f, new NameFileFilter(
                "TestStep.json"), FileFilterUtils.trueFileFilter());
        for (File testStep : testSteps) {
            // test step folder
            File tStepFolder = testStep.getParentFile();
            String parent = tStepFolder.getName();
            String[] split = StringUtils.split(parent, "-", 2);
            if (split[0].matches("\\d+")) {
                String json = FileUtils.readFileToString(testStep);
                JTestStep jTestStep = JTestStep.fromJson(json);
                jTestStep.setPosition(Integer.parseInt(split[0]));
                jTestStep.setDescription(split[1]);
                FileUtils.writeStringToFile(testStep, jTestStep.toJson(), false);
            }
            // test case folder
            File tCaseFolder = tStepFolder.getParentFile();
            testCaseFolders.add(tCaseFolder);
        }
        // create/update the test cases
        for (File testCaseFolder : testCaseFolders) {
            String name = testCaseFolder.getName();
            String[] split = StringUtils.split(name, "-", 2);
            if (split[0].matches("\\d+")) {
                File testCase = new File(testCaseFolder, "TestCase.json");
                JTestCase jTestCase = new JTestCase();
                jTestCase.setPosition(Integer.parseInt(split[0]));
                jTestCase.setDescription(split[1]);
                jTestCase.setName(StringUtils.replace(split[1], "_", " "));
                FileUtils.writeStringToFile(testCase, jTestCase.toJson(), false);
            }
        }
        // create/update the test groups folders : find all directories that do
        // not contain TestStep/TestCase/TestPlan
        // new NotFileFilter(new NameFileFilter("TestStep.json"))
        Collection<File> directories = FileUtils.listFilesAndDirs(f,
                FileFilterUtils.falseFileFilter(),
                FileFilterUtils.trueFileFilter());
        for (File directory : directories) {
            // System.out.println(ftest.getName());
            File testCase = new File(directory, "TestCase.json");
            File testStep = new File(directory, "TestStep.json");
            File testPlan = new File(directory, "TestPlan.json");
            File testCaseGroup = new File(directory, "TestCaseGroup.json");

            if (testCaseGroup.exists()) {
                // the file already exists : update it
                String name = directory.getName();
                String[] split = StringUtils.split(name, "-", 2);
                if (split[0].matches("\\d+")) {
                    JTestCaseGroup jTestCaseGroup = new JTestCaseGroup();
                    jTestCaseGroup.setPosition(Integer.parseInt(split[0]));
                    jTestCaseGroup.setDescription(split[1]);
                    jTestCaseGroup.setName(StringUtils.replace(split[1], "_",
                            " "));
                    FileUtils.writeStringToFile(testCaseGroup,
                            jTestCaseGroup.toJson(), false);
                }
            }
            if (!testCaseGroup.exists() && !testStep.exists()
                    && !testCase.exists() && !testPlan.exists()) {
                // this is not a TestStep, TestCase or TestPlan : create
                // TestCaseGroup.json
                String name = directory.getName();
                String[] split = StringUtils.split(name, "-", 2);
                if (split[0].matches("\\d+")) {
                    JTestCaseGroup jTestCaseGroup = new JTestCaseGroup();
                    jTestCaseGroup.setPosition(Integer.parseInt(split[0]));
                    jTestCaseGroup.setDescription(split[1]);
                    jTestCaseGroup.setName(StringUtils.replace(split[1], "_",
                            " "));
                    FileUtils.writeStringToFile(testCaseGroup,
                            jTestCaseGroup.toJson(), false);
                }
            }
        }
    }

    private void cleanZipDir() {
        File f = new File("./src/main/resources/Documentation/LOI_Test_Plan");
        String[] extensions = { "zip" };
        Collection<File> zipFiles = FileUtils.listFiles(f, extensions, false);
        for (File zipFile : zipFiles) {
            zipFile.delete();
        }
    }

    private void zipExampleMessages() throws IOException {
        Properties properties = new Properties();
        properties.load(LOIGenerator.class.getClassLoader().getResourceAsStream(
                "maven.properties"));
        String v = properties.getProperty("version");
        String zipDir = "./src/main/resources/Documentation/LOI_Test_Plan";
        String zipName = String.format("%s/LOI-ExampleMessages-%s.zip", zipDir,
                v.replaceAll("-SNAPSHOT", ""));
        File f = new File(context.getTESTCASE_DIR_F());

        // file suffix is "Message.txt";
        SuffixFileFilter messageFilter = new SuffixFileFilter("Message.txt");

        // dir filter
        List<IOFileFilter> exclude = new ArrayList<IOFileFilter>();
        for (String toExclude : zipExclusion) {
            exclude.add(new NotFileFilter(new PrefixFileFilter(toExclude)));
        }
        AndFileFilter exclusionFilter = new AndFileFilter(exclude);
        Collection<File> files = FileUtils.listFilesAndDirs(f, messageFilter,
                exclusionFilter);

        // create zip
        // output file
        ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipName));
        // input
        for (File file : files) {
            if (file.isFile()) {
                FileInputStream in = new FileInputStream(file);
                String path = file.getPath();
                String trim = f.getPath() + "\\";
                String zipPath = path.substring(path.indexOf(trim)
                        + trim.length());
                out.putNextEntry(new ZipEntry(zipPath));
                // buffer size
                byte[] b = new byte[1024];
                int count;
                while ((count = in.read(b)) > 0) {
                    out.write(b, 0, count);
                }
                in.close();
            }
        }
        out.close();
    }

    private void zipTestPackageData() throws IOException {

        Properties properties = new Properties();
        properties.load(LOIGenerator.class.getClassLoader().getResourceAsStream(
                "maven.properties"));
        String v = properties.getProperty("version");

        String zipDir = "./src/main/resources/Documentation/LOI_Test_Plan";
        String zipName = String.format("%s/LOI-TestData-%s.zip", zipDir,
                v.replaceAll("-SNAPSHOT", ""));

        File f = new File(context.getTESTCASE_DIR_F());

        // file suffix is "Message.txt";
        SuffixFileFilter testPackageFilter = new SuffixFileFilter(
                "TestPackage.pdf");

        // dir filter
        List<IOFileFilter> exclude = new ArrayList<IOFileFilter>();
        for (String toExclude : zipExclusion) {
            exclude.add(new NotFileFilter(new PrefixFileFilter(toExclude)));
        }
        AndFileFilter exclusionFilter = new AndFileFilter(exclude);
        Collection<File> files = FileUtils.listFilesAndDirs(f,
                testPackageFilter, exclusionFilter);

        // create zip
        // output file
        ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipName));
        // input
        for (File file : files) {
            if (file.isFile()) {
                FileInputStream in = new FileInputStream(file);
                String path = file.getPath();
                String trim = f.getPath() + "\\";
                String zipPath = path.substring(path.indexOf(trim)
                        + trim.length());
                out.putNextEntry(new ZipEntry(zipPath));
                // buffer size
                byte[] b = new byte[1024];
                int count;
                while ((count = in.read(b)) > 0) {
                    out.write(b, 0, count);
                }
                in.close();
            }
        }
        out.close();
    }

    private List<String> extractProfiles(String identifier) {
        ArrayList<String> profiles = new ArrayList<String>(
                Arrays.asList(identifier.split("_")));
        return profiles;
    }

    // private void fixPosition() throws IOException {
    // String dir = getContext().getTESTCASE_DIR_F();
    // File directory = new File(dir);
    // // get all the test plans
    // IOFileFilter testplan = new NameFileFilter("TestPlan.json");
    // Collection<File> plans = FileUtils.listFiles(directory, testplan,
    // FileFilterUtils.trueFileFilter());
    // int tplanIdx = 0;
    // for (File plan : plans) {
    // tplanIdx++;
    // JTestPlan jPlan = JTestPlan.fromJson(FileUtils.readFileToString(plan));
    // jPlan.setPosition(tplanIdx);
    // FileUtils.writeStringToFile(plan, jPlan.toJson(), false);
    // IOFileFilter testgroup = new NameFileFilter("TestCaseGroup.json");
    // Collection<File> groups = FileUtils.listFiles(plan.getParentFile(),
    // testgroup, FileFilterUtils.trueFileFilter());
    // int tgIdx = 0;
    // for (File group : groups) {
    // tgIdx++;
    // JTestCaseGroup jgroup =
    // JTestCaseGroup.fromJson(FileUtils.readFileToString(group));
    // jgroup.setPosition(tgIdx);
    // FileUtils.writeStringToFile(group, jgroup.toJson(), false);
    // IOFileFilter testcase = new NameFileFilter("TestCase.json");
    // Collection<File> cases = FileUtils.listFiles(
    // group.getParentFile(), testcase,
    // FileFilterUtils.trueFileFilter());
    // int tcIdx = 0;
    // for (File tcase : cases) {
    // tcIdx++;
    // JTestCase jCase = JTestCase.fromJson(FileUtils.readFileToString(tcase));
    // String name = jCase.getName();
    // String position = name.replaceAll("\\D", "");
    // jCase.setPosition(Integer.parseInt(position) + 1);
    // FileUtils.writeStringToFile(tcase, jCase.toJson(), false);
    // IOFileFilter teststep = new NameFileFilter("TestStep.json");
    // Collection<File> steps = FileUtils.listFiles(
    // tcase.getParentFile(), teststep,
    // FileFilterUtils.trueFileFilter());
    // int tsIdx = 0;
    // for (File step : steps) {
    // tsIdx++;
    // JTestStep jStep = JTestStep.fromJson(FileUtils.readFileToString(step));
    // // String name = jStep.getName();
    // // String prefix = name.substring(0, name.indexOf("."));
    // // String position = prefix.replaceAll("\\D", "");
    // jStep.setPosition(tsIdx);
    // FileUtils.writeStringToFile(step, jStep.toJson(), false);
    // }
    // }
    // }
    // }
    // }

    @Override
    protected String getTestStepFolder(String prefix, TestCaseMetadata metadata) {

        List<String> result = _getTestStepFolder(prefix, metadata);
        return StringUtils.join(result, "/");

        // List<String> result = _getTestStepFolder(prefix, obj);
        //
        // // create test plan folder/json
        // String dir = getContext().getTESTCASE_DIR_F();
        // File f = new File(dir);
        // String domain = result.get(0);
        // File testPlanFolder = new File(f, domain);
        // File tpJson = new File(testPlanFolder, "TestPlan.json");
        // JTestPlan tp = createTestPlanJson(domain);
        // try {
        // FileUtils.writeStringToFile(tpJson, tp.toJson(), false);
        // } catch (IOException e) {
        // e.printStackTrace();
        // }
        //
        // // create first test group folder/json
        // String group = result.get(1);
        // File testGroupFolder = new File(testPlanFolder, group);
        // File tgJson = new File(testGroupFolder, "TestCaseGroup.json");
        // JTestCaseGroup tg = createTestCaseGroupJson(domain, group);
        // try {
        // FileUtils.writeStringToFile(tgJson, tg.toJson(), false);
        // } catch (IOException e) {
        // e.printStackTrace();
        // }
        //
        // // create test case folder
        // String testcase = result.get(2);
        // File testCaseFolder = new File(testGroupFolder, testcase);
        // File tcJson = new File(testCaseFolder, "TestCase.json");
        // JTestCase tc = createTestCaseJson(testcase);
        // try {
        // FileUtils.writeStringToFile(tcJson, tc.toJson(), false);
        // } catch (IOException e) {
        // e.printStackTrace();
        // }
        //
        // return StringUtils.join(result, "/");

    }

    // private JTestCase createTestCaseJson(String tcName) {
    // JTestCase tc = new JTestCase();
    // String name = String.format("%s test case", tcName);
    // String description = String.format("This is the %s test case.", tcName);
    // tc.setName(name);
    // tc.setDescription(description);
    // tc.setType(JTestCase.Type.DataInstance);
    // tc.setSut(JTestCase.Sut.Initiator);
    // return tc;
    // }
    //
    // private JTestCaseGroup createTestCaseGroupJson(String domain, String
    // profile) {
    // JTestCaseGroup tg = new JTestCaseGroup();
    // String name = String.format("%s %s test group", domain, profile);
    // String description = String.format("This is the %s %s test group.",
    // domain, profile);
    // tg.setName(name);
    // tg.setDescription(description);
    // return tg;
    // }

    // private FileFilter directoryFilter = new FileFilter() {
    // public boolean accept(File file) {
    // return file.isDirectory();
    // }
    // };

    // private List<String> _getTestStepFolder(String prefix, TestCaseMetadata
    // obj) {
    // List<String> result = new ArrayList<String>();
    // String msgId = obj.getIdentifier();
    // TestCaseIdentifier identifier = TestCaseIdentifier.parse(msgId);
    // // level 1 : prefix (TEST PLAN)
    // result.add(prefix);
    // // level 2 : GU/NG (TEST GROUP)
    // List<String> profiles = extractProfiles(identifier.getProfile());
    // result.add(profiles.get(0));
    // // level 3 : LOI_SCENARIO_DESCRIPTION (TEST CASE)
    // result.add(String.format("%s_%s_%s",
    // identifier.getPrefix().toUpperCase(), identifier.getScenario(),
    // obj.getShortDescription()));
    // // level 4 : TEST STEP
    // result.add(String.format("%s_%s_%s", identifier.toString(),
    // obj.getShortDescription(), obj.getTag()));
    // return result;
    // }

    @Override
    protected String getArtifactNameSuffix(String prefix, TestCaseMetadata arg1) {
        return "";
        // return getArtifactNameSuffix(arg1);
    }

    private JTestPlan createTestPlanJson(String domain) {
        JTestPlan tp = new JTestPlan();
        String name = String.format("%s Test Plan", domain);
        String description = String.format("This is the %s test plan.", domain);
        tp.setName(name);
        tp.setDescription(description);
        return tp;
    }

    private List<String> _getTestStepFolder(String prefix,
            TestCaseMetadata metadata) {
        List<String> result = new ArrayList<String>();
        String msgId = metadata.getIdentifier();
        result.add(prefix);
        if (!folderMapping.containsKey(msgId)) {
            throw new RuntimeException("No folder defined for " + msgId);
        }
        String folder = folderMapping.get(msgId) + msgId;
        List<String> tmp = Arrays.asList(StringUtils.split(folder, "/"));
        result.addAll(tmp);

        return result;
    }

    private class CustomFilter implements IOFileFilter {

        private File parent;

        protected CustomFilter(File parent) {
            this.parent = parent;
        }

        @Override
        public boolean accept(File file) {
            return parent.equals(file.getParentFile());
        }

        @Override
        public boolean accept(File dir, String name) {
            return parent.equals(dir);
        }

    }
}
