/*
 * NIST Healthcare
 * BundleGenerator.java Mar 11, 2013
 *
 * This code was produced by the National Institute of Standards and
 * Technology (NIST). See the "nist.disclaimer" file given in the distribution
 * for information on the use and redistribution of this software.
 */
package gov.nist.healthcare.mu.edos;

import gov.nist.healthcare.mu.bundle.BundleGenerator;
import gov.nist.healthcare.mu.bundle.documentation.DocumentGenerator;
import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestCase;
import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestCaseGroup;
import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestPlan;
import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestStep;
import gov.nist.healthcare.mu.spreadsheet.model.TestCaseIdentifier;
import gov.nist.healthcare.mu.spreadsheet.model.TestCaseMetadata;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Random;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
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
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * eDOS resource bundle generator
 * 
 * @author Caroline Rosin (NIST)
 */
public class EDOSGenerator extends BundleGenerator {

    private static Logger logger = Logger.getLogger(EDOSGenerator.class.getName());
    private static String[] zipExclusion = { "MFK" };

    private static Map<String, String> folderMapping;

    static {
        folderMapping = new HashMap<String, String>();

        folderMapping.put("EDOS_0.0_1.1-M08_GU",
                "/1-GU/1-EDOS_0/1-Smoke Test/1-");
        folderMapping.put("MFK_0.0_1.1-MFK_M08_GU",
                "/1-GU/1-EDOS_0/1-Smoke Test/2-");
        folderMapping.put("EDOS_0.0_2.1-M10_GU",
                "/1-GU/1-EDOS_0/1-Smoke Test/3-");
        folderMapping.put("MFK_0.0_2.1-MFK_M10_GU",
                "/1-GU/1-EDOS_0/1-Smoke Test/4-");
        folderMapping.put("EDOS_0.0_3.1-M04_GU",
                "/1-GU/1-EDOS_0/1-Smoke Test/5-");
        folderMapping.put("MFK_0.0_3.1-MFK_M04_GU",
                "/1-GU/1-EDOS_0/1-Smoke Test/6-");
        folderMapping.put("EDOS_0.0_4.1-M18_GU",
                "/1-GU/1-EDOS_0/1-Smoke Test/7-");
        folderMapping.put("MFK_0.0_4.1-MFK_M18_GU",
                "/1-GU/1-EDOS_0/1-Smoke Test/8-");

        folderMapping.put("EDOS_1.0_1.1-M08_GU",
                "/1-GU/2-EDOS_1/1-Initial load/1-");
        folderMapping.put("EDOS_1.0_2.1-M10_GU",
                "/1-GU/2-EDOS_1/1-Initial load/2-");
        folderMapping.put("EDOS_1.0_3.1-M04_GU",
                "/1-GU/2-EDOS_1/1-Initial load/3-");
        folderMapping.put("EDOS_1.0_4.1-M18_GU",
                "/1-GU/2-EDOS_1/1-Initial load/4-");
        folderMapping.put("EDOS_1.0_5.1-M18_GU",
                "/1-GU/2-EDOS_1/1-Initial load/5-");

        folderMapping.put("EDOS_2.0_1.1-M08_GU",
                "/1-GU/3-EDOS_2/1-Update_deactivate/1-");
        folderMapping.put("EDOS_2.0_2.1-M10_GU",
                "/1-GU/3-EDOS_2/1-Update_deactivate/2-");
        folderMapping.put("EDOS_2.0_3.1-M04_GU",
                "/1-GU/3-EDOS_2/1-Update_deactivate/3-");
        folderMapping.put("EDOS_2.0_4.1-M18_GU",
                "/1-GU/3-EDOS_2/1-Update_deactivate/4-");

        folderMapping.put("EDOS_2.1_1.1-M08_GU",
                "/1-GU/3-EDOS_2/2-Update_add/1-");
        folderMapping.put("EDOS_2.1_2.1-M10_GU",
                "/1-GU/3-EDOS_2/2-Update_add/2-");
        folderMapping.put("EDOS_2.1_3.1-M04_GU",
                "/1-GU/3-EDOS_2/2-Update_add/3-");
        folderMapping.put("EDOS_2.1_4.1-M18_GU",
                "/1-GU/3-EDOS_2/2-Update_add/4-");

        folderMapping.put("EDOS_2.2_1.1-M08_GU",
                "/1-GU/3-EDOS_2/3-Update_revise/1-");
        folderMapping.put("EDOS_2.2_2.1-M10_GU",
                "/1-GU/3-EDOS_2/3-Update_revise/2-");
        folderMapping.put("EDOS_2.2_3.1-M04_GU",
                "/1-GU/3-EDOS_2/3-Update_revise/3-");
        folderMapping.put("EDOS_2.2_4.1-M18_GU",
                "/1-GU/3-EDOS_2/3-Update_revise/4-");

        folderMapping.put("EDOS_2.3_1.1-M08_GU",
                "/1-GU/3-EDOS_2/4-Update_reactivate/1-");
        folderMapping.put("EDOS_2.3_2.1-M10_GU",
                "/1-GU/3-EDOS_2/4-Update_reactivate/2-");
        folderMapping.put("EDOS_2.3_3.1-M04_GU",
                "/1-GU/3-EDOS_2/4-Update_reactivate/3-");
        folderMapping.put("EDOS_2.3_4.1-M18_GU",
                "/1-GU/3-EDOS_2/4-Update_reactivate/4-");

        folderMapping.put("EDOS_2.4_1.1-M08_GU",
                "/1-GU/3-EDOS_2/5-Update_combo/1-");
        folderMapping.put("EDOS_2.4_2.1-M10_GU",
                "/1-GU/3-EDOS_2/5-Update_combo/2-");
        folderMapping.put("EDOS_2.4_3.1-M04_GU",
                "/1-GU/3-EDOS_2/5-Update_combo/3-");
        folderMapping.put("EDOS_2.4_4.1-M18_GU",
                "/1-GU/3-EDOS_2/5-Update_combo/4-");

        folderMapping.put("EDOS_2.5_1.1-M08_GU",
                "/1-GU/3-EDOS_2/6-Update_revise_postCombo/1-");
        folderMapping.put("EDOS_2.5_2.1-M10_GU",
                "/1-GU/3-EDOS_2/6-Update_revise_postCombo/2-");
        folderMapping.put("EDOS_2.5_3.1-M04_GU",
                "/1-GU/3-EDOS_2/6-Update_revise_postCombo/3-");
        folderMapping.put("EDOS_2.5_4.1-M18_GU",
                "/1-GU/3-EDOS_2/6-Update_revise_postCombo/4-");

        folderMapping.put("EDOS_0.0_1.1-M08_NG",
                "/2-NG/1-EDOS_0/1-Smoke Test/1-");
        folderMapping.put("MFK_0.0_1.1-MFK_M08_NG",
                "/2-NG/1-EDOS_0/1-Smoke Test/2-");
        folderMapping.put("EDOS_0.0_2.1-M10_NG",
                "/2-NG/1-EDOS_0/1-Smoke Test/3-");
        folderMapping.put("MFK_0.0_2.1-MFK_M10_NG",
                "/2-NG/1-EDOS_0/1-Smoke Test/4-");
        folderMapping.put("EDOS_0.0_3.1-M04_NG",
                "/2-NG/1-EDOS_0/1-Smoke Test/5-");
        folderMapping.put("MFK_0.0_3.1-MFK_M04_NG",
                "/2-NG/1-EDOS_0/1-Smoke Test/6-");
        folderMapping.put("EDOS_0.0_4.1-M18_NG",
                "/2-NG/1-EDOS_0/1-Smoke Test/7-");
        folderMapping.put("MFK_0.0_4.1-MFK_M18_NG",
                "/2-NG/1-EDOS_0/1-Smoke Test/8-");

        folderMapping.put("EDOS_1.0_1.1-M08_NG",
                "/2-NG/2-EDOS_1/1-Initial load/1-");
        folderMapping.put("EDOS_1.0_2.1-M10_NG",
                "/2-NG/2-EDOS_1/1-Initial load/2-");
        folderMapping.put("EDOS_1.0_3.1-M04_NG",
                "/2-NG/2-EDOS_1/1-Initial load/3-");
        folderMapping.put("EDOS_1.0_4.1-M18_NG",
                "/2-NG/2-EDOS_1/1-Initial load/4-");
        folderMapping.put("EDOS_1.0_5.1-M18_NG",
                "/2-NG/2-EDOS_1/1-Initial load/5-");

        folderMapping.put("EDOS_2.0_1.1-M08_NG",
                "/2-NG/3-EDOS_2/1-Update_deactivate/1-");
        folderMapping.put("EDOS_2.0_2.1-M10_NG",
                "/2-NG/3-EDOS_2/1-Update_deactivate/2-");
        folderMapping.put("EDOS_2.0_3.1-M04_NG",
                "/2-NG/3-EDOS_2/1-Update_deactivate/3-");
        folderMapping.put("EDOS_2.0_4.1-M18_NG",
                "/2-NG/3-EDOS_2/1-Update_deactivate/4-");

        folderMapping.put("EDOS_2.1_1.1-M08_NG",
                "/2-NG/3-EDOS_2/2-Update_add/1-");
        folderMapping.put("EDOS_2.1_2.1-M10_NG",
                "/2-NG/3-EDOS_2/2-Update_add/2-");
        folderMapping.put("EDOS_2.1_3.1-M04_NG",
                "/2-NG/3-EDOS_2/2-Update_add/3-");
        folderMapping.put("EDOS_2.1_4.1-M18_NG",
                "/2-NG/3-EDOS_2/2-Update_add/4-");

        folderMapping.put("EDOS_2.2_1.1-M08_NG",
                "/2-NG/3-EDOS_2/3-Update_revise/1-");
        folderMapping.put("EDOS_2.2_2.1-M10_NG",
                "/2-NG/3-EDOS_2/3-Update_revise/2-");
        folderMapping.put("EDOS_2.2_3.1-M04_NG",
                "/2-NG/3-EDOS_2/3-Update_revise/3-");
        folderMapping.put("EDOS_2.2_4.1-M18_NG",
                "/2-NG/3-EDOS_2/3-Update_revise/4-");

        folderMapping.put("EDOS_2.3_1.1-M08_NG",
                "/2-NG/3-EDOS_2/4-Update_reactivate/1-");
        folderMapping.put("EDOS_2.3_2.1-M10_NG",
                "/2-NG/3-EDOS_2/4-Update_reactivate/2-");
        folderMapping.put("EDOS_2.3_3.1-M04_NG",
                "/2-NG/3-EDOS_2/4-Update_reactivate/3-");
        folderMapping.put("EDOS_2.3_4.1-M18_NG",
                "/2-NG/3-EDOS_2/4-Update_reactivate/4-");

        folderMapping.put("EDOS_2.4_1.1-M08_NG",
                "/2-NG/3-EDOS_2/5-Update_combo/1-");
        folderMapping.put("EDOS_2.4_2.1-M10_NG",
                "/2-NG/3-EDOS_2/5-Update_combo/2-");
        folderMapping.put("EDOS_2.4_3.1-M04_NG",
                "/2-NG/3-EDOS_2/5-Update_combo/3-");
        folderMapping.put("EDOS_2.4_4.1-M18_NG",
                "/2-NG/3-EDOS_2/5-Update_combo/4-");

        folderMapping.put("EDOS_2.5_1.1-M08_NG",
                "/2-NG/3-EDOS_2/6-Update_revise_postCombo/1-");
        folderMapping.put("EDOS_2.5_2.1-M10_NG",
                "/2-NG/3-EDOS_2/6-Update_revise_postCombo/2-");
        folderMapping.put("EDOS_2.5_3.1-M04_NG",
                "/2-NG/3-EDOS_2/6-Update_revise_postCombo/3-");
        folderMapping.put("EDOS_2.5_4.1-M18_NG",
                "/2-NG/3-EDOS_2/6-Update_revise_postCombo/4-");
    }

    /**
     * @param args
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {

        long startTime = System.currentTimeMillis();
        EDOSGenerator generator = new EDOSGenerator();

        File contextBased = new File(generator.getContext().getTESTCASE_DIR_F());
        File contextFree = new File(
                generator.getContext().getCONTEXT_FREE_DIR_F());

        String dir = generator.getContext().getTESTCASE_DIR_F();
        File testCasesDir = new File(dir);

        /* Uncomment to rename TestStory files */
        // copyFile("TestStory_", "TestStory.xml", testCasesDir);

        /* uncomment to create zip */
        // File zip = new File("JurorDocuments.zip");
        // File f2 = new File(testCasesDir, "EHR");
        // zip("JurorData.xml", zip, f2);

        String[] lis = { "EDOS", "MFK" };
        String[] ehr = { "EDOS", "MFK" };

        /*
         * Uncomment to launch spreadsheet processing : - creates ER7 message -
         * creates test step specific validation context
         */
        // deleteFiles("Message", ".txt", testCasesDir);
        // deleteFiles("Message", ".html", testCasesDir);
        // deleteFiles("Message", ".xml", testCasesDir);
        // deleteFiles("Message", ".html", testCasesDir);
        // deleteFiles("Message", ".pdf", testCasesDir);
        //
        // deleteFiles("Constraints", ".xml", testCasesDir);
        // deleteFiles("Constraints", ".json", testCasesDir);
        //
        generator.init(lis, "LIS");
        generator.init(ehr, "EHR");

        /* XML MESSAGE */
        // generator.generateMessageXML(testCasesDir);
        // generator.generateMessage_HTML(testCasesDir);
        // generator.generateMessageContent_HTML(testCasesDir);

        /*
         * LIS = lab EHR = provider
         */
        // String[] labToProvider = { "*EDOS_0.0*", "*EDOS_1.0*", "*EDOS_2.1*",
        // "*EDOS_2.2*", "*EDOS_2.3*", "*EDOS_2.4*", "*EDOS_2.5*" };
        // String[] providerToLab = { "*MFK_0.0*" };

        /* TDS */
        // deleteFiles("TestDataSpecification", ".html", testCasesDir);
        // deleteFiles("TestDataSpecification", ".pdf", testCasesDir);
        // deleteFiles("TestDataSpecification", ".json", testCasesDir);
        // deleteFiles("TestDataSpecification", ".xml", testCasesDir);

        // // IOFileFilter autoTds = null;
        // // IOFileFilter genericTds = null;
        // IOFileFilter autoTds = new WildcardFileFilter(Arrays.asList("*"));
        // IOFileFilter genericTds = new WildcardFileFilter(Arrays.asList(""));
        //
        // generator.generateTDS(testCasesDir, autoTds, genericTds);

        /* TEST STORY */
        // deleteFiles("TestStory", ".html", testCasesDir);
        // deleteFiles("TestStory", ".pdf", testCasesDir);
        // deleteFiles("TestStory", ".json", testCasesDir);
        //
        // generator.generateTestStory_HTML(testCasesDir);

        /* JUROR */
        // String[] juror = { "*Smoke Test*", "*Smoke test*", "*Initial load*",
        // "*Update_*" };
        // IOFileFilter ehrAutoJuror = new WildcardFileFilter(juror);
        // IOFileFilter ehrGenericJuror = FileFilterUtils.falseFileFilter();
        //
        // File EHRTestCasesDir = new File(testCasesDir, "EHR");
        // deleteFiles("Juror", ".xml", EHRTestCasesDir);
        // deleteFiles("JurorDocument", ".html", EHRTestCasesDir);
        // deleteFiles("JurorDocument", ".pdf", EHRTestCasesDir);
        // generator.mergeXmlStepMessages(EHRTestCasesDir);
        // generator.generateEHRJuror(EHRTestCasesDir, ehrAutoJuror,
        // ehrGenericJuror);

        // No need for html juror in LIS (hardcoded)
        // IOFileFilter lisAutoJuror = FileFilterUtils.falseFileFilter();
        // IOFileFilter lisGenericJuror=null;
        // File LISTestCasesDir = new File(testCasesDir, "LIS");
        // generator.generateJuror(LISTestCasesDir,lisAutoJuror,lisGenericJuror);

        /* PDF generation */
        // IOFileFilter testStoryFilter = new NameFileFilter("TestStory.html");
        // generator.generatePDFs(testCasesDir, testStoryFilter);
        //
        // IOFileFilter messageContentFilter = new NameFileFilter(
        // "MessageContent.html");
        // generator.generatePDFs(testCasesDir, messageContentFilter);
        //
        // IOFileFilter tdsFilter = new NameFileFilter(
        // "TestDataSpecification_pdf.html");
        // generator.generatePDFs(testCasesDir, tdsFilter);
        //
        // IOFileFilter jurorFilter = new
        // NameFileFilter("JurorDocument_pdf.html");
        // generator.generatePDFs(testCasesDir, jurorFilter);
        //
        generator.update(testCasesDir);

        /* TEST PACKAGE */
        // deleteFiles("TestPackage", ".pdf", testCasesDir);
        // /* 1. Generate test package at test step level */
        // IOFileFilter stepFilter = new NameFileFilter("TestStep.json");
        // Collection<File> steps = FileUtils.listFiles(testCasesDir,
        // stepFilter,
        // FileFilterUtils.trueFileFilter());
        //
        // for (File step : steps) {
        // File stepDir = step.getParentFile();
        // File pdfFile = new File(stepDir, "TestPackage.pdf");
        // List<File> files = new ArrayList<File>();
        // File ts = new File(stepDir, "TestStory.html");
        // File mc = new File(stepDir, "MessageContent.html");
        // File tds = new File(stepDir, "TestDataSpecification_pdf.html");
        // File m = new File(stepDir, "Message.html");
        //
        // if (ts.exists()) {
        // files.add(ts);
        // }
        // if (mc.exists()) {
        // files.add(mc);
        // }
        // if (tds.exists()) {
        // files.add(tds);
        // }
        // if (m.exists()) {
        // files.add(m);
        // }
        // if (files.size() > 0) {
        // PDFUtil.genPDF(files, pdfFile);
        // }
        // }
        //
        // /* 2. Generate test package at test case level */
        // IOFileFilter testCaseFilter = new NameFileFilter("TestCase.json");
        // Collection<File> testCases = FileUtils.listFiles(testCasesDir,
        // testCaseFilter, FileFilterUtils.trueFileFilter());
        //
        // for (File testCase : testCases) {
        // File testCaseDir = testCase.getParentFile();
        // File pdfFile = new File(testCaseDir, "TestPackage.pdf");
        // List<File> files = new ArrayList<File>();
        // File ts = new File(testCaseDir, "TestStory.html");
        // File jd = new File(testCaseDir, "JurorDocument_pdf.html");
        //
        // if (ts.exists()) {
        // files.add(ts);
        // }
        // if (jd.exists()) {
        // files.add(jd);
        // }
        //
        // if (files.size() > 0) {
        // PDFUtil.genPDF(files, pdfFile);
        // }
        // }

        /* set ids */
        generator.setIds(contextFree, contextBased);

        long endTime = System.currentTimeMillis();
        logger.info("total time : " + (endTime - startTime) / 1000 + " seconds");
    }

    private void generateEHRJuror(File dir, IOFileFilter autoJuror,
            IOFileFilter genericJuror) throws Exception {
        // generate the HTML from the xml and then the pdf from the html
        generateJuror(dir, autoJuror, genericJuror);

        // /special treatment for Initial Load : generate partial & full
        // juror

        // full juror document was created during generic procedure, rename to
        // "full"
        // find the directory first

        IOFileFilter dirFilter = new SuffixFileFilter("Initial load");
        IOFileFilter fileFilter = new PrefixFileFilter(Arrays.asList(
                "JurorData", "JurorDocument"));
        MyDirectoryWalker walker = new MyDirectoryWalker(fileFilter, dirFilter);
        List<File> files = walker.getFiles(dir);
        for (File file : files) {
            File full = new File(file.getParent(), "Full_" + file.getName());
            logger.info(String.format("Copying %s to %s",
                    file.getAbsoluteFile(), full.getAbsolutePath()));
            FileUtils.copyFile(file, full);
        }
        // filter JurorData based on input from SMEs : use juror_filter.xslt
        // regenerate html & pdf

        IOFileFilter fullData = new PrefixFileFilter("Full_JurorData");
        Collection<File> fullDataXmls = FileUtils.listFiles(dir, fullData,
                FileFilterUtils.trueFileFilter());
        for (File fullDataXml : fullDataXmls) {
            FileInputStream xmlFileStream = new FileInputStream(fullDataXml);
            File partialDataXml = new File(fullDataXml.getParentFile(),
                    "Partial_JurorData.xml");

            File instructionsFile = new File(fullDataXml.getParentFile(),
                    "JurorInstructions.txt");
            String instr = "";
            if (instructionsFile.exists()) {
                instr = FileUtils.readFileToString(instructionsFile);
            }

            String partialXml = DocumentGenerator.generate(
                    ((EDOSContext) context).getJUROR_FILTER_XSLT(),
                    partialDataXml, xmlFileStream);
            xmlFileStream.close();

            // TODO add instructions to HTML
            // generate juror html
            File htmlFile = new File(fullDataXml.getParentFile(),
                    "JurorDocument.html");
            FileInputStream xmlFileStream2 = new FileInputStream(partialDataXml);
            // String html = DocumentGenerator.generate(
            // context.getJUROR_HTML_XSLT(), htmlFile, xmlFileStream2);

            Map<String, Object> xslParams = new HashMap<String, Object>();
            if (!"".equals(instr)) {
                xslParams.put("instructions", instr);
            }
            String html = DocumentGenerator.generate(context.getJUROR_XSLT(),
                    htmlFile, xmlFileStream2, xslParams);

            // System.err.println(html);

            xmlFileStream2.close();

        }
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
            jTestPlan.setPosition(idx);
            jTestPlan.setDescription("");
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

    private static void renameDir(String nameFilter, String name,
            File rootDirectory) throws IOException {
        IOFileFilter filter = new NameFileFilter(nameFilter);
        Collection<File> files = FileUtils.listFilesAndDirs(rootDirectory,
                filter, FileFilterUtils.trueFileFilter());
        for (File file : files) {
            if (file.isDirectory() && nameFilter.equals(file.getName())) {
                // System.err.println(file.getName());
                File dest = new File(file.getParent(), name);
                logger.info(String.format("Renaming %s to %s",
                        file.getAbsoluteFile(), dest.getAbsolutePath()));
                FileUtils.copyDirectory(file, dest);
            }
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

    public EDOSGenerator() {
        context = new EDOSContext();
    }

    private void mergeXmlStepMessages(File directory) throws Exception {
        IOFileFilter testcaseFilter = new NameFileFilter("TestCase.json");
        Collection<File> testcases = FileUtils.listFiles(directory,
                testcaseFilter, FileFilterUtils.trueFileFilter());
        for (File testcase : testcases) {
            // get all the steps
            File testcaseDir = testcase.getParentFile();
            IOFileFilter messageFilter = new NameFileFilter("Message.xml");
            Collection<File> messages = FileUtils.listFiles(testcaseDir,
                    messageFilter, FileFilterUtils.trueFileFilter());

            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = dbf.newDocumentBuilder();
            Document doc = builder.newDocument();

            // create the root element node
            Element testCaseElement = doc.createElement("TestCase");
            testCaseElement.setAttribute("id", testcaseDir.getName());
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date();
            testCaseElement.setAttribute("generated", dateFormat.format(date));
            doc.appendChild(testCaseElement);
            Element messagesElement = doc.createElement("Messages");
            testCaseElement.appendChild(messagesElement);
            for (File message : messages) {
                Document messageDoc = builder.parse(message);
                Element messageElement = doc.createElement("Message");
                messageElement.setAttribute("id",
                        messageDoc.getDocumentElement().getNodeName());
                Node n = doc.adoptNode(messageDoc.getDocumentElement());
                messageElement.appendChild(n);
                messagesElement.appendChild(messageElement);
            }
            // prettyPrint(doc);
            TransformerFactory fact = new net.sf.saxon.TransformerFactoryImpl();
            Transformer transformer = fact.newTransformer();
            transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            Result output = new StreamResult(new File(testcaseDir,
                    "JurorData.xml"));
            Source input = new DOMSource(doc);
            transformer.transform(input, output);
        }
    }

    public static final void prettyPrint(Document xml) throws Exception {

        Transformer tf = TransformerFactory.newInstance().newTransformer();
        tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        tf.setOutputProperty(OutputKeys.INDENT, "yes");
        Writer out = new StringWriter();

        tf.transform(new DOMSource(xml), new StreamResult(out));

        System.out.println(out.toString());

    }

    private void fixPosition(String domain) throws IOException {
        String dir = getContext().getTESTCASE_DIR_F();
        File directory = new File(dir, domain);
        // get all the test plans
        IOFileFilter testplan = new NameFileFilter("TestPlan.json");
        Collection<File> plans = FileUtils.listFiles(directory, testplan,
                FileFilterUtils.trueFileFilter());
        int tplanIdx = 0;
        for (File plan : plans) {
            tplanIdx++;
            JTestPlan jPlan = JTestPlan.fromJson(FileUtils.readFileToString(plan));
            jPlan.setPosition(tplanIdx);
            FileUtils.writeStringToFile(plan, jPlan.toJson(), false);
            IOFileFilter testgroup = new NameFileFilter("TestCaseGroup.json");
            Collection<File> groups = FileUtils.listFiles(plan.getParentFile(),
                    testgroup, FileFilterUtils.trueFileFilter());
            int tgIdx = 0;
            for (File group : groups) {
                if (group.getParentFile().getParent().equals(plan.getParent())) {
                    tgIdx++;
                    JTestCaseGroup jgroup = JTestCaseGroup.fromJson(FileUtils.readFileToString(group));
                    jgroup.setPosition(tgIdx);
                    FileUtils.writeStringToFile(group, jgroup.toJson(), false);

                    // second layer of TestCaseGroup
                    Collection<File> groups2 = FileUtils.listFiles(
                            group.getParentFile(), testgroup,
                            FileFilterUtils.trueFileFilter());
                    int tg2Idx = 0;
                    for (File group2 : groups2) {
                        if (!group.equals(group2)) {
                            tg2Idx++;
                            JTestCaseGroup jgroup2 = JTestCaseGroup.fromJson(FileUtils.readFileToString(group2));
                            jgroup2.setPosition(tg2Idx);
                            FileUtils.writeStringToFile(group2,
                                    jgroup2.toJson(), false);
                            IOFileFilter testcase = new NameFileFilter(
                                    "TestCase.json");
                            Collection<File> cases = FileUtils.listFiles(
                                    group2.getParentFile(), testcase,
                                    FileFilterUtils.trueFileFilter());

                            for (File tcase : cases) {
                                int tcIdx = 0;
                                if (tcase.getParentFile().getName().contains(
                                        "Smoke test")
                                        || tcase.getParentFile().getName().contains(
                                                "Initial load")
                                        || tcase.getParentFile().getName().contains(
                                                "Update_deactivate")) {
                                    tcIdx = 1;
                                }
                                if (tcase.getParentFile().getName().contains(
                                        "Update_add")) {
                                    tcIdx = 2;

                                }
                                if (tcase.getParentFile().getName().contains(
                                        "Update_revise")) {
                                    tcIdx = 3;

                                }
                                if (tcase.getParentFile().getName().contains(
                                        "Update_reactivate")) {
                                    tcIdx = 4;

                                }
                                if (tcase.getParentFile().getName().contains(
                                        "Update_combo")) {
                                    tcIdx = 5;

                                }
                                if (tcase.getParentFile().getName().contains(
                                        "Update_revise_postCombo")) {
                                    tcIdx = 6;

                                }
                                JTestCase jCase = JTestCase.fromJson(FileUtils.readFileToString(tcase));
                                jCase.setPosition(tcIdx);
                                FileUtils.writeStringToFile(tcase,
                                        jCase.toJson(), false);
                                IOFileFilter teststep = new NameFileFilter(
                                        "TestStep.json");
                                Collection<File> steps = FileUtils.listFiles(
                                        tcase.getParentFile(), teststep,
                                        FileFilterUtils.trueFileFilter());
                                int tsIdx = 0;
                                for (File step : steps) {
                                    tsIdx++;
                                    JTestStep jStep = JTestStep.fromJson(FileUtils.readFileToString(step));

                                    if ("EHR".equals(domain)
                                            && step.getParentFile().getName().startsWith(
                                                    "MFK")) {
                                        jStep.setType(JTestStep.Type.SUT_RESPONDER);
                                        if (step.getParentFile().getName().contains(
                                                "1.1-")) {
                                            jStep.setPosition(2);

                                        } else if (step.getParentFile().getName().contains(
                                                "2.1-")) {
                                            jStep.setPosition(4);

                                        } else if (step.getParentFile().getName().contains(
                                                "3.1-")) {
                                            jStep.setPosition(6);

                                        } else if (step.getParentFile().getName().contains(
                                                "4.1-")) {
                                            jStep.setPosition(8);

                                        }
                                    } else if ("EHR".equals(domain)
                                            && step.getParentFile().getName().startsWith(
                                                    "EDOS")) {
                                        jStep.setType(JTestStep.Type.TA_INITIATOR);
                                        if (step.getParentFile().getName().contains(
                                                "1.1-")) {
                                            jStep.setPosition(1);
                                        } else if (step.getParentFile().getName().contains(
                                                "2.1-")) {
                                            jStep.setPosition(3);
                                        } else if (step.getParentFile().getName().contains(
                                                "3.1-")) {
                                            jStep.setPosition(5);
                                        } else if (step.getParentFile().getName().contains(
                                                "4.1-")) {
                                            jStep.setPosition(7);
                                        }
                                    }

                                    if ("LIS".equals(domain)) {
                                        if (step.getParentFile().getName().contains(
                                                "1.1-")) {
                                            jStep.setPosition(1);
                                        } else if (step.getParentFile().getName().contains(
                                                "2.1-")) {
                                            jStep.setPosition(2);
                                        } else if (step.getParentFile().getName().contains(
                                                "3.1-")) {
                                            jStep.setPosition(3);
                                        } else if (step.getParentFile().getName().contains(
                                                "4.1-")) {
                                            jStep.setPosition(4);
                                        }
                                    }
                                    FileUtils.writeStringToFile(step,
                                            jStep.toJson(), false);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private void cleanZipDir() throws IOException {
        File f = new File("./src/main/resources/Documentation/eDOS_Test_Plan");
        FileUtils.cleanDirectory(f);
    }

    private void zipExampleMessages() throws IOException {
        Properties properties = new Properties();
        properties.load(EDOSGenerator.class.getClassLoader().getResourceAsStream(
                "maven.properties"));
        String v = properties.getProperty("version");
        String zipDir = "./src/main/resources/Documentation/eDOS_Test_Plan";
        String zipName = String.format("%s/eDOS-ExampleMessages-%s.zip",
                zipDir, v.replaceAll("-SNAPSHOT", ""));
        File f = new File(context.getTESTCASE_DIR_F());

        // file suffix is "Message.txt";
        SuffixFileFilter er7MessageFilter = new SuffixFileFilter("Message.txt");
        SuffixFileFilter xmlMessageFilter = new SuffixFileFilter("Message.xml");
        AndFileFilter messageFilter = new AndFileFilter(er7MessageFilter,
                xmlMessageFilter);

        // dir filter : no MFK
        List<IOFileFilter> exclude = new ArrayList<IOFileFilter>();
        for (String toExclude : zipExclusion) {
            exclude.add(new NotFileFilter(new NameFileFilter(toExclude)));
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
        properties.load(EDOSGenerator.class.getClassLoader().getResourceAsStream(
                "maven.properties"));
        String v = properties.getProperty("version");

        String zipDir = "./src/main/resources/Documentation/eDOS_Test_Plan";
        String zipName = String.format("%s/eDOS-TestData-%s.zip", zipDir,
                v.replaceAll("-SNAPSHOT", ""));

        File f = new File(context.getTESTCASE_DIR_F());

        // file suffix is "Message.txt";
        SuffixFileFilter testPackageFilter = new SuffixFileFilter(
                "TestPackage.pdf");

        // dir filter : no MFK
        List<IOFileFilter> exclude = new ArrayList<IOFileFilter>();
        for (String toExclude : zipExclusion) {
            exclude.add(new NotFileFilter(new NameFileFilter(toExclude)));
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

    /**
     * Extract the test case identifier from the test step identifier
     * 
     * @param stepIdentifier
     * @return
     */
    private String getTestCaseIdentifier(String stepIdentifier) {
        TestCaseIdentifier fullId = TestCaseIdentifier.parse(stepIdentifier);
        String testCaseId = fullId.toShortString()
                + "_"
                + fullId.getProfile().substring(
                        fullId.getProfile().indexOf("_") + 1);
        return testCaseId;
    }

    @Override
    protected String getArtifactNameSuffix(String arg0, TestCaseMetadata obj) {
        return "";
    }

    @Override
    protected String getTestStepFolder(String prefix, TestCaseMetadata metadata) {
        List<String> result = _getTestStepFolder(prefix, metadata);
        return StringUtils.join(result, "/");
    }

    private List<String> _getTestStepFolder(String prefix,
            TestCaseMetadata metadata) {
        List<String> result = new ArrayList<String>();
        String msgId = metadata.getIdentifier();
        // TestCaseIdentifier identifier = TestCaseIdentifier.parse(msgId);
        // level 1 : LIS or EHR
        result.add(prefix);

        if (!folderMapping.containsKey(msgId)) {
            throw new RuntimeException("No folder defined for " + msgId);
        }
        String folder = folderMapping.get(msgId) + msgId;
        List<String> tmp = Arrays.asList(StringUtils.split(folder, "/"));
        result.addAll(tmp);

        // // level 2 : GU/NG
        // result.add(identifier.getProfile().substring(
        // identifier.getProfile().lastIndexOf("_") + 1));
        // // level 3 : EDOS_SCENARIO
        // result.add(String.format("EDOS_%s", identifier.getScenario()));
        // // level 4 : EDOS_SCENARIO
        // result.add(metadata.getTag());
        // // level 5 : test case id
        // result.add(identifier.toString());
        return result;
    }

    private JTestCase createTestCaseJson(String prefix, String tcName) {
        JTestCase tc = new JTestCase();
        String name = String.format("%s", tcName);
        String description = String.format("This is the %s test case.", tcName);
        tc.setName(name);
        tc.setDescription(description);

        // for LIS : DataInstance/Initiator
        // for EHR : Isolated/Receiver

        if ("LIS".equals(prefix)) {
            tc.setType(JTestCase.Type.DataInstance);
            tc.setSut(JTestCase.Sut.Initiator);

        }
        if ("EHR".equals(prefix)) {
            tc.setType(JTestCase.Type.Isolated);
            tc.setSut(JTestCase.Sut.Receiver);
        }
        return tc;
    }

    private JTestCaseGroup createTestCaseGroupJson(String domain, String profile) {
        JTestCaseGroup tg = new JTestCaseGroup();
        String name = String.format("%s", profile);
        String description = String.format("This is the %s %s test group.",
                domain, profile);
        tg.setName(name);
        tg.setDescription(description);
        return tg;
    }

    private JTestPlan createTestPlanJson(String domain) {
        JTestPlan tp = new JTestPlan();
        String name = String.format("%s Test Plan", domain);
        String description = String.format("This is the %s test plan.", domain);
        tp.setName(name);
        tp.setDescription(description);
        return tp;
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

}
