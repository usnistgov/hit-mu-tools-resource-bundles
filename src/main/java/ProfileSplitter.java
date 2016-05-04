import gov.nist.healthcare.hl7.v2.extractor.ProfileExtractor;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.net.URL;
import java.util.HashMap;

import javax.xml.bind.JAXBException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.xml.sax.InputSource;

//Splits the full, worked-on profile into seperate files
public class ProfileSplitter {

	public static void main(String[] args) {
		
		
		try {
			InputStream stream = ProfileSplitter.class.getClassLoader().getResourceAsStream("Global/Profiles/Profile.full");
			String s;
			File parentDirectory = new File("C:/Users/crouzier/workspace/mu/hit-ss-r2-resource-bundle/src/main/resources/Global/Profiles");
			
			s = IOUtils.toString(stream, "UTF-8");
			HashMap<String,String> map = ProfileExtractor.split(s);
			
			for (String ss : map.values() ){
				XPath xpath = XPathFactory.newInstance().newXPath();
				
				InputSource inputSource = new InputSource( new StringReader(ss));
				String description =  xpath.evaluate("//ConformanceProfile/Messages/Message/@Description", inputSource);
				
				System.out.println(description+"_Profile.xml");
				File file = new File(parentDirectory,description+"_Profile.xml");
				FileUtils.writeStringToFile(file, ss,"UTF-8");
			}
			
		} catch (IOException e) {
			e.printStackTrace();
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		} catch (JAXBException e) {
			e.printStackTrace();
		}
		
	}
}
