package com.sirolf2009.eclipsetools.handlers

import com.sirolf2009.eclipsetools.Util
import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.jdt.core.dom.ASTNode
import org.eclipse.jdt.core.dom.CompilationUnit
import org.eclipse.jdt.core.dom.MethodDeclaration
import org.eclipse.jdt.core.dom.MethodInvocation
import org.eclipse.jdt.core.dom.VariableDeclaration
import org.eclipse.jface.text.IDocument
import org.eclipse.jface.text.TextSelection
import org.eclipse.ui.texteditor.ITextEditor
import org.eclipse.jdt.core.dom.Expression

import static com.sirolf2009.eclipsetools.Logger.*

class MoveParamLeft extends AbstractHandler {

	override execute(ExecutionEvent event) throws ExecutionException {
		info("move param left called")
		val editor = Util.getCurrentEditor()
		val document = editor.getDocumentProvider().getDocument(editor.getEditorInput())
		val cu = Util.getCurrentCU()
		val currentNode = Util.getCurrentASTNode(cu)
		
		info('''Selection: «currentNode»''')

		try {
			val currentParam = currentNode.variableDeclaration()
			val currentMethod = currentNode.methodDeclaration()
			val currentParameter = currentMethod.parameters().findFirst[toString().equals(currentParam.toString())] as VariableDeclaration
			info('''Moving param «currentParameter» in «currentMethod» to the left''')
			moveParamDeclaration(cu, currentMethod, currentParameter, editor, document)
		} catch(NullPointerException e) {
			info('''Current node: «currentNode»''')
			val argument = currentNode.methodInvocationArgument(currentNode)
			val methodInvocation = currentNode.methodInvocation(currentNode)
			info('''Moving arg «argument» in «methodInvocation» to the left''')
			moveParamInvocation(cu, methodInvocation, argument, editor, document)
		}
		return null
	}

	def static moveParamDeclaration(CompilationUnit cu, MethodDeclaration currentMethod, VariableDeclaration currentParam, ITextEditor editor, IDocument document) {
		val index = currentMethod.parameters().indexOf(currentParam)
		if(index > 0) {
			cu.recordModifications()
			val paramToLeft = currentMethod.parameters().get(index - 1) as VariableDeclaration
			currentMethod.parameters().remove(paramToLeft)
			currentMethod.parameters().remove(currentParam)
			currentMethod.parameters().add(index - 1, currentParam)
			currentMethod.parameters().add(index, paramToLeft)
			info('''Swapped «paramToLeft» and «currentParam»''')
			val selection = Util.getCurrentSelection()
			cu.rewrite(document, null).apply(document)
			editor.getSelectionProvider().setSelection(new TextSelection(document, selection.getOffset() - paramToLeft.getLength() - 2, selection.getLength()))
		}
	}

	def static moveParamInvocation(CompilationUnit cu, MethodInvocation currentMethod, Expression currentParam, ITextEditor editor, IDocument document) {
		val index = currentMethod.arguments().indexOf(currentParam)
		if(index > 0) {
			cu.recordModifications()
			val paramToLeft = currentMethod.arguments().get(index - 1) as Expression
			currentMethod.arguments().remove(paramToLeft)
			currentMethod.arguments().remove(currentParam)
			currentMethod.arguments().add(index - 1, currentParam)
			currentMethod.arguments().add(index, paramToLeft)
			info('''Swapped «paramToLeft» and «currentParam»''')
			val selection = Util.getCurrentSelection()
			cu.rewrite(document, null).apply(document)
			editor.getSelectionProvider().setSelection(new TextSelection(document, selection.getOffset() - paramToLeft.getLength() - 2, selection.getLength()))
		} else if(index < 0) {
			info('''Param «currentParam» does not exist in «currentMethod»''')
		} else {
			info('''Param «currentParam» is already the left-most param in «currentMethod»''')
		}
	}

	def static VariableDeclaration variableDeclaration(ASTNode astNode) {
		if(astNode instanceof VariableDeclaration) {
			return astNode
		} else {
			return astNode.getParent().variableDeclaration()
		}
	}

	def static MethodDeclaration methodDeclaration(ASTNode astNode) {
		if(astNode instanceof MethodDeclaration) {
			return astNode
		} else {
			return astNode.getParent().methodDeclaration()
		}
	}

	def static Expression methodInvocationArgument(ASTNode astNode, ASTNode child) {
		if(astNode instanceof MethodInvocation && (astNode as MethodInvocation).arguments().contains(child)) {
			return child as Expression
		} else {
			return astNode.getParent().methodInvocationArgument(astNode)
		}
	}

	def static MethodInvocation methodInvocation(ASTNode astNode, ASTNode child) {
		if(astNode instanceof MethodInvocation && (astNode as MethodInvocation).arguments().contains(child)) {
			return astNode as MethodInvocation
		} else {
			return astNode.getParent().methodInvocation(astNode)
		}
	}

}
