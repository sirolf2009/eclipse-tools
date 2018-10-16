package com.sirolf2009.eclipsetools.handlers

import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.jface.text.BlockTextSelection
import org.eclipse.jface.text.IDocument
import org.eclipse.jface.text.TextSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.texteditor.ITextEditor

class MoveSelectionRight extends AbstractHandler {

	override execute(ExecutionEvent event) throws ExecutionException {
		val page = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage()
		val editor = page.getActiveEditor() as ITextEditor
		val selectionProvider = editor.getSelectionProvider()
		val selection = editor.getSelectionProvider().getSelection()
		val document = editor.getDocumentProvider().getDocument(editor.getEditorInput())
		if(!selection.isEmpty() && selection instanceof TextSelection) {
			val textSelection = selection as TextSelection

			if(textSelection.getLength() == 0) {
				new MoveParamRight().execute(event)
			} else {
				if(selection instanceof BlockTextSelection) {
					val blockSelection = selection as BlockTextSelection
					blockSelection.getRegions().forEach [
						moveRight(document, getOffset(), getLength())
					]
					val newSelection = new BlockTextSelection(document, blockSelection.getStartLine(), blockSelection.getStartColumn() + 1, blockSelection.getEndLine(), blockSelection.getEndColumn() + 1, 0)
					selectionProvider.setSelection(newSelection)
				} else if(selection instanceof TextSelection) {
					moveRight(document, textSelection.getOffset(), textSelection.getLength())
					selectionProvider.setSelection(new TextSelection(document, textSelection.getOffset() + 1, textSelection.getLength()))
				}
			}
		}
		return null
	}

	def static moveRight(IDocument document, int offset, int length) {
		if(offset + length < document.getLength()) {
			val lineLength = document.getLineLength(document.getLineOfOffset(offset))
			val column = document.getColumnOfOffset(offset) + length + 1
			val charToRight = document.getChar(offset + length)
			if(lineLength == column) {
				document.replace(offset, length + 1, " " + document.get(offset, length) + charToRight)
			} else {
				document.replace(offset, length + 1, charToRight + document.get(offset, length))
			}
		}
	}

	def static getColumnOfOffset(IDocument document, int offset) {
		return offset - document.getLineOffset(document.getLineOfOffset(offset))
	}

}
