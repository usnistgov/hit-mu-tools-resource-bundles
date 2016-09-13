package gov.nist.healthcare.mu.loi;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class ConvertProfiles {
    private static Map<String, String> profiles;
    private static String messageConversion = "/ProfileLibraries/xslt/LOI_messages_conversion.xslt";
    private static String profileConversion = "/ProfileLibraries/xslt/LOI_profile_conversion.xslt";
    private static String segmentsConversion = "/ProfileLibraries/xslt/LOI_segments_conversion.xslt";
    private static String datatypesConversion = "/ProfileLibraries/xslt/LOI_datatypes_conversion.xslt";

    private static String segmentsLib = "/ProfileLibraries/xslt/LOI_segmentLibrary.xml";
    private static String datatypesLib = "/ProfileLibraries/xslt/LOI_datatypeLibrary.xml";

    private static String emptyXML = "/Global/xslt/empty.xml";

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
            IOException, ParserConfigurationException, SAXException {
        List<Document> messages = new ArrayList<Document>();
        // convert messages
        for (Entry<String, String> profile : profiles.entrySet()) {
            InputStream xml = ConvertProfiles.class.getResourceAsStream(profile.getValue());
            InputStream xslt = ConvertProfiles.class.getResourceAsStream(messageConversion);
            Source xmlInput = new StreamSource(xml);
            Source xsl = new StreamSource(xslt);
            StringWriter sw = new StringWriter();
            Result xmlOutput = new StreamResult(sw);
            Transformer transformer = TransformerFactory.newInstance().newTransformer(
                    xsl);
            transformer.transform(xmlInput, xmlOutput);
            xml.close();
            xslt.close();
            String output = sw.getBuffer().toString();
            sw.close();

            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document message = builder.parse(new InputSource(new StringReader(
                    output)));
            messages.add(message);
        }

        // convert segments
        InputStream xml = ConvertProfiles.class.getResourceAsStream(segmentsLib);
        InputStream xslt = ConvertProfiles.class.getResourceAsStream(segmentsConversion);
        Source xmlInput = new StreamSource(xml);
        Source xsl = new StreamSource(xslt);
        StringWriter sw = new StringWriter();
        Result xmlOutput = new StreamResult(sw);
        Transformer transformer = TransformerFactory.newInstance().newTransformer(
                xsl);
        transformer.transform(xmlInput, xmlOutput);
        xml.close();
        xslt.close();
        String output = sw.getBuffer().toString();
        sw.close();

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document segments = builder.parse(new InputSource(new StringReader(
                output)));
        segments.getDocumentElement();

        // convert datatypes
        xml = ConvertProfiles.class.getResourceAsStream(datatypesLib);
        xslt = ConvertProfiles.class.getResourceAsStream(datatypesConversion);
        xmlInput = new StreamSource(xml);
        xsl = new StreamSource(xslt);
        sw = new StringWriter();
        xmlOutput = new StreamResult(sw);
        transformer = TransformerFactory.newInstance().newTransformer(xsl);
        transformer.transform(xmlInput, xmlOutput);
        xml.close();
        xslt.close();
        output = sw.getBuffer().toString();
        sw.close();

        factory = DocumentBuilderFactory.newInstance();
        builder = factory.newDocumentBuilder();
        Document datatypes = builder.parse(new InputSource(new StringReader(
                output)));
        datatypes.getDocumentElement();

        // add to profile
        xml = ConvertProfiles.class.getResourceAsStream(emptyXML);
        xslt = ConvertProfiles.class.getResourceAsStream(profileConversion);
        xmlInput = new StreamSource(xml);
        xsl = new StreamSource(xslt);
        xmlOutput = new StreamResult(System.out);
        transformer = TransformerFactory.newInstance().newTransformer(xsl);
        for (Document message : messages) {
            message.getDocumentElement();
        }
        transformer.setParameter("messages", messages);
        transformer.setParameter("segments", segments);
        transformer.setParameter("datatypes", datatypes);
        transformer.transform(xmlInput, xmlOutput);
        xml.close();
        xslt.close();

    }

    public static void printDocument(Document doc, OutputStream out)
            throws IOException, TransformerException {
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
        transformer.setOutputProperty(OutputKeys.METHOD, "xml");
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        transformer.setOutputProperty(
                "{http://xml.apache.org/xslt}indent-amount", "4");

        transformer.transform(new DOMSource(doc), new StreamResult(
                new OutputStreamWriter(out, "UTF-8")));
    }

}
