package uece.br.compiladores;

import br.uece.compiladores.jflex.CompiladoresJFlex;

public class Principal {

	public static void main(String[] args) {
		CompiladoresJFlex jflex = new CompiladoresJFlex();
		jflex.generateLexer();
	}
}
