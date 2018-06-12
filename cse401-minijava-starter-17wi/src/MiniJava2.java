
// Gyorgy Wyatt Muntean, Justin Adsuara Copyright (c) 2017

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import AST.Program;
import AST.Visitor.PrettyPrintVisitor;
import Parser.parser;
import Parser.sym;
import Scanner.scanner;
import java_cup.runtime.Symbol;

/**
 * This class is a MiniJava compiler for CSE 401 at University of Washington.
 */
public class MiniJava2 {
	public static final int SEMANTICS_ERROR_LIMIT = 30; // Maximum amount of type checking errors
	public static int SCANNER_ERRORS = 0;
	public static int PARSER_ERRORS = 0;
	public static int TYPE_CHECKING_ERRORS = 0;

	// Command line argument flags
	static final String S_FLAG = "-S"; // print scanner tokens
	static final String P_FLAG = "-P"; // pretty print a de-compiled version of source
	static final String A_FLAG = "-A"; // print AST
	static final String T_FLAG = "-T"; // type-checking flag
	static final int MAX_NUM_ARGS = 2;

	// The root node in our AST. Built and assigned by our parser.
	public static Program PROGRAM;

	/*
	 * Main
	 */
	public static void main(String[] args) {
		int res;
		Set<String> flags = new HashSet<String>();

		// parse command line flags and args
		String file_path = parseCommandLineArgs(args, flags);
		if (file_path == null) {
			System.exit(1);
		}

		// scanner printing
		if (flags.contains(S_FLAG)) {
			res = scan(file_path);
			if (res != 0) {
				System.exit(1);
			}
		}

		// parser
		res = buildAST(file_path, flags);
		if (res != 0) {
			System.exit(1);
		}

		// type-checker
		// res = typeCheck(PROGRAM, flags);
		if (res != 0) {
			printTypeCheckingErrors(file_path);
			System.exit(1);
		}

		// code-gen
		// res = generateCode(PROGRAM, flags);
		if (res != 0) {
			System.exit(1);
		}

		// Successful termination
		System.exit(0);
	}

	/*
	 * Runs our type-checking routine. This involves a few passes by various
	 * different visitors.
	 *
	 * @returns 0 on success, otherwise return 1 in the case of a fatal error
	 */
	// public static int typeCheck(Program p, Set<String> flags) {
	// int res = 0;
	//
	// // Invoke the SymbolTableVisitor
	// SymbolTableVisitor stVisitor = new SymbolTableVisitor();
	// if (flags.contains(T_FLAG)) {
	// // user specified symbol-table printing with their flags
	// stVisitor.enablePrint();
	// }
	//
	// // invoke the Symbol Table visitor
	// p.accept(stVisitor);
	//
	// // Check error status of the SymbolTableVisitor pass
	// res = handleFatalUndeclaredClass(stVisitor.checkUndeclaredClass());
	// if (res != 0) {
	// // I made it sort of hard to distinguish between an undeclared class error
	// and
	// // a fatal inheritance loop. Oops.
	// TYPE_CHECKING_ERRORS += 1;
	// return res;
	// }
	// res = handleFatalLoop(stVisitor.checkFatalLoop());
	// if (res != 0) {
	// TYPE_CHECKING_ERRORS += 1;
	// return res;
	// }
	// int st_errors = stVisitor.errorCount();
	// handleTypeCheckingErrors(st_errors);
	//
	// // Next, Invoke the type-checking pass
	// TypeCheckingVisitor tcVisitor = new TypeCheckingVisitor();
	// p.accept(tcVisitor);
	// // Check error status of the TypeChecker
	// res = tcVisitor.allValid && st_errors == 0 ? 0 : 1;
	//
	// if (!tcVisitor.allValid) {
	// TYPE_CHECKING_ERRORS += 1;
	// }
	//
	// return res;
	// }

	/*
	 * Runs our code generating visitor on the program, printing assembly to stdout.
	 *
	 * @returns 0 on success, otherwise 1 on fatal error.
	 */
	// public static int generateCode(Program p, Set<String> flags) {
	// if (flags.isEmpty()) {
	// PreCodeGenVisitor pre_code_gen = new PreCodeGenVisitor();
	// CodeGenVisitor code_gen = new
	// CodeGenVisitor(pre_code_gen.doubleLiteralLabels);
	//
	// // invoke our visitors for pre-code gen and code-gen
	// p.accept(pre_code_gen);
	// System.out.println();
	// p.accept(code_gen);
	// }
	// return 0;
	// }

	/*
	 * Takes in a file path and invokes the parser on the file. Depending on the
	 * command line arg flags, the result of the parse will be printed in some
	 * format related to the flags.
	 *
	 * @param file_path, the path of the file to scan and parse
	 * 
	 * @param flags, set of command line arg flags
	 * 
	 * @return 0 if successful scan and parse, 1 otherwise
	 */
	public static int buildAST(String file_path, Set<String> flags) {
		int res = 0;
		scanner s = null;
		parser p = null;

		try {
			// create scanner
			FileReader fr = new FileReader(file_path);
			s = new scanner(new BufferedReader(fr));
			// create parser ( can replace this call with "debug_parse" )
			p = new parser(s);

			// invoke the parser
			Symbol root;
			root = p.parse();
			Program program = (Program) root.value;
			// set the global pointer to the AST
			PROGRAM = program;

			// check the pretty print flag
			if (flags.contains(P_FLAG)) {
				program.accept(new PrettyPrintVisitor());
			}

			// check the print AST flag
			if (flags.contains(A_FLAG)) {
				// program.accept(new ASTPrintVisitor());
			}
		} catch (IOException e) {
			// File I/O exception
			System.err.println("Unexpected I/O exception: " + e.toString());
			res = 1;
		} catch (Exception e) {
			// Parser/Scanner threw an exception
			System.err.println("Aborting compilation.");
			res = 1;
		}

		return res;
	}

	/*
	 * Takes in a file path and invokes the scanner on the file, printing each token
	 * to System.out.
	 *
	 * @param file_path, path of the file to scan
	 * 
	 * @return 0 if successful scan, 1 otherwise
	 */
	public static int scan(String file_path) {
		int res = 0;
		scanner s = null;
		try {
			FileReader fr = new FileReader(file_path);
			s = new scanner(new BufferedReader(fr));

			// read initial symbol
			Symbol i = s.next_token();
			while (i.sym != sym.EOF) {
				System.out.print(s.symbolToString(i) + " ");
				i = s.next_token();
			}
			System.out.println("");

		} catch (Exception e) {
			System.err.println("Unexpected internal compiler error: " + e.toString());
			e.printStackTrace();
			res = 1;
		}

		return res;
	}

	/*
	 * Prints error counts if at least 1 error was encountered.
	 */
	public static void printCumulativeErrors(String file) {
		System.err.println("Found " + SCANNER_ERRORS + " unexpected symbol error(s) and " + PARSER_ERRORS
				+ " syntax error(s) in input file: " + file);
	}

	/*
	 * Prints error counts found during type-checking.
	 */
	public static void printTypeCheckingErrors(String file) {
		System.err.println("Found " + TYPE_CHECKING_ERRORS + " semantic error(s) in the input file: " + file);
	}

	/*
	 * Helper function to be called by the compiler's parser. This function should
	 * increment an error count and then verify that the error count has not gotten
	 * out of control. If the error count has surpassed a hard-limit, we exit the
	 * program here and now (with a useful error message).
	 */
	public static void handleTypeCheckingErrors(int new_errors) {
		TYPE_CHECKING_ERRORS += new_errors;
		if (TYPE_CHECKING_ERRORS > SEMANTICS_ERROR_LIMIT) {
			System.err.println(
					"Over " + SEMANTICS_ERROR_LIMIT + " type checking errors encountered.\n" + "Aborting compilation.");
			System.exit(1);
		}
	}

	/*
	 * Takes in array of command line arguments and a set to store flags.
	 *
	 * @param args, array of command line args
	 * 
	 * @param flags, set to store parsed command line flags
	 * 
	 * @requires args != null and flags != null
	 * 
	 * @returns filepath of target file, or returns null on improper argument inputs
	 */
	public static String parseCommandLineArgs(String[] args, Set<String> flags) {
		assert (flags != null);
		assert (args != null);
		final String USAGE = "Usage: [-S] filepath";

		String file_path = null;
		int argc = args.length;
		// check number of args
		if (argc > MAX_NUM_ARGS) {
			System.out.println(USAGE);
			return null;
		}

		boolean found_file_name = false;
		for (int i = 0; i < argc; i++) {
			if (flags.contains(args[i])) {
				// error on repeated flags
				System.out.println("Repeat flag: " + args[i]);
				System.out.println(USAGE);
				return null;
			}

			if (args[i].equals(S_FLAG)) {
				flags.add(S_FLAG);
			} else if (args[i].equals(A_FLAG)) {
				flags.add(A_FLAG);
			} else if (args[i].equals(P_FLAG)) {
				flags.add(P_FLAG);
			} else if (args[i].equals(T_FLAG)) {
				flags.add(T_FLAG);
			} else if (!found_file_name) {
				found_file_name = true;
				file_path = args[i];
			}
		}

		// no file path recognized
		if (!found_file_name) {
			System.out.println(USAGE);
			return null;
		}

		return file_path;
	}

	/*
	 * Helper function to print errors. This error is related to the SymbolTable
	 * pass.
	 */
	private static int handleFatalUndeclaredClass(boolean fatality) {
		if (fatality) {
			System.err.println("Fatal undeclared class error encountered.");
			System.err.println("Aborting Compilation.");
			return 1;
		}

		return 0;
	}

	/*
	 * Helper function to print error when a fatal inheritance loop is found.
	 */
	private static int handleFatalLoop(boolean fatality) {
		if (fatality) {
			System.err.println("Fatal class inheritance loop encountered.");
			System.err.println("Aborting Compilation");
			return 1;
		}

		return 0;
	}
}
