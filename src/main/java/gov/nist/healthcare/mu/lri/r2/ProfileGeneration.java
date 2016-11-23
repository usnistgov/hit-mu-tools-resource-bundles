package gov.nist.healthcare.mu.lri.r2;

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

    private static String segmentLibrary = "/ProfileLibraries/xslt/LRI_segmentLibrary.xml";
    private static String datatypeLibrary = "/ProfileLibraries/xslt/LRI_datatypeLibrary.xml";

    static {
        profiles = new HashMap<String, String>();
        profiles.put("LRI_ORU_R01_GU",
                "/ProfileLibraries/xslt/R01/1_XSLTGEN_ORU_R01_GU.xml");
        profiles.put("LRI_ORU_R01_GU_FRU",
                "/ProfileLibraries/xslt/R01/2_XSLTGEN_ORU_R01_GU_FRU.xml");
        profiles.put("LRI_ORU_R01_GU_FRN",
                "/ProfileLibraries/xslt/R01/3_XSLTGEN_ORU_R01_GU_FRN.xml");
        profiles.put("LRI_ORU_R01_NG",
                "/ProfileLibraries/xslt/R01/4_XSLTGEN_ORU_R01_NG.xml");
        profiles.put("LRI_ORU_R01_NG_FRU",
                "/ProfileLibraries/xslt/R01/5_XSLTGEN_ORU_R01_NG_FRU.xml");
        profiles.put("LRI_ORU_R01_NG_FRN",
                "/ProfileLibraries/xslt/R01/6_XSLTGEN_ORU_R01_NG_FRN.xml");

        profiles.put("LRI_ACK_R01_GU",
                "/ProfileLibraries/xslt/R01/7_XSLTGEN_ACK_R01_GU.xml");
        profiles.put("LRI_ACK_R01_NG",
                "/ProfileLibraries/xslt/R01/8_XSLTGEN_ACK_R01_NG.xml");
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

            Document segLib = builder.parse(ProfileGeneration.class.getResourceAsStream(segmentLibrary));
            segLib.getDocumentElement();
            Document datatypeLib = builder.parse(ProfileGeneration.class.getResourceAsStream(datatypeLibrary));
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
