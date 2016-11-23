package gov.nist.healthcare.mu.lri.r2;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import org.apache.commons.io.DirectoryWalker;
import org.apache.commons.io.filefilter.FileFilterUtils;
import org.apache.commons.io.filefilter.IOFileFilter;
import org.apache.commons.io.filefilter.PrefixFileFilter;
import org.apache.commons.io.filefilter.SuffixFileFilter;

/**
 * Returns all files that match the fileFilter, located in a directory that
 * match directoryFilter. The matching directories are not included in the
 * result.
 * 
 * @author Caroline Rosin (NIST)
 */
public class MyDirectoryWalker extends DirectoryWalker {

    private IOFileFilter directoryFilter;

    public MyDirectoryWalker(IOFileFilter fileFilter,
            IOFileFilter directoryFilter) {
        super(FileFilterUtils.trueFileFilter(), fileFilter, -1);
        this.directoryFilter = directoryFilter;
    }

    public List<File> getFiles(File dir) throws IOException {
        List<File> results = new ArrayList<File>();
        walk(dir, results);
        return results;
    }

    protected void handleFile(File file, int depth, Collection results)
            throws IOException {
        // do nothing
        File parent = file.getParentFile();
        if (results.contains(parent)) {
            results.add(file);
        }
    }

    protected boolean handleDirectory(File directory, int depth,
            Collection results) {
        if (directoryFilter.accept(directory)) {
            results.add(directory);
        }
        // we walk through any directory
        return true;
    }

    protected void handleDirectoryEnd(File directory, int depth,
            Collection results) throws IOException {
        // remove the directory from the results
        if (results.contains(directory)) {
            results.remove(directory);
        }
    }

    public static void main(String[] args) throws IOException {

        File dir = new File(".");

        IOFileFilter txtFilter = FileFilterUtils.suffixFileFilter("txt");
        IOFileFilter trueFilter = FileFilterUtils.trueFileFilter();

        IOFileFilter jurorFilter = new PrefixFileFilter(Arrays.asList(
                "JurorData", "JurorDocument"));
        IOFileFilter initialLoadFilter = new SuffixFileFilter("Initial load");

        MyDirectoryWalker walker = new MyDirectoryWalker(jurorFilter,
                initialLoadFilter);
        List<File> txtFiles = walker.getFiles(dir);

        for (File txtFile : txtFiles) {
            System.err.println("file:" + txtFile.getCanonicalPath());
        }

    }
}
