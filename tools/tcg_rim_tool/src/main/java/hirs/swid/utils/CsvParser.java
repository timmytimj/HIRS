package hirs.swid.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;

/**
 * This class is a utility to take the elements of a CSV file and breaks them up for processing.
 */
public class CsvParser {

    private static final char DEFAULT_SEPARATOR = ',';
    private static final char DEFAULT_QUOTE = '"';

    private List<String> content;

    /**
     * Constructor that takes in a file parameter.
     * @param file object to read.
     */
    public CsvParser(final File file) {
        this(file.getAbsolutePath());
    }

    /**
     * Constructor that takes in the file path for the csv file.
     * @param csvfile file path to the file to read.
     */
    public CsvParser(final String csvfile) {
        content = readerCsv(csvfile);
    }

    /**
     * This method takes an existing csv file and reads the file by line and
     * adds the contents to a list of Strings.
     *
     * @param file valid path to a csv file
     * @return the content of the file
     */
    @SuppressFBWarnings({"DM_EXIT", "DM_DEFAULT_ENCODING"})
    private List<String> readerCsv(final String file) {
        String line = "";
        String csvSplitBy = ",";
        List<String> tempList = new LinkedList<>();

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            while ((line = br.readLine()) != null) {
                if (line.length() > 0
                        && line.contains(csvSplitBy)) {
                 tempList.add(line);
                }
            }
        } catch (IOException ioEx) {
            System.out.println(String.format("Error reading in CSV file...(%s)", file));
            System.exit(1);
        }

        return tempList;
    }

    /**
     * Getter for the content of the given file.
     * @return the content of the file, line by line.
     */
    public final List<String> getContent() {
        return Collections.unmodifiableList(content);
    }

    /**
     * Feeder method that takes less parameters and gives default characters for missing parameter.
     * @param csvLine string elements to be parsed.
     * @return the string elements of the line
     */
    public static List<String> parseLine(final String csvLine) {
        return parseLine(csvLine, DEFAULT_SEPARATOR, DEFAULT_QUOTE);
    }

    /**
     * Feeder method that takes less parameters and gives default characters for missing parameter.
     * @param csvLine string elements to be parsed.
     * @param separators the character used to delimited.
     * @return the string elements of the line
     */
    public static List<String> parseLine(final String csvLine, final char separators) {
        return parseLine(csvLine, separators, DEFAULT_QUOTE);
    }

    /**
     * This method takes a given line in a csv file and breaks it apart.
     * @param csvLine string elements to be parsed.
     * @param separators the character used to delimited.
     * @param customQuote character of the quote
     * @return the string elements of the line
     */
    public static List<String> parseLine(final String csvLine,
                                         final char separators,
                                         final char customQuote) {
        List<String> result = new ArrayList<>();
        char separatorChar = separators;
        char quoteChar = customQuote;

        if (csvLine == null || csvLine.isEmpty()) {
            return result;
        }

        if (quoteChar == ' ') {
            quoteChar = DEFAULT_QUOTE;
        }

        if (separatorChar == ' ') {
            separatorChar = DEFAULT_SEPARATOR;
        }

        StringBuilder currVal = new StringBuilder();
        boolean inQuotes = false;
        boolean startCollectChar = false;
        boolean dbleQuotesInCol = false;

        char[] chars = csvLine.toCharArray();

        for (char ch : chars) {
            if (inQuotes) {
                startCollectChar = true;
                if (ch == quoteChar) {
                    inQuotes = false;
                    dbleQuotesInCol = false;
                } else {
                    if (ch == '\"') {
                        if (!dbleQuotesInCol) {
                            currVal.append(ch);
                            dbleQuotesInCol = true;
                        }
                    } else {
                        currVal.append(ch);
                    }
                }
            } else {
                if (ch == quoteChar) {
                    inQuotes = true;

                    if (chars[0] != '"' && quoteChar == '\"') {
                        currVal.append('"');
                    }

                    if (startCollectChar) {
                        currVal.append('"');
                    }
                } else if (ch == separatorChar) {
                    result.add(currVal.toString());
                    currVal = new StringBuilder();
                    startCollectChar = false;
                } else if (ch == '\r') {
                    continue;
                } else if (ch == '\n') {
                    break;
                } else {
                    currVal.append(ch);
                }
            }
        }

        result.add(currVal.toString());

        return result;
    }
}
