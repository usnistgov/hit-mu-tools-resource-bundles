package gov.nist.healthcare.mu.edos;

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

    private static String segmentLibrary = "/ProfileLibraries/xslt/eDOS_segmentLibrary.xml";
    private static String datatypeLibrary = "/ProfileLibraries/xslt/eDOS_datatypeLibrary.xml";

    static {
        profiles = new HashMap<String, String>();
        // M04
        profiles.put("eDOS_MFN_M04_GU",
                "/ProfileLibraries/M04/3_XSLTGEN_MFN_M04_GU.xml");
        profiles.put("eDOS_MFN_M04_NG",
                "/ProfileLibraries/M04/3_XSLTGEN_MFN_M04_NG.xml");

        profiles.put("eDOS_MFK_M04_GU",
                "/ProfileLibraries/M04/3_XSLTGEN_MFK_M04_GU.xml");
        profiles.put("eDOS_MFK_M04_NG",
                "/ProfileLibraries/M04/3_XSLTGEN_MFK_M04_NG.xml");

        // M08
        profiles.put("eDOS_MFN_M08_GU",
                "/ProfileLibraries/M08/3_XSLTGEN_MFN_M08_GU.xml");
        profiles.put("eDOS_MFN_M08_NG",
                "/ProfileLibraries/M08/3_XSLTGEN_MFN_M08_NG.xml");

        profiles.put("eDOS_MFK_M08_GU",
                "/ProfileLibraries/M08/3_XSLTGEN_MFK_M08_GU.xml");
        profiles.put("eDOS_MFK_M08_NG",
                "/ProfileLibraries/M08/3_XSLTGEN_MFK_M08_NG.xml");

        // M10
        profiles.put("eDOS_MFN_M10_GU",
                "/ProfileLibraries/M10/3_XSLTGEN_MFN_M10_GU.xml");
        profiles.put("eDOS_MFN_M10_NG",
                "/ProfileLibraries/M10/3_XSLTGEN_MFN_M10_NG.xml");

        profiles.put("eDOS_MFK_M10_GU",
                "/ProfileLibraries/M10/3_XSLTGEN_MFK_M10_GU.xml");
        profiles.put("eDOS_MFK_M10_NG",
                "/ProfileLibraries/M10/3_XSLTGEN_MFK_M10_NG.xml");
    }

    public static void main(String[] args)
            throws TransformerFactoryConfigurationError, TransformerException,
            ParserConfigurationException, SAXException, IOException {
        // profiles
        for (Entry<String, String> profile : profiles.entrySet()) {
            System.out.println(profile.getKey());
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
