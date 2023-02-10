//Splits the full, worked-on profile into seperate files
public class ProfileSplitter {

//	public static void main(String[] args) {
		
		
//		try {
//			InputStream stream = ProfileSplitter.class.getClassLoader().getResourceAsStream("Global/Profiles/Profile.full");
//			String s;
//			File parentDirectory = new File("src/main/resources/Global/Profiles");
//			
//			s = IOUtils.toString(stream, "UTF-8");
//			HashMap<String,String> map = ProfileExtractor.split(s);
//			
//			for (String ss : map.values() ){
//				XPath xpath = XPathFactory.newInstance().newXPath();
//				
//				InputSource inputSource = new InputSource( new StringReader(ss));
//				String description =  xpath.evaluate("//ConformanceProfile/Messages/Message/@Description", inputSource);
//				
//				System.out.println(description+"_Profile.xml");
//				File file = new File(parentDirectory,description+"_Profile.xml");
//				FileUtils.writeStringToFile(file, ss,"UTF-8");
//			}
//			
//		} catch (IOException e) {
//			e.printStackTrace();
//		} catch (XPathExpressionException e) {
//			e.printStackTrace();
//		} catch (JAXBException e) {
//			e.printStackTrace();
//		}
		
//	}
}
