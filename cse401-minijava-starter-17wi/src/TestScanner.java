import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;

import Parser.sym;
import Scanner.scanner;
import java_cup.runtime.Symbol;

public class TestScanner {
	public static void main(String[] args) {
		try {
			// create a scanner on the input file
			InputStream inputStream = new FileInputStream(
					"/home/ldrf/Downloads/Compiler-mini-java-master/testfiles/ParserTests/Types.java");
			scanner s = new scanner(new BufferedReader(new InputStreamReader(inputStream)));
			Symbol t = s.next_token();
			while (t.sym != sym.EOF) {
				// print each token that we scan
				System.out.print(s.symbolToString(t) + " ");
				t = s.next_token();
			}
			System.out.print("\nLexical analysis completed");
		} catch (Exception e) {
			// yuck: some kind of error in the compiler implementation
			// that we're not expecting (a bug!)
			System.err.println("Unexpected internal compiler error: " + e.toString());
			// print out a stack dump
			e.printStackTrace();
		}
	}
}
