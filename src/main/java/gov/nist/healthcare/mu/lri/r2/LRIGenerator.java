/*
 * NIST Healthcare
 * LRIGenerator.java Dec 15, 2014
 *
 * This code was produced by the National Institute of Standards and
 * Technology (NIST). See the "nist.disclaimer" file given in the distribution
 * for information on the use and redistribution of this software.
 */

package gov.nist.healthcare.mu.lri.r2;

import gov.nist.healthcare.mu.bundle.BundleGenerator;
import gov.nist.healthcare.mu.bundle.documentation.model.json.FileSupplement;
import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestCase;
import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestCaseGroup;
import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestPlan;
import gov.nist.healthcare.mu.bundle.documentation.model.json.JTestStep;
import gov.nist.healthcare.mu.bundle.documentation.model.json.Supplement;
import gov.nist.healthcare.mu.bundle.util.PDFUtil;
import gov.nist.healthcare.mu.spreadsheet.model.TestCaseMetadata;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
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
import org.apache.commons.io.filefilter.TrueFileFilter;
import org.apache.commons.io.filefilter.WildcardFileFilter;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

/**
 * LRI R2 resource bundle generator
 * 
 * @author Caroline Rosin (NIST)
 */
public class LRIGenerator extends BundleGenerator {
    private static Map<String, String> folderMapping;
    private static Map<String, List<Supplement>> supplements;

    static {
        folderMapping = new HashMap<String, String>();
        // PT & INR
        folderMapping.put("LRI_0.0_1.1-GU", "/1-GU/1-PT_and_INR/1-");

        folderMapping.put("ACK_0.0_3.1-GU", "/1-GU/1-PT_and_INR/2-");
        folderMapping.put("ACK_0.0_4.1-GU", "/1-GU/1-PT_and_INR/3-");
        folderMapping.put("ACK_0.0_5.1-GU", "/1-GU/1-PT_and_INR/4-");

        // Sed Rate
        folderMapping.put("LRI_1.0_1.1-GU",
                "/1-GU/2-Sed_rate/1-Final_result_to_corrected/1-");
        // LRI_1.1_1.1-GU is going to be re-numbered to LRI_1.0_2.1-GU
        folderMapping.put("LRI_1.1_1.1-GU",
                "/1-GU/2-Sed_rate/1-Final_result_to_corrected/2-");
        folderMapping.put("LRI_1.0_2.1-GU",
                "/1-GU/2-Sed_rate/1-Final_result_to_corrected/2-");
        folderMapping.put("LRI_1.2_1.1-GU",
                "/1-GU/2-Sed_rate/2-Specimen_rejected/1-");
        // CBC
        folderMapping.put("LRI_2.0_0.1-GU",
                "/1-GU/3-CBC/1-Partial_result_to_final/1-");
        folderMapping.put("LRI_2.0_1.1-GU",
                "/1-GU/3-CBC/1-Partial_result_to_final/2-");
        folderMapping.put("LRI_2.1_1.1-GU",
                "/1-GU/3-CBC/2-Final_result_to_wrong_patient/1-");
        folderMapping.put("LRI_2.1_2.1-GU",
                "/1-GU/3-CBC/2-Final_result_to_wrong_patient/2-");
        folderMapping.put("LRI_2.2_1.1-GU",
                "/1-GU/3-CBC/3-Final_result_to_amended/1-");
        folderMapping.put("LRI_2.2_2.1-GU",
                "/1-GU/3-CBC/3-Final_result_to_amended/2-");

        // Lipid Panel
        folderMapping.put("LRI_3.0_1.1-GU", "/1-GU/4-Lipid_Panel/1-");
        folderMapping.put("LRI_3.0_2.1-GU", "/1-GU/4-Lipid_Panel/2-");
        // Culture_and_Suscep
        folderMapping.put("LRI_4.0_1.1-GU",
                "/1-GU/5-Culture_and_Suscep/1-Preliminary result/1-");
        folderMapping.put("LRI_4.1_2.1-GU_FRU",
                "/1-GU/5-Culture_and_Suscep/2-Final_result_to_corrected_(FRU)/1-");
        folderMapping.put("LRI_4.1_3.1-GU_FRU",
                "/1-GU/5-Culture_and_Suscep/2-Final_result_to_corrected_(FRU)/2-");
        folderMapping.put("LRI_4.1_4.1-GU_FRU",
                "/1-GU/5-Culture_and_Suscep/2-Final_result_to_corrected_(FRU)/3-");
        folderMapping.put("LRI_4.2_2.1-GU_FRN",
                "/1-GU/5-Culture_and_Suscep/3-Final_result_to_corrected_(FRN)/1-");
        folderMapping.put("LRI_4.2_3.1-GU_FRN",
                "/1-GU/5-Culture_and_Suscep/3-Final_result_to_corrected_(FRN)/2-");
        folderMapping.put("LRI_4.2_4.1-GU_FRN",
                "/1-GU/5-Culture_and_Suscep/3-Final_result_to_corrected_(FRN)/3-");
        // Reflex_Hepatitis
        folderMapping.put("LRI_5.0_1.1-GU_FRU",
                "/1-GU/6-Reflex Hepatitis/1-Parent child(FRU)/1-");
        folderMapping.put("LRI_5.0_2.1-GU_FRU",
                "/1-GU/6-Reflex Hepatitis/1-Parent child(FRU)/2-");
        folderMapping.put("LRI_5.1_1.1-GU_FRN",
                "/1-GU/6-Reflex Hepatitis/2-Parent child(FRN)/1-");
        folderMapping.put("LRI_5.1_2.1-GU_FRN",
                "/1-GU/6-Reflex Hepatitis/2-Parent child(FRN)/2-");

        // Pap Smear
        folderMapping.put("LRI_6.0_1.1-GU", "/1-GU/7-Pap_Smear/1-");
        // GHP
        folderMapping.put("LRI_7.0_1.1-GU", "/1-GU/8-GHP/1-");

        // PT & INR
        folderMapping.put("LRI_0.0_1.1-NG", "/2-NG/1-PT_and_INR/1-");
        folderMapping.put("ACK_0.0_3.1-NG", "/2-NG/1-PT_and_INR/2-");
        folderMapping.put("ACK_0.0_4.1-NG", "/2-NG/1-PT_and_INR/3-");
        folderMapping.put("ACK_0.0_5.1-NG", "/2-NG/1-PT_and_INR/4-");

        // Sed Rate
        folderMapping.put("LRI_1.0_1.1-NG",
                "/2-NG/2-Sed_rate/1-Final_result_to_corrected/1-");
        // LRI_1.1_1.1-NG is going to be re-numbered to LRI_1.0_2.1-NG
        folderMapping.put("LRI_1.1_1.1-NG",
                "/2-NG/2-Sed_rate/1-Final_result_to_corrected/2-");
        folderMapping.put("LRI_1.0_2.1-NG",
                "/2-NG/2-Sed_rate/1-Final_result_to_corrected/2-");
        folderMapping.put("LRI_1.2_1.1-NG",
                "/2-NG/2-Sed_rate/2-Specimen_rejected/1-");
        // CBC
        folderMapping.put("LRI_2.0_0.1-NG",
                "/2-NG/3-CBC/1-Partial_result_to_final/1-");
        folderMapping.put("LRI_2.0_1.1-NG",
                "/2-NG/3-CBC/1-Partial_result_to_final/2-");
        folderMapping.put("LRI_2.1_1.1-NG",
                "/2-NG/3-CBC/2-Final_result_to_wrong_patient/1-");
        folderMapping.put("LRI_2.1_2.1-NG",
                "/2-NG/3-CBC/2-Final_result_to_wrong_patient/2-");
        folderMapping.put("LRI_2.2_1.1-NG",
                "/2-NG/3-CBC/3-Final_result_to_amended/1-");
        folderMapping.put("LRI_2.2_2.1-NG",
                "/2-NG/3-CBC/3-Final_result_to_amended/2-");
        // Lipid Panel
        folderMapping.put("LRI_3.0_1.1-NG", "/2-NG/4-Lipid_Panel/1-");
        folderMapping.put("LRI_3.0_2.1-NG", "/2-NG/4-Lipid_Panel/2-");
        // Culture_and_Suscep
        folderMapping.put("LRI_4.0_1.1-NG",
                "/2-NG/5-Culture_and_Suscep/1-Preliminary result/1-");
        folderMapping.put("LRI_4.1_2.1-NG_FRU",
                "/2-NG/5-Culture_and_Suscep/2-Final_result_to_corrected_(FRU)/1-");
        folderMapping.put("LRI_4.1_3.1-NG_FRU",
                "/2-NG/5-Culture_and_Suscep/2-Final_result_to_corrected_(FRU)/2-");
        folderMapping.put("LRI_4.1_4.1-NG_FRU",
                "/2-NG/5-Culture_and_Suscep/2-Final_result_to_corrected_(FRU)/3-");
        folderMapping.put("LRI_4.2_2.1-NG_FRN",
                "/2-NG/5-Culture_and_Suscep/3-Final_result_to_corrected_(FRN)/1-");
        folderMapping.put("LRI_4.2_3.1-NG_FRN",
                "/2-NG/5-Culture_and_Suscep/3-Final_result_to_corrected_(FRN)/2-");
        folderMapping.put("LRI_4.2_4.1-NG_FRN",
                "/2-NG/5-Culture_and_Suscep/3-Final_result_to_corrected_(FRN)/3-");
        // Reflex_Hepatitis
        folderMapping.put("LRI_5.0_1.1-NG_FRU",
                "/2-NG/6-Reflex Hepatitis/1-Parent child(FRU)/1-");
        folderMapping.put("LRI_5.0_2.1-NG_FRU",
                "/2-NG/6-Reflex Hepatitis/1-Parent child(FRU)/2-");
        folderMapping.put("LRI_5.1_1.1-NG_FRN",
                "/2-NG/6-Reflex Hepatitis/2-Parent child(FRN)/1-");
        folderMapping.put("LRI_5.1_2.1-NG_FRN",
                "/2-NG/6-Reflex Hepatitis/2-Parent child(FRN)/2-");
        // Pap Smear
        folderMapping.put("LRI_6.0_1.1-NG", "/2-NG/7-Pap_Smear/1-");
        // GHP
        folderMapping.put("LRI_7.0_1.1-NG", "/2-NG/8-GHP/1-");

        supplements = new HashMap<String, List<Supplement>>();

        // Pap Smear supplements
        FileSupplement supp1 = new FileSupplement(
                "Pacific Anatomic Pathology Services base64 encoding",
                "11/04/2016", 1,
                "Pacific Anatomic Pathology Services_base64_utf-8.txt");
        FileSupplement supp2 = new FileSupplement(
                "Pacific Anatomic Pathology Services PDF", "11/04/2016", 2,
                "Pacific Anatomic Pathology Services.pdf");
        List<Supplement> sup = new ArrayList<Supplement>();
        sup.add(supp1);
        sup.add(supp2);
        supplements.put("LRI_6.0_1.1-NG", sup);
        supplements.put("LRI_6.0_1.1-GU", sup);
    }

    private static Logger logger = Logger.getLogger(LRIGenerator.class.getName());

    /**
     * @param args
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {
        long startTime = System.currentTimeMillis();
        LRIGenerator generator = new LRIGenerator();
        String dir = generator.getContext().getTESTCASE_DIR_F();
        File f = new File(dir);
        File ehrDir = new File(f, "EHR");
        File lisDir = new File(f, "LIS");

        deleteFiles("Constraints", ".json", f);
        deleteFiles("Constraints", ".xml", f);

        deleteFiles("Message", ".xml", f);
        deleteFiles("Message", ".html", f);
        deleteFiles("Message", ".txt", f);

        deleteFiles("TestDataSpecification", ".html", f);
        deleteFiles("TestDataSpecification_pdf", ".html", f);
        deleteFiles("TestDataSpecification", ".pdf", f);

        deleteFiles("Juror", ".xml", f);
        deleteFiles("JurorDocument", ".html", f);
        deleteFiles("JurorDocument", ".pdf", f);

        String[] lis = { "LRI", "ACK" };
        String[] ehr = { "LRI", "ACK" };
        generator.init(lis, "LIS");
        generator.init(ehr, "EHR");
        generator.generateMessageXML(f);
        generator.generateMessage_HTML(f);
        generator.generateMessageContent_HTML(f);

        // TEST STORY //
        deleteFiles("TestStory", ".html", f);
        deleteFiles("TestStory", ".pdf", f);
        deleteFiles("TestStory", ".json", f);
        // deleteFiles("TestStory", ".xml", f);
        copyFile("TestStory_", ".xml", "TestStory.xml", f);
        generator.generateTestStory_HTML(f);

        String[] ehrToLis = { "*-ACK_0.0_3.1-*", "*-ACK_0.0_4.1-*" };
        String[] lisToEhr = { "*LRI_0*", "*-ACK_0.0_5.1-*", "*LRI_1*",
                "*LRI_2*", "*LRI_3*", "*LRI_4*", "*LRI_5*", "*LRI_6*" };

        // TEST DATA SPECIFICATION //
        // EHR
        // IOFileFilter ehrAutoTds = new WildcardFileFilter(ehrToLis);
        // IOFileFilter ehrGenericTds = new WildcardFileFilter(lisToEhr);
        IOFileFilter ehrAutoTds = new WildcardFileFilter(Arrays.asList("*"));
        IOFileFilter ehrGenericTds = new WildcardFileFilter(Arrays.asList(""));
        generator.generateTDS(ehrDir, ehrAutoTds, ehrGenericTds);

        // LIS
        IOFileFilter lisAutoTds = new WildcardFileFilter(lisToEhr);
        IOFileFilter lisGenericTds = new WildcardFileFilter(ehrToLis);
        generator.generateTDS(lisDir, lisAutoTds, lisGenericTds);

        // JUROR DOCUMENTS
        copyFile("Message.", ".xml", "JurorData.xml", ehrDir);
        copyFile("Message.", ".xml", "JurorData.xml", lisDir);

        // EHR
        IOFileFilter ehrAutoJuror = new WildcardFileFilter(lisToEhr);
        IOFileFilter ehrGenericJuror = new WildcardFileFilter(ehrToLis);
        // IOFileFilter exclude = new NotFileFilter(new PrefixFileFilter(
        // Arrays.asList("2-ACK_0.0_3.1", "3-ACK_0.0_4.1",
        // "4-ACK_0.0_5.1", "1-LRI_4.1_2.1", "2-LRI_4.1_3.1",
        // "3-LRI_4.1_4.1", "1-LRI_4.2_2.1", "2-LRI_4.2_3.1",
        // "3-LRI_4.2_4.1", "2-LRI_5.0_2.1", "2-LRI_5.1_2.1")));
        IOFileFilter exclude = new NotFileFilter(new PrefixFileFilter(ehrToLis));

        generator.generateJuror(ehrDir,
                new AndFileFilter(ehrAutoJuror, exclude), ehrGenericJuror);

        // LIS
        IOFileFilter lisAutoJuror = new WildcardFileFilter(ehrToLis);
        IOFileFilter excludeLIS = new NotFileFilter(new PrefixFileFilter(
                lisToEhr));

        generator.generateJuror(lisDir, new AndFileFilter(lisAutoJuror,
                excludeLIS), null);

        // generate PDFs
        IOFileFilter testStoryFilter = new NameFileFilter("TestStory.html");
        generator.generatePDFs(f, testStoryFilter);
        IOFileFilter tdsFilter = new NameFileFilter(
                "TestDataSpecification_pdf.html");
        generator.generatePDFs(f, tdsFilter);
        IOFileFilter jurorFilter = new NameFileFilter("JurorDocument_pdf.html");
        generator.generatePDFs(f, jurorFilter);

        // quick and dirty way to set the postion attribute for each
        // testplan/testgroup/testcase/teststep
        generator.update(f);

        /* Generate test package at test step level */
        IOFileFilter testCaseFilter = new NameFileFilter("TestStep.json");
        Collection<File> testSteps = FileUtils.listFiles(f, testCaseFilter,
                FileFilterUtils.trueFileFilter());

        for (File testStep : testSteps) {
            File stepDir = testStep.getParentFile();
            File pdfFile = new File(stepDir, "TestPackage.pdf");
            List<File> files = new ArrayList<File>();
            File ts = new File(stepDir, "TestStory.html");
            File mc = new File(stepDir, "MessageContent.html");
            File tds = new File(stepDir, "TestDataSpecification_pdf.html");
            File jd = new File(stepDir, "JurorDocument_pdf.html");
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

        long endTime = System.currentTimeMillis();
        logger.info("total time : " + (endTime - startTime) / 1000 + " seconds");

        // File zip = new File("lri-xml-messages.zip");
        // zip("Message.xml", zip, f);
        //
        // File zip2 = new File("lri-juror-pdf.zip");
        // zip("JurorDocument.pdf", zip2, f);
        //
        // File zip3 = new File("lri-juror-html.zip");
        // zip("JurorDocument.html", zip3, f);

    }

    // protected void generateJuror(File dir) throws Exception {
    // // TODO : temporarily exclude Parent/Child test cases + exclude ACKs
    // IOFileFilter directoryFilter = new NotFileFilter(new PrefixFileFilter(
    // Arrays.asList("2-ACK_0.0_3.1", "3-ACK_0.0_4.1",
    // "4-ACK_0.0_5.1", "1-LRI_4.1_2.1", "2-LRI_4.1_3.1",
    // "1-LRI_4.2_2.1", "2-LRI_4.2_3.1", "2-LRI_5.0_2.1",
    // "2-LRI_5.1_2.1")));
    //
    // IOFileFilter messageFilter = new NameFileFilter("JurorData.xml");
    //
    // MyDirectoryWalker walker = new MyDirectoryWalker(messageFilter,
    // directoryFilter);
    // List<File> xmlFiles = walker.getFiles(dir);
    //
    // String fileNamePattern = "JurorDocument";
    // for (File sourceFile : xmlFiles) {
    // Map<String, Object> xslParams = new HashMap<String, Object>();
    // xslParams.put("testCaseName", StringUtils.substringAfter(
    // sourceFile.getParentFile().getName(), "-"));
    // // HTML
    // File htmlFile = new File(sourceFile.getParentFile(), String.format(
    // "%s.html", fileNamePattern));
    // FileInputStream xmlFileStream = new FileInputStream(sourceFile);
    // DocumentGenerator.generate(context.getJUROR_HTML_XSLT(), htmlFile,
    // xmlFileStream, xslParams);
    // xmlFileStream.close();
    //
    // // PDF
    // File pdfFile = new File(sourceFile.getParentFile(), String.format(
    // "%s.pdf", fileNamePattern));
    // File pdfHtmlFile = new File(sourceFile.getParentFile(),
    // String.format("%s_pdf.html", fileNamePattern));
    // FileInputStream xmlPdfFileStream = new FileInputStream(sourceFile);
    // DocumentGenerator.generate(context.getJUROR_PDF_XSLT(),
    // pdfHtmlFile, xmlPdfFileStream);
    // xmlPdfFileStream.close();
    // if (pdfHtmlFile.exists()) {
    // PDFUtil.generatePDF(pdfFile, htmlFile);
    // }
    // }
    // }

    private static void copyFile(String prefixFilter, String suffixFilter,
            String name, File rootDirectory) throws IOException {
        IOFileFilter pFilter = new PrefixFileFilter(prefixFilter);
        IOFileFilter sFilter = new SuffixFileFilter(suffixFilter);
        IOFileFilter and = new AndFileFilter(pFilter, sFilter);
        Collection<File> files = FileUtils.listFiles(rootDirectory, and,
                FileFilterUtils.trueFileFilter());
        Set<String> result = new HashSet<String>();
        Set<String> duplicate = new HashSet<String>();
        for (File file : files) {
            File dest = new File(file.getParent(), name);
            logger.info(String.format("Copying %s to %s",
                    file.getAbsoluteFile(), dest.getAbsolutePath()));
            FileUtils.copyFile(file, dest);
            if (result.contains(dest.getAbsolutePath())) {
                duplicate.add(dest.getAbsolutePath());
            }
            result.add(dest.getAbsolutePath());
        }
        logger.info(String.format("Duplicate size : %s", duplicate.size()));
        if (duplicate.size() > 0) {
            logger.error(String.format("Duplicate detected : %s",
                    duplicate.toString()));
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

    public LRIGenerator() {
        context = new LRIContext();

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
                // Add supplements
                if (supplements.containsKey(jTestStep.getName())) {
                    jTestStep.addSupplements(supplements.get(jTestStep.getName()));
                }

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
                jTestCase.setDescription("");
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
                    jTestCaseGroup.setDescription("");
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
                    jTestCaseGroup.setDescription("");
                    jTestCaseGroup.setName(StringUtils.replace(split[1], "_",
                            " "));
                    FileUtils.writeStringToFile(testCaseGroup,
                            jTestCaseGroup.toJson(), false);
                }
            }
        }
    }

    // private class TestStepDirectoryFilter implements IOFileFilter {
    // @Override
    // public boolean accept(File file) {
    // File f = new File(file, "TestStep.json");
    // return file.isDirectory() && f.exists();
    // }
    //
    // @Override
    // public boolean accept(File dir, String name) {
    // File file = new File(dir, name);
    // return accept(file);
    // }
    // }

    // private class TestCaseDirectoryFilter implements IOFileFilter {
    // @Override
    // public boolean accept(File file) {
    // // TODO
    // // System.out.println(file.getName());
    // if (!file.isDirectory()) {
    // return false;
    // }
    // Collection<File> r = FileUtils.listFilesAndDirs(file,
    // FileFilterUtils.falseFileFilter(),
    // new TestStepDirectoryFilter());
    // System.out.println(file.getName());
    // System.out.println(r.size());
    // System.out.println(r.toString());
    // return true;
    // }
    //
    // @Override
    // public boolean accept(File dir, String name) {
    // File file = new File(dir, name);
    // return accept(file);
    // }
    // }

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

    private void fixPosition() throws IOException {
        String dir = getContext().getTESTCASE_DIR_F();
        File directory = new File(dir);
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
                if (group.getParentFile().getParentFile().equals(
                        plan.getParentFile())) {
                    tgIdx++;
                    JTestCaseGroup jgroup = JTestCaseGroup.fromJson(FileUtils.readFileToString(group));
                    jgroup.setPosition(tgIdx);
                    FileUtils.writeStringToFile(group, jgroup.toJson(), false);
                    // IOFileFilter testcase = new
                    // NameFileFilter("TestCase.json");
                    Collection<File> groups_2 = FileUtils.listFiles(
                            group.getParentFile(), testgroup,
                            FileFilterUtils.trueFileFilter());
                    // int tg2Idx = 0;
                    for (File tgoup2 : groups_2) {
                        if (tgoup2.getParentFile().getParentFile().equals(
                                group.getParentFile())) {
                            // tg2Idx++;
                            JTestCaseGroup jgroup2 = JTestCaseGroup.fromJson(FileUtils.readFileToString(tgoup2));
                            String name = tgoup2.getParentFile().getName();
                            String position = name.replaceAll("\\D", "");
                            jgroup2.setPosition(Integer.parseInt(position) + 1);
                            FileUtils.writeStringToFile(tgoup2,
                                    jgroup2.toJson(), false);
                            IOFileFilter testcase = new NameFileFilter(
                                    "TestCase.json");
                            Collection<File> testcases = FileUtils.listFiles(
                                    tgoup2.getParentFile(), testcase,
                                    FileFilterUtils.trueFileFilter());
                            // int tcIdx = 0;
                            for (File tcase : testcases) {
                                // tcIdx++;
                                JTestCase jCase = JTestCase.fromJson(FileUtils.readFileToString(tcase));
                                String caseName = jCase.getName();
                                String tmp = caseName.substring(caseName.indexOf("."));
                                String casePosition = tmp.replaceAll("\\D", "");
                                jCase.setPosition(Integer.parseInt(casePosition) + 1);
                                FileUtils.writeStringToFile(tcase,
                                        jCase.toJson(), false);

                                IOFileFilter teststep = new NameFileFilter(
                                        "TestStep.json");
                                Collection<File> teststeps = FileUtils.listFiles(
                                        tcase.getParentFile(), teststep,
                                        FileFilterUtils.trueFileFilter());

                                for (File tstep : teststeps) {
                                    JTestStep jStep = JTestStep.fromJson(FileUtils.readFileToString(tstep));
                                    // default to 1
                                    jStep.setPosition(1);
                                    FileUtils.writeStringToFile(tstep,
                                            jStep.toJson(), false);
                                }

                            }
                        }
                    }
                }
            }
        }
    }

    private void zipExampleMessages(String folder, String zipName, String suffix)
            throws IOException {

        String zipDir = "./src/main/resources/Documentation/" + folder
                + "_Test_Plan";

        Calendar calendar = Calendar.getInstance();
        Date date = calendar.getTime();
        SimpleDateFormat sdf = new SimpleDateFormat("ddMMyy");
        String dateSt = sdf.format(date);

        String zipFileName = String.format("%s/%s-%s.zip", zipDir, zipName,
                dateSt);

        File f = new File(context.getTESTCASE_DIR_F() + "/" + folder);

        // file suffix is "Message.txt";
        SuffixFileFilter messageFilter = new SuffixFileFilter(suffix);

        Collection<File> files = FileUtils.listFiles(f, messageFilter,
                TrueFileFilter.INSTANCE);

        // create zip
        // output file
        ZipOutputStream out = new ZipOutputStream(new FileOutputStream(
                zipFileName));
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

    // private void excludeValidationTables() throws XmlException, IOException {
    // File f = new File(context.getTESTCASE_DIR_F());
    // SuffixFileFilter validationContextFilter = new SuffixFileFilter(
    // "ValidationContext.xml");
    // Collection<File> validationContextFiles = FileUtils.listFiles(f,
    // validationContextFilter, TrueFileFilter.INSTANCE);
    // for (File validationContextFile : validationContextFiles) {
    // HL7V2MessageValidationContextDefinitionDocument vContext =
    // HL7V2MessageValidationContextDefinitionDocument.Factory.parse(validationContextFile);
    //
    // vContext.getHL7V2MessageValidationContextDefinition().getValidationConfiguration().getHL7Tables().unsetAll();
    // vContext.getHL7V2MessageValidationContextDefinition().getValidationConfiguration().getHL7Tables().setNone(
    // "");
    // vContext.getHL7V2MessageValidationContextDefinition().getValidationConfiguration().getUserTables().unsetAll();
    // vContext.getHL7V2MessageValidationContextDefinition().getValidationConfiguration().getUserTables().setNone(
    // "");
    //
    // XmlOptions prettyPrint = new XmlOptions();
    // prettyPrint.setSavePrettyPrint();
    // vContext.save(validationContextFile, prettyPrint);
    // }
    // }

    // private void addValidationPlugin() throws IOException, XmlException {
    // File f = new File(context.getTESTCASE_DIR_F());
    //
    // /* gov.nist.healthcare.mu.lri.plugin.LabResultPlugin */
    // SuffixFileFilter validationContextFilter = new SuffixFileFilter(
    // "ValidationContext.xml");
    // Collection<File> validationContextFiles = FileUtils.listFiles(f,
    // validationContextFilter, TrueFileFilter.INSTANCE);
    // for (File validationContextFile : validationContextFiles) {
    // // Add LabResultPlugin to all test cases
    // HL7V2MessageValidationContextDefinitionDocument vContext =
    // HL7V2MessageValidationContextDefinitionDocument.Factory.parse(validationContextFile);
    // PluginCheckType pc =
    // vContext.getHL7V2MessageValidationContextDefinition().addNewPluginCheck();
    // pc.setName("gov.nist.healthcare.mu.lri.plugin.LabResultPlugin");
    // pc.setParams("{\"location\":\"\",\"matchAll\":false,\"minMatch\":0,\"maxMatch\":null,\"values\":null}");
    // XmlOptions prettyPrint = new XmlOptions();
    // prettyPrint.setSavePrettyPrint();
    // vContext.save(validationContextFile, prettyPrint);
    // }
    //
    // /* gov.nist.healthcare.mu.lri.plugin.ParentChildPlugin */
    // /* LRI_4.1_Culture_and_Suscep */
    // PrefixFileFilter filter = new PrefixFileFilter("LRI_4.1_");
    // validationContextFiles = FileUtils.listFiles(f, new AndFileFilter(
    // validationContextFilter, filter), TrueFileFilter.INSTANCE);
    // if (validationContextFiles.size() == 0) {
    // logger.error("No validation context file with suffix 'LRI_4.1_'");
    // }
    // for (File validationContextFile : validationContextFiles) {
    // HL7V2MessageValidationContextDefinitionDocument vContext =
    // HL7V2MessageValidationContextDefinitionDocument.Factory.parse(validationContextFile);
    // PluginCheckType pc =
    // vContext.getHL7V2MessageValidationContextDefinition().addNewPluginCheck();
    // pc.setName("gov.nist.healthcare.mu.lri.plugin.ParentChildPlugin");
    // pc.setParams("{\"profile\":\"RU\",\"mapping\":{\"1\":[\"2\",\"3\",\"4\"]}}");
    // XmlOptions prettyPrint = new XmlOptions();
    // prettyPrint.setSavePrettyPrint();
    // vContext.save(validationContextFile, prettyPrint);
    // }
    //
    // /* LRI_4.2_Culture_and_Suscep */
    // filter = new PrefixFileFilter("LRI_4.2_");
    // validationContextFiles = FileUtils.listFiles(f, new AndFileFilter(
    // validationContextFilter, filter), TrueFileFilter.INSTANCE);
    // if (validationContextFiles.size() == 0) {
    // logger.error("No validation context file with suffix 'LRI_4.2_'");
    // }
    // for (File validationContextFile : validationContextFiles) {
    // HL7V2MessageValidationContextDefinitionDocument vContext =
    // HL7V2MessageValidationContextDefinitionDocument.Factory.parse(validationContextFile);
    // PluginCheckType pc =
    // vContext.getHL7V2MessageValidationContextDefinition().addNewPluginCheck();
    // pc.setName("gov.nist.healthcare.mu.lri.plugin.ParentChildPlugin");
    // pc.setParams("{\"profile\":\"RN\",\"mapping\":{\"1\":[\"2\",\"3\",\"4\"]}}");
    // XmlOptions prettyPrint = new XmlOptions();
    // prettyPrint.setSavePrettyPrint();
    // vContext.save(validationContextFile, prettyPrint);
    // }
    //
    // /* LRI_5.0_Reflex_Hepatitis */
    // filter = new PrefixFileFilter("LRI_5.0_");
    // validationContextFiles = FileUtils.listFiles(f, new AndFileFilter(
    // validationContextFilter, filter), TrueFileFilter.INSTANCE);
    // if (validationContextFiles.size() == 0) {
    // logger.error("No validation context file with suffix 'LRI_5.0_'");
    // }
    // for (File validationContextFile : validationContextFiles) {
    // HL7V2MessageValidationContextDefinitionDocument vContext =
    // HL7V2MessageValidationContextDefinitionDocument.Factory.parse(validationContextFile);
    // PluginCheckType pc =
    // vContext.getHL7V2MessageValidationContextDefinition().addNewPluginCheck();
    // pc.setName("gov.nist.healthcare.mu.lri.plugin.ParentChildPlugin");
    // pc.setParams("{\"profile\":\"RU\",\"mapping\":{\"1\":[\"2\"]}}");
    // XmlOptions prettyPrint = new XmlOptions();
    // prettyPrint.setSavePrettyPrint();
    // vContext.save(validationContextFile, prettyPrint);
    // }
    // /* LRI_5.1_Reflex_Hepatitis */
    // filter = new PrefixFileFilter("LRI_5.1_");
    // validationContextFiles = FileUtils.listFiles(f, new AndFileFilter(
    // validationContextFilter, filter), TrueFileFilter.INSTANCE);
    // if (validationContextFiles.size() == 0) {
    // logger.error("No validation context file with suffix 'LRI_5.1_'");
    // }
    // for (File validationContextFile : validationContextFiles) {
    // HL7V2MessageValidationContextDefinitionDocument vContext =
    // HL7V2MessageValidationContextDefinitionDocument.Factory.parse(validationContextFile);
    // PluginCheckType pc =
    // vContext.getHL7V2MessageValidationContextDefinition().addNewPluginCheck();
    // pc.setName("gov.nist.healthcare.mu.lri.plugin.ParentChildPlugin");
    // pc.setParams("{\"profile\":\"RN\",\"mapping\":{\"1\":[\"2\"]}}");
    // XmlOptions prettyPrint = new XmlOptions();
    // prettyPrint.setSavePrettyPrint();
    // vContext.save(validationContextFile, prettyPrint);
    // }
    // }

    // private List<String> extractProfiles(String identifier) {
    // ArrayList<String> profiles = new ArrayList<String>(
    // Arrays.asList(identifier.split("_")));
    // return profiles;
    // }
    //
    // private String profileToString(List<String> profiles) {
    // StringBuffer sb = new StringBuffer();
    // for (int i = 0; i < profiles.size(); i++) {
    // sb.append(profiles.get(i));
    // if (i + 1 < profiles.size()) {
    // sb.append("_");
    // }
    // }
    // return sb.toString();
    // }

    protected List<String> _getTestStepFolder(String prefix,
            TestCaseMetadata metadata) throws RuntimeException {
        List<String> result = new ArrayList<String>();
        String msgId = metadata.getIdentifier();
        // TestCaseIdentifier identifier = TestCaseIdentifier.parse(msgId);
        // level 1 : LIS or EHR (prefix)
        result.add(prefix);
        if (!folderMapping.containsKey(msgId)) {
            throw new RuntimeException("No folder defined for " + msgId);
        }
        String folder = folderMapping.get(msgId) + msgId;
        List<String> tmp = Arrays.asList(StringUtils.split(folder, "/"));
        result.addAll(tmp);
        // // level 2 : GU/NG
        // List<String> profiles = extractProfiles(identifier.getProfile());
        // result.add(profiles.get(0));
        //
        // // level 3 : LRI_1_TEST CASE TYPE
        // result.add(String.format("%s_%s_%s",
        // identifier.getPrefix().toUpperCase(), identifier.getScenario(),
        // metadata.getTestCaseType()));
        //
        // // level 4 LRI_1.0_DESCRIPTION
        // result.add(String.format("%s_%s.%s_%s",
        // identifier.getPrefix().toUpperCase(), identifier.getScenario(),
        // identifier.getVariation(), metadata.getTestCaseType()));
        //
        // // level 5 : LRI_1.0_GU-TAG
        // result.add(String.format("%s_%s.%s_%s-%s",
        // identifier.getPrefix().toUpperCase(), identifier.getScenario(),
        // identifier.getVariation(), identifier.getProfile(),
        // metadata.getTag()));
        return result;
    }

    @Override
    protected String getArtifactNameSuffix(String prefix,
            TestCaseMetadata metadata) {
        return "";
    }

    @Override
    protected String getTestStepFolder(String prefix, TestCaseMetadata metadata) {
        List<String> result = _getTestStepFolder(prefix, metadata);
        // int testPlanIdx = 0;
        // int testStepIdx = result.size() - 1;
        // int testCaseIdx = testStepIdx - 1;
        // String dir = getContext().getTESTCASE_DIR_F();
        // File f = new File(dir);
        // for (int i = 0; i < result.size(); i++) {
        // if (i == testPlanIdx) {
        // // create test plan
        // String domain = result.get(i);
        // File testPlanFolder = new File(f, domain);
        // File tpJson = new File(testPlanFolder, "TestPlan.json");
        // JTestPlan tp = createTestPlanJson(domain);
        // try {
        // FileUtils.writeStringToFile(tpJson, tp.toJson(), false);
        // } catch (IOException e) {
        // e.printStackTrace();
        // }
        //
        // } else if (i == testCaseIdx) {
        // // create test case
        // String testcase = result.get(i);
        // File testCaseFolder = new File(testGroup2Folder, testcase);
        // File tcJson = new File(testCaseFolder, "TestCase.json");
        // JTestCase tc = createTestCaseJson(testcase);
        // try {
        // FileUtils.writeStringToFile(tcJson, tc.toJson(), false);
        // } catch (IOException e) {
        // e.printStackTrace();
        // }
        // } else if (i == testStepIdx) {
        // // create test step
        // } else {
        // // create test group
        // String group = result.get(i);
        // File testGroupFolder = new File(testPlanFolder, group);
        // File tgJson = new File(testGroupFolder, "TestCaseGroup.json");
        // JTestCaseGroup tg = createTestCaseGroupJson(group);
        // try {
        // FileUtils.writeStringToFile(tgJson, tg.toJson(), false);
        // } catch (IOException e) {
        // e.printStackTrace();
        // }
        // }
        // }

        // create test plan folder/json
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

        // create first test group folder/json
        // String group = result.get(1);
        // File testGroupFolder = new File(testPlanFolder, group);
        // File tgJson = new File(testGroupFolder, "TestCaseGroup.json");
        // JTestCaseGroup tg = createTestCaseGroupJson(group);
        // try {
        // FileUtils.writeStringToFile(tgJson, tg.toJson(), false);
        // } catch (IOException e) {
        // e.printStackTrace();
        // }

        // create second test group folder/json
        // String group2 = result.get(2);
        // File testGroup2Folder = new File(testGroupFolder, group2);
        // File tg2Json = new File(testGroup2Folder, "TestCaseGroup.json");
        // JTestCaseGroup tg2 = createTestCaseGroupJson(group2);
        // try {
        // FileUtils.writeStringToFile(tg2Json, tg2.toJson(), false);
        // } catch (IOException e) {
        // e.printStackTrace();
        // }

        // create test case folder
        // String testcase = result.get(3);
        // File testCaseFolder = new File(testGroup2Folder, testcase);
        // File tcJson = new File(testCaseFolder, "TestCase.json");
        // JTestCase tc = createTestCaseJson(testcase);
        // try {
        // FileUtils.writeStringToFile(tcJson, tc.toJson(), false);
        // } catch (IOException e) {
        // e.printStackTrace();
        // }

        return StringUtils.join(result, "/");
    }

    private JTestCase createTestCaseJson(String tcName) {
        JTestCase tc = new JTestCase();
        String name = String.format("%s", tcName);
        String description = String.format("This is the %s test case.", tcName);
        tc.setName(name);
        tc.setDescription(description);
        return tc;
    }

    private JTestCaseGroup createTestCaseGroupJson(String groupName) {
        String[] split = StringUtils.split(groupName, "_");
        String displayName = StringUtils.join(split, " ", 2, split.length);
        if ("".equals(displayName)) {
            displayName = StringUtils.join(split, " ", 0, split.length);
        }
        JTestCaseGroup tg = new JTestCaseGroup();
        String name = String.format("%s", displayName);
        String description = String.format("This is the %s test group.",
                groupName);
        tg.setName(name);
        tg.setDescription(description);
        return tg;
    }

    private JTestPlan createTestPlanJson(String domain) {
        JTestPlan tp = new JTestPlan();
        String name = String.format("%s Test Plan", domain);
        // String description = String.format("This is the %s test plan.",
        // domain);
        tp.setName(name);
        // tp.setDescription(description);
        return tp;
    }

}
