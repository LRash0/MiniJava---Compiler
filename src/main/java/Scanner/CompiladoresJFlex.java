package Scanner;

import java.io.File;
import java.nio.file.Paths;

public class CompiladoresJFlex {
	private static final String PATH_JFLEX = "/src/main/java/Scanner/minijava.jflex";

	public void generateLexer() {
		String rootPath = Paths.get("").toAbsolutePath().toString();
		String file = rootPath + PATH_JFLEX;
		File jflexFile = new File(file);
		jflex.Main.generate(jflexFile);

	}

}
