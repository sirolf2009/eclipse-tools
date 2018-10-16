package com.sirolf2009.eclipsetools.handlers

import com.sirolf2009.eclipsetools.Util
import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.jdt.core.dom.ASTNode
import org.eclipse.jdt.core.dom.CompilationUnit
import org.eclipse.jdt.core.dom.Expression
import org.eclipse.jdt.core.dom.MethodDeclaration
import org.eclipse.jdt.core.dom.MethodInvocation
import org.eclipse.jdt.core.dom.VariableDeclaration
import org.eclipse.jface.text.IDocument
import org.eclipse.jface.text.TextSelection
import org.eclipse.ui.texteditor.ITextEditor

class MoveParamRight extends AbstractHandler {

	override execute(ExecutionEvent event) throws ExecutionException {
		val editor = Util.getCurrentEditor()
		val document = editor.getDocumentProvider().getDocument(editor.getEditorInput())
		val cu = Util.getCurrentCU()
		val currentNode = Util.getCurrentASTNode(cu)
		
		try {
			val currentParam = currentNode.variableDeclaration()
			val currentMethod = currentNode.methodDeclaration()
			val currentParameter = currentMethod.parameters().findFirst[toString().equals(currentParam.toString())] as VariableDeclaration
			moveParamDeclaration(cu, currentMethod, currentParameter, editor, document)
		} catch(NullPointerException e) {
			val argument = currentNode.methodInvocationArgument()
			val methodInvocation = currentNode.methodInvocation()
			moveParamInvocation(cu, methodInvocation, argument, editor, document)
		}
		return null
	}

	def static moveParamDeclaration(CompilationUnit cu, MethodDeclaration currentMethod, VariableDeclaration currentParam, ITextEditor editor, IDocument document) {
		val index = currentMethod.parameters().indexOf(currentParam)
		if(index < currentMethod.parameters().size()) {
			cu.recordModifications()
			val paramToRight = currentMethod.parameters().get(index + 1) as VariableDeclaration
			currentMethod.parameters().remove(paramToRight)
			currentMethod.parameters().remove(currentParam)
			currentMethod.parameters().add(index, paramToRight)
			currentMethod.parameters().add(index + 1, currentParam)
			val selection = Util.getCurrentSelection()
			cu.rewrite(document, null).apply(document)
			editor.getSelectionProvider().setSelection(new TextSelection(document, selection.getOffset() + paramToRight.getLength() + 2, selection.getLength()))
		}
	}

	def static moveParamInvocation(CompilationUnit cu, MethodInvocation currentMethod, Expression currentParam, ITextEditor editor, IDocument document) {
		val index = currentMethod.arguments().indexOf(currentParam)
		if(index < currentMethod.arguments().size()) {
			cu.recordModifications()
			val paramToRight = currentMethod.arguments().get(index + 1) as Expression
			currentMethod.arguments().remove(paramToRight)
			currentMethod.arguments().remove(currentParam)
			currentMethod.arguments().add(index, paramToRight)
			currentMethod.arguments().add(index + 1, currentParam)
			val selection = Util.getCurrentSelection()
			cu.rewrite(document, null).apply(document)
			editor.getSelectionProvider().setSelection(new TextSelection(document, selection.getOffset() + paramToRight.getLength() + 2, selection.getLength()))
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

	def static Expression methodInvocationArgument(ASTNode astNode) {
		if(astNode.getParent() instanceof MethodInvocation) {
			return astNode as Expression
		} else {
			return astNode.getParent().methodInvocationArgument()
		}
	}

	def static MethodInvocation methodInvocation(ASTNode astNode) {
		if(astNode instanceof MethodInvocation) {
			return astNode
		} else {
			return astNode.getParent().methodInvocation()
		}
	}

}
