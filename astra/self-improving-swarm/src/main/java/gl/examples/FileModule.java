package gl.examples;

import astra.core.Module;
import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * Custom ASTRA File Module.
 *
 * Allows agents to read and write files dynamically from their plans.
 */
public class FileModule extends Module {

    @ACTION
    public boolean write(String filePath, String content) {
        try {
            Files.writeString(Paths.get(filePath), content);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @TERM
    public String read(String filePath) {
        try {
            return Files.readString(Paths.get(filePath));
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
}
