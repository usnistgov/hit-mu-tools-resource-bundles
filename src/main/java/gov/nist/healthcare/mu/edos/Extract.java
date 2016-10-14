package gov.nist.healthcare.mu.edos;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellValue;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class Extract {
    private static EDOSContext context = new EDOSContext();
    private static String tableLN = "<TableElement Code=\"%s\" Codesys=\"LN\" DisplayName=\"%s\" Source=\"SDO\"/>";
    private static String tableSCT = "<TableElement Code=\"%s\" Codesys=\"SCT\" DisplayName=\"%s\" Source=\"SDO\"/>";
    private static String tableCPT = "<TableElement Code=\"%s\" Codesys=\"C4\" DisplayName=\"%s\" Source=\"SDO\"/>";

    public static void main(String[] args) throws IOException {
        Map<String, String> lnCodes = new HashMap<String, String>();
        Map<String, String> sctCodes = new HashMap<String, String>();
        Map<String, String> cptCodes = new HashMap<String, String>();

        // spreadsheet
        InputStream is = Extract.class.getResourceAsStream(context.getSPREADSHEET());
        XSSFWorkbook workbook = new XSSFWorkbook(is);

        XSSFSheet om1Sheet = workbook.getSheet("OM1");
        XSSFSheet om5Sheet = workbook.getSheet("OM5");
        XSSFSheet om3Sheet = workbook.getSheet("OM3");
        XSSFSheet om4Sheet = workbook.getSheet("OM4");
        XSSFSheet cdmSheet = workbook.getSheet("CDM");

        Map<String, Integer> om1Map = new HashMap<String, Integer>();
        for (int i = 0; i < om1Sheet.getLastRowNum(); i++) {
            Row row = om1Sheet.getRow(i);
            if (row != null) {
                Cell c = row.getCell(0);
                if (c != null) {
                    String value = c.getStringCellValue();
                    om1Map.put(value, i);
                }
            }
        }
        Map<String, Integer> om5Map = new HashMap<String, Integer>();
        for (int i = 0; i < om5Sheet.getLastRowNum(); i++) {
            Row row = om5Sheet.getRow(i);
            if (row != null) {
                Cell c = row.getCell(0);
                if (c != null) {
                    String value = c.getStringCellValue();
                    om5Map.put(value, i);
                }
            }
        }
        Map<String, Integer> om3Map = new HashMap<String, Integer>();
        for (int i = 0; i < om3Sheet.getLastRowNum(); i++) {
            Row row = om3Sheet.getRow(i);
            if (row != null) {
                Cell c = row.getCell(0);
                if (c != null) {
                    String value = c.getStringCellValue();
                    om3Map.put(value, i);
                }
            }
        }
        Map<String, Integer> om4Map = new HashMap<String, Integer>();
        for (int i = 0; i < om4Sheet.getLastRowNum(); i++) {
            Row row = om4Sheet.getRow(i);
            if (row != null) {
                Cell c = row.getCell(0);
                if (c != null) {
                    String value = c.getStringCellValue();
                    om4Map.put(value, i);
                }
            }
        }

        Map<String, Integer> cdmMap = new HashMap<String, Integer>();
        for (int i = 0; i < cdmSheet.getLastRowNum(); i++) {
            Row row = cdmSheet.getRow(i);
            if (row != null) {
                Cell c = row.getCell(0);
                if (c != null) {
                    String value = c.getStringCellValue();
                    cdmMap.put(value, i);
                }
            }
        }
        // LN elements
        // OM1.7
        lnCodes.putAll(process("OM1.7", "LN", om1Map, om1Sheet));

        // OM1.31[1] & OM1.31[2]
        lnCodes.putAll(process("OM1.31[1]", "LN", om1Map, om1Sheet));
        lnCodes.putAll(process("OM1.31[2]", "LN", om1Map, om1Sheet));

        // OM1.34[1] & OM1.34[2]
        lnCodes.putAll(process("OM1.34[1]", "LN", om1Map, om1Sheet));
        lnCodes.putAll(process("OM1.34[2]", "LN", om1Map, om1Sheet));

        // OM1.52[1] to OM1.52[4]
        for (int i = 1; i < 5; i++) {
            String location = String.format("OM1.52[%s]", i);
            lnCodes.putAll(process(location, "LN", om1Map, om1Sheet));
        }

        // OM1.56[1]
        lnCodes.putAll(process("OM1.56[1]", "LN", om1Map, om1Sheet));

        // OM5.2[1] to OM5.2[32]
        for (int i = 1; i < 33; i++) {
            String location = String.format("OM5.2[%s]", i);
            lnCodes.putAll(process(location, "LN", om5Map, om5Sheet));
        }

        for (Entry<String, String> lnCode : lnCodes.entrySet()) {
            System.out.println(String.format(tableLN, lnCode.getKey(),
                    lnCode.getValue()));
        }

        // SCT elements
        // OM1.33[1] & OM1.33[2]
        sctCodes.putAll(process("OM1.33[1]", "SCT", om1Map, om1Sheet));
        sctCodes.putAll(process("OM1.33[2]", "SCT", om1Map, om1Sheet));

        // OM3.4[1] to OM3.4[6]
        for (int i = 1; i < 7; i++) {
            String location = String.format("OM3.4[%s]", i);
            lnCodes.putAll(process(location, "SCT", om3Map, om3Sheet));
        }

        // OM3.5[1] to OM3.5[11]
        for (int i = 1; i < 12; i++) {
            String location = String.format("OM3.5[%s]", i);
            lnCodes.putAll(process(location, "SCT", om3Map, om3Sheet));
        }

        // OM4.6
        sctCodes.putAll(process("OM4.6", "SCT", om4Map, om4Sheet));

        System.out.println();
        for (Entry<String, String> sctCode : sctCodes.entrySet()) {
            System.out.println(String.format(tableSCT, sctCode.getKey(),
                    sctCode.getValue()));
        }

        // CPT elements
        // CDM.7[1] to CDM.7[6]
        for (int i = 1; i < 7; i++) {
            String location = String.format("CDM.7[%s]", i);
            cptCodes.putAll(process(location, "C4", cdmMap, cdmSheet));
        }

        System.out.println();
        for (Entry<String, String> cptCode : cptCodes.entrySet()) {
            System.out.println(String.format(tableCPT, cptCode.getKey(),
                    cptCode.getValue()));
        }

        workbook.close();
    }

    private static Map<String, String> process(String location,
            String codeSystem, Map<String, Integer> locationMap, XSSFSheet sheet) {
        Map<String, String> map = new HashMap<String, String>();
        String location1 = String.format("%s.%s", location, 1);
        String location2 = String.format("%s.%s", location, 2);
        String location3 = String.format("%s.%s", location, 3);
        String location4 = String.format("%s.%s", location, 4);
        String location5 = String.format("%s.%s", location, 5);
        String location6 = String.format("%s.%s", location, 6);
        map.putAll(process(location1, location2, location3, codeSystem,
                locationMap, sheet));
        map.putAll(process(location4, location5, location6, codeSystem,
                locationMap, sheet));
        return map;
    }

    private static Map<String, String> process(String identifierLocation,
            String textLocation, String codeSystemLocation, String codeSystem,
            Map<String, Integer> locationMap, XSSFSheet sheet) {
        Map<String, String> map = new HashMap<String, String>();

        Integer identifierIdx = locationMap.get(identifierLocation);
        Integer textIdx = locationMap.get(textLocation);
        Integer codeSystemIdx = locationMap.get(codeSystemLocation);

        if (identifierIdx != null) {
            XSSFRow identifierRow = sheet.getRow(identifierIdx);
            XSSFRow textRow = sheet.getRow(textIdx);
            XSSFRow codeSystemRow = sheet.getRow(codeSystemIdx);
            for (int i = 0; i < codeSystemRow.getLastCellNum(); i++) {
                Cell c = codeSystemRow.getCell(i);
                if (codeSystem.equals(c.getStringCellValue())) {
                    XSSFCell identifierCell = identifierRow.getCell(i);
                    XSSFCell textCell = textRow.getCell(i);
                    String identifier = readStringValue(identifierCell);
                    String text = textCell.getStringCellValue();
                    map.put(identifier, text);
                }
            }
        }
        return map;
    }

    public static String readStringValue(Cell c) {
        if (c == null) {
            return "";
        }
        String cellValue = null;
        switch (c.getCellType()) {
        case Cell.CELL_TYPE_BLANK:
            cellValue = "";
            break;
        case Cell.CELL_TYPE_ERROR:
            cellValue = "";
            break;

        case Cell.CELL_TYPE_BOOLEAN:
            cellValue = Boolean.toString(c.getBooleanCellValue());
            break;
        case Cell.CELL_TYPE_FORMULA:
            FormulaEvaluator evaluator = c.getSheet().getWorkbook().getCreationHelper().createFormulaEvaluator();
            CellValue formulaCell = evaluator.evaluate(c);
            switch (formulaCell.getCellType()) {
            case Cell.CELL_TYPE_BOOLEAN:
                cellValue = Boolean.toString(formulaCell.getBooleanValue());
                break;
            case Cell.CELL_TYPE_NUMERIC:
                cellValue = Double.toString(formulaCell.getNumberValue());
                break;
            case Cell.CELL_TYPE_STRING:
                cellValue = formulaCell.getStringValue();
                break;
            case Cell.CELL_TYPE_BLANK:
                break;
            case Cell.CELL_TYPE_ERROR:
                break;
            // CELL_TYPE_FORMULA will never happen
            case Cell.CELL_TYPE_FORMULA:
                break;
            }
            break;
        case Cell.CELL_TYPE_NUMERIC:
            c.setCellType(Cell.CELL_TYPE_STRING);
        case Cell.CELL_TYPE_STRING:
            cellValue = c.getStringCellValue();
            break;
        }
        return cellValue;
    }
}
