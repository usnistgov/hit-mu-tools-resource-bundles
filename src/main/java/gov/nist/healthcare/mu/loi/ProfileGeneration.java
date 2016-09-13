package gov.nist.healthcare.mu.loi;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

public class ProfileGeneration {

    private static Map<String, String> profiles;
    private static String profileGen = "/ProfileLibraries/xslt/profileGen.xslt";
    private static String datatypeGen = "/ProfileLibraries/xslt/datatypeGen.xslt";

    private String segmentLibrary = "/ProfileLibraries/xslt/LOI_segmentLibrary.xml";
    private static String datatypeLibrary = "/ProfileLibraries/xslt/LOI_datatypeLibrary.xml";

    static {
        profiles = new HashMap<String, String>();
        // new and happen order
        profiles.put(
                "1_PROFILE_OML_O21_GU_PRU",
                "/ProfileLibraries/1_New and Append Order/3_XSLTGEN_OML_O21_GU_PRU_Message Structure Definition.xml");
        profiles.put(
                "1_PROFILE_OML_O21_GU_PRN",
                "/ProfileLibraries/1_New and Append Order/3_XSLTGEN_OML_O21_GU_PRN_Message Structure Definition.xml");
        profiles.put(
                "1_PROFILE_OML_O21_NG_PRU",
                "/ProfileLibraries/1_New and Append Order/3_XSLTGEN_OML_O21_NG_PRU_Message Structure Definition.xml");
        profiles.put(
                "1_PROFILE_OML_O21_NG_PRN",
                "/ProfileLibraries/1_New and Append Order/3_XSLTGEN_OML_O21_NG_PRN_Message Structure Definition.xml");

        // cancel order
        profiles.put(
                "2_PROFILE_OML_O21_GU_PRU_C",
                "/ProfileLibraries/2_Cancel Order/3_XSLTGEN_OML_O21_GU_PRU_Cancel_Message Structure Definition.xml");
        profiles.put(
                "2_PROFILE_OML_O21_GU_PRN_C",
                "/ProfileLibraries/2_Cancel Order/3_XSLTGEN_OML_O21_GU_PRN_Cancel_Message Structure Definition.xml");
        profiles.put(
                "2_PROFILE_OML_O21_NG_PRU_C",
                "/ProfileLibraries/2_Cancel Order/3_XSLTGEN_OML_O21_NG_PRU_Cancel_Message Structure Definition.xml");
        profiles.put(
                "2_PROFILE_OML_O21_NG_PRN_C",
                "/ProfileLibraries/2_Cancel Order/3_XSLTGEN_OML_O21_NG_PRN_Cancel_Message Structure Definition.xml");

        // new and happen order PH
        profiles.put(
                "3_PROFILE_OML_O21_GU_PRU_PH",
                "/ProfileLibraries/3_GU_RU_PH/3_XSLTGEN_OML_O21_GU_PRU_PH_Message Structure Definition.xml");
        profiles.put(
                "3_PROFILE_OML_O21_GU_PRN_PH",
                "/ProfileLibraries/3_GU_RU_PH/3_XSLTGEN_OML_O21_GU_PRN_PH_Message Structure Definition.xml");
        profiles.put(
                "3_PROFILE_OML_O21_NG_PRU_PH",
                "/ProfileLibraries/3_GU_RU_PH/3_XSLTGEN_OML_O21_NG_PRU_PH_Message Structure Definition.xml");
        profiles.put(
                "3_PROFILE_OML_O21_NG_PRN_PH",
                "/ProfileLibraries/3_GU_RU_PH/3_XSLTGEN_OML_O21_NG_PRN_PH_Message Structure Definition.xml");

        // new and happen order FI
        profiles.put(
                "4_PROFILE_OML_O21_GU_PRU_FI",
                "/ProfileLibraries/4_Financial_Information/3_XSLTGEN_OML_O21_GU_PRU_FI_Message Structure Definition.xml");
        profiles.put(
                "4_PROFILE_OML_O21_GU_PRN_FI",
                "/ProfileLibraries/4_Financial_Information/3_XSLTGEN_OML_O21_GU_PRN_FI_Message Structure Definition.xml");
        profiles.put(
                "4_PROFILE_OML_O21_NG_PRU_FI",
                "/ProfileLibraries/4_Financial_Information/3_XSLTGEN_OML_O21_NG_PRU_FI_Message Structure Definition.xml");
        profiles.put(
                "4_PROFILE_OML_O21_NG_PRN_FI",
                "/ProfileLibraries/4_Financial_Information/3_XSLTGEN_OML_O21_NG_PRN_FI_Message Structure Definition.xml");
    }

    public static void main(String[] args)
            throws TransformerFactoryConfigurationError, TransformerException,
            ParserConfigurationException, SAXException, IOException {
        // profiles
        for (Entry<String, String> profile : profiles.entrySet()) {

            InputStream xml = ProfileGeneration.class.getResourceAsStream(profile.getValue());
            InputStream xslt = ProfileGeneration.class.getResourceAsStream(profileGen);

            Source xmlInput = new StreamSource(xml);
            Source xsl = new StreamSource(xslt);
            Result xmlOutput = new StreamResult(System.out);
            Transformer transformer = TransformerFactory.newInstance().newTransformer(
                    xsl);

            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = dbf.newDocumentBuilder();

            Document segLib = builder.parse(ProfileGeneration.class.getResourceAsStream("/ProfileLibraries/xslt/LOI_segmentLibrary.xml"));
            segLib.getDocumentElement();
            Document datatypeLib = builder.parse(ProfileGeneration.class.getResourceAsStream("/ProfileLibraries/xslt/LOI_datatypeLibrary.xml"));
            datatypeLib.getDocumentElement();
            transformer.setParameter("segmentLib", segLib);
            transformer.setParameter("datatypeLib", datatypeLib);
            transformer.setParameter("filename",
                    "src/main/resources/ProfileLibraries/xslt/generation/"
                            + profile.getKey() + ".xml");
            transformer.transform(xmlInput, xmlOutput);
        }

        // datatypes
        InputStream xml = ProfileGeneration.class.getResourceAsStream(datatypeLibrary);
        InputStream xslt = ProfileGeneration.class.getResourceAsStream(datatypeGen);

        Source xmlInput = new StreamSource(xml);
        Source xsl = new StreamSource(xslt);
        Result xmlOutput = new StreamResult(System.out);
        Transformer transformer = TransformerFactory.newInstance().newTransformer(
                xsl);
        transformer.setParameter("filename",
                "src/main/resources/ProfileLibraries/xslt/generation/datatype-definition.xml");
        transformer.transform(xmlInput, xmlOutput);
    }
}
