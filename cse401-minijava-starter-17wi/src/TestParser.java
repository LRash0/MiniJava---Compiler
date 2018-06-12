import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import AST.Statement;
import AST.Visitor.PrettyPrintVisitor;
import Parser.parser;
import Parser.sym;
import Scanner.scanner;
import java_cup.runtime.Symbol;

public class TestParser {
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
			parser p = new parser(s);
			Symbol root;
			// replace p.parse() with p.debug_parse() in next line to see trace of
			// parser shift/reduce actions during parse
			root = p.parse();
			List<Statement> program = (List<Statement>) root.value;
			for (Statement statement : program) {
				statement.accept(new PrettyPrintVisitor());
				System.out.print("\n");
			}
			System.out.print("\nParsing completed");
		} catch (Exception e) {
			// yuck: some kind of error in the compiler implementation
			// that we're not expecting (a bug!)
			System.err.println("Unexpected internal compiler error: " + e.toString());
			// print out a stack dump
			e.printStackTrace();
		}
	}
}
