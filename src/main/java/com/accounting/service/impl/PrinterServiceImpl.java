package com.accounting.service.impl;

import com.accounting.service.PrinterService;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.print.attribute.HashPrintRequestAttributeSet;
import javax.print.attribute.PrintRequestAttributeSet;
import javax.print.attribute.standard.Copies;
import javax.print.attribute.standard.PrinterState;
import javax.print.attribute.standard.PrinterStateReason;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;

@Slf4j
@Service
public class PrinterServiceImpl implements PrinterService {

    @Override
    public boolean print(String content) {
        return print(content, null, 1);
    }

    @Override
    public boolean print(String content, String printerName) {
        return print(content, printerName, 1);
    }

    @Override
    public boolean print(String content, String printerName, int copies) {
        try {
            // Get the default printer if no printer name is specified
            PrintService printService = printerName != null ? 
                findPrinterByName(printerName) : 
                PrintServiceLookup.lookupDefaultPrintService();

            if (printService == null) {
                log.error("No printer found" + (printerName != null ? " with name: " + printerName : ""));
                return false;
            }

            // Create print request attributes
            PrintRequestAttributeSet attributes = new HashPrintRequestAttributeSet();
            attributes.add(new Copies(copies));

            // Convert content to input stream
            try (InputStream inputStream = new ByteArrayInputStream(content.getBytes())) {
                // Create a print job
                javax.print.Doc doc = new javax.print.SimpleDoc(inputStream, javax.print.DocFlavor.INPUT_STREAM.AUTOSENSE, null);
                javax.print.DocPrintJob job = printService.createPrintJob();
                
                // Print the document
                job.print(doc, attributes);
                return true;
            }
        } catch (Exception e) {
            log.error("Error printing document", e);
            return false;
        }
    }

    @Override
    public boolean isPrinterReady(String printerName) {
        PrintService printService = findPrinterByName(printerName);
        if (printService == null) {
            log.error("Printer not found: " + printerName);
            return false;
        }

        try {
            PrinterState state = printService.getAttribute(PrinterState.class);
            return state != null && state.equals(PrinterState.IDLE);
        } catch (Exception e) {
            log.error("Error checking printer status", e);
            return false;
        }
    }

    @Override
    public String getPrinterStatus(String printerName) {
        PrintService printService = findPrinterByName(printerName);
        if (printService == null) {
            return "Printer not found";
        }

        try {
            PrinterState state = printService.getAttribute(PrinterState.class);
            Object[] reasons = printService.getAttributes().toArray();
            
            StringBuilder status = new StringBuilder();
            status.append("State: ").append(state != null ? state.toString() : "Unknown");
            
            if (reasons != null && reasons.length > 0) {
                status.append("\nAttributes: ");
                for (Object reason : reasons) {
                    if (reason instanceof PrinterStateReason) {
                        status.append("\n- ").append(reason.toString());
                    }
                }
            }
            
            return status.toString();
        } catch (Exception e) {
            log.error("Error getting printer status", e);
            return "Error getting printer status: " + e.getMessage();
        }
    }

    private PrintService findPrinterByName(String printerName) {
        PrintService[] printServices = PrintServiceLookup.lookupPrintServices(null, null);
        for (PrintService printService : printServices) {
            if (printService.getName().equalsIgnoreCase(printerName)) {
                return printService;
            }
        }
        return null;
    }
} 