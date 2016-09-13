package gov.nist.healthcare.mu.loi;

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
    private static LOIContext context = new LOIContext();
    private static String tableLN = "<TableElement Code=\"%s\" Codesys=\"LN\" DisplayName=\"%s\" Source=\"SDO\"/>";
    private static String tableSCT = "<TableElement Code=\"%s\" Codesys=\"SCT\" DisplayName=\"%s\" Source=\"SDO\"/>";

    public static void main(String[] args) throws IOException {
        Map<String, String> lnCodes = new HashMap<String, String>();
        Map<String, String> sctCodes = new HashMap<String, String>();
        // spreadsheet
        InputStream is = Extract.class.getResourceAsStream(context.getSPREADSHEET());
        XSSFWorkbook workbook = new XSSFWorkbook(is);

        XSSFSheet obrSheet = workbook.getSheet("OBR");
        XSSFSheet obxSheet = workbook.getSheet("OBX");
        XSSFSheet spmSheet = workbook.getSheet("SPM");

        Map<String, Integer> obrMap = new HashMap<String, Integer>();
        for (int i = 0; i < obrSheet.getLastRowNum(); i++) {
            Row row = obrSheet.getRow(i);
            if (row != null) {
                Cell c = row.getCell(0);
                if (c != null) {
                    String value = c.getStringCellValue();
                    obrMap.put(value, i);
                }
            }
        }

        Map<String, Integer> obxMap = new HashMap<String, Integer>();
        for (int i = 0; i < obxSheet.getLastRowNum(); i++) {
            Row row = obxSheet.getRow(i);
            if (row != null) {
                Cell c = row.getCell(0);
                if (c != null) {
                    String value = c.getStringCellValue();
                    obxMap.put(value, i);
                }
            }
        }

        Map<String, Integer> spmMap = new HashMap<String, Integer>();
        for (int i = 0; i < spmSheet.getLastRowNum(); i++) {
            Row row = spmSheet.getRow(i);
            if (row != null) {
                Cell c = row.getCell(0);
                if (c != null) {
                    String value = c.getStringCellValue();
                    spmMap.put(value, i);
                }
            }
        }
        // LN elements
        // OBR.4.1 OBR.4.3

        lnCodes.putAll(process("OBR.4.1", "OBR.4.2", "OBR.4.3", "LN", obrMap,
                obrSheet));
        // OBR.4.4 OBR.4.6
        lnCodes.putAll(process("OBR.4.4", "OBR.4.5", "OBR.4.6", "LN", obrMap,
                obrSheet));

        // OBX.3.1 OBX.3.3
        lnCodes.putAll(process("OBX.3.1", "OBX.3.2", "OBX.3.3", "LN", obxMap,
                obxSheet));

        // OBX.3.4 OBX.3.6
        lnCodes.putAll(process("OBX.3.4", "OBX.3.5", "OBX.3.6", "LN", obxMap,
                obxSheet));

        for (Entry<String, String> lnCode : lnCodes.entrySet()) {
            System.out.println(String.format(tableLN, lnCode.getKey(),
                    lnCode.getValue()));
        }

        // SCT elements
        sctCodes.putAll(process("SPM.4.1", "SPM.4.2", "SPM.4.3", "SCT", spmMap,
                spmSheet));
        sctCodes.putAll(process("SPM.4.4", "SPM.4.5", "SPM.4.6", "SCT", spmMap,
                spmSheet));
        sctCodes.putAll(process("SPM.5.1", "SPM.5.2", "SPM.5.3", "SCT", spmMap,
                spmSheet));
        sctCodes.putAll(process("SPM.8.1", "SPM.8.2", "SPM.8.3", "SCT", spmMap,
                spmSheet));
        sctCodes.putAll(process("SPM.8.4", "SPM.8.5", "SPM.8.6", "SCT", spmMap,
                spmSheet));

        sctCodes.putAll(process("SPM.9.1", "SPM.9.2", "SPM.9.3", "SCT", spmMap,
                spmSheet));
        sctCodes.putAll(process("SPM.10.1", "SPM.10.2", "SPM.10.3", "SCT",
                spmMap, spmSheet));
        System.out.println();
        for (Entry<String, String> sctCode : sctCodes.entrySet()) {
            System.out.println(String.format(tableSCT, sctCode.getKey(),
                    sctCode.getValue()));
        }
    }

    private static Map<String, String> process(String identifierLocation,
            String textLocation, String codeSystemLocation, String codeSystem,
            Map<String, Integer> locationMap, XSSFSheet sheet) {
        Map<String, String> map = new HashMap<String, String>();

        Integer identifierIdx = locationMap.get(identifierLocation);
        Integer textIdx = locationMap.get(textLocation);
        Integer codeSystemIdx = locationMap.get(codeSystemLocation);

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
