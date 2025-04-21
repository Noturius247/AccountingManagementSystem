package com.accounting.service;

public interface PrinterService {
    /**
     * Print a document with the given content
     * @param content The content to print
     * @return true if printing was successful, false otherwise
     */
    boolean print(String content);

    /**
     * Print a document with the given content and printer name
     * @param content The content to print
     * @param printerName The name of the printer to use
     * @return true if printing was successful, false otherwise
     */
    boolean print(String content, String printerName);

    /**
     * Print a document with the given content, printer name, and number of copies
     * @param content The content to print
     * @param printerName The name of the printer to use
     * @param copies The number of copies to print
     * @return true if printing was successful, false otherwise
     */
    boolean print(String content, String printerName, int copies);

    /**
     * Check if a printer is ready to accept print jobs
     * @param printerName The name of the printer to check
     * @return true if the printer is ready, false otherwise
     */
    boolean isPrinterReady(String printerName);

    /**
     * Get the current status of a printer
     * @param printerName The name of the printer to check
     * @return A string describing the printer's status
     */
    String getPrinterStatus(String printerName);
} 