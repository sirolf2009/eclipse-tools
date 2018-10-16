package com.sirolf2009.eclipsetools

import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.jdt.core.ICompilationUnit
import org.eclipse.jdt.core.dom.AST
import org.eclipse.jdt.core.dom.ASTParser
import org.eclipse.jdt.core.dom.CompilationUnit
import org.eclipse.jdt.core.dom.NodeFinder
import org.eclipse.jdt.ui.JavaUI
import org.eclipse.jface.text.ITextSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.texteditor.ITextEditor

class Util {

	def static getCurrentASTNode() {
		return getCurrentASTNode(getCurrentCU())
	}

	def static getCurrentASTNode(CompilationUnit cu) {
		val sel = getCurrentSelection()
		val finder = new NodeFinder(cu, sel.getOffset(), sel.getLength())
		return finder.getCoveringNode()
	}

	def static getCurrentCU() {
		return parse(getCurrentICU())
	}
	
	def static getCurrentICU() {
		val editor = getCurrentEditor()
		val typeRoot = JavaUI.getEditorInputTypeRoot(editor.getEditorInput())
		return typeRoot.getAdapter(ICompilationUnit) as ICompilationUnit
	}

	def static CompilationUnit parse(ICompilationUnit unit) {
		val parser = ASTParser.newParser(AST.JLS10);
		parser.setKind(ASTParser.K_COMPILATION_UNIT)
		parser.setSource(unit) // set source
		parser.setResolveBindings(true) // we need bindings later on
		return parser.createAST(new NullProgressMonitor()) as CompilationUnit // parse
	}
	
	def static getCurrentSelection() {
		val page = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage()
		val editor = page.getActiveEditor() as ITextEditor
		return editor.getSelectionProvider().getSelection() as ITextSelection
	}
	
	def static getCurrentEditor() {
		val page = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage()
		return page.getActiveEditor() as ITextEditor
	}

}
