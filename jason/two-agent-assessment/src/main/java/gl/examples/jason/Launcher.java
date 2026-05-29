package gl.examples.jason;

import gl.adapters.jason.MASLauncher;

public class Launcher {
    public static void main(String[] args) throws Exception {
        MASLauncher.run(args, "src/main/resources/two_agent_assessment.mas2j");
    }
}
