package com.sirolf2009.eclipsetools.handlers

import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.jface.text.BlockTextSelection
import org.eclipse.jface.text.IDocument
import org.eclipse.jface.text.TextSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.texteditor.ITextEditor

class MoveSelectionLeft extends AbstractHandler {

	override execute(ExecutionEvent event) throws ExecutionException {
		val page = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage()
		val editor = page.getActiveEditor() as ITextEditor
		val selectionProvider = editor.getSelectionProvider()
		val selection = editor.getSelectionProvider().getSelection()
		val document = editor.getDocumentProvider().getDocument(editor.getEditorInput())
		if(!selection.isEmpty() && selection instanceof TextSelection) {

			val textSelection = selection as TextSelection
			val selectedText = textSelection.getText()

			if(textSelection.getLength() == 0) {
				new MoveParamLeft().execute(event)
			} else {
				if(textSelection.getOffset() > 0) {
					val charToLeft = document.getChar(textSelection.getOffset() - 1)
					document.replace(textSelection.getOffset() - 1, textSelection.getLength() + 1, selectedText + charToLeft)

					if(selection instanceof BlockTextSelection) {
						val blockSelection = selection as BlockTextSelection
						val didNotMove = blockSelection.getRegions().exists [
							!moveLeft(document, getOffset(), getLength())
						]
						if(!didNotMove) {
							val newSelection = new BlockTextSelection(document, blockSelection.getStartLine(), blockSelection.getStartColumn() - 1, blockSelection.getEndLine(), blockSelection.getEndColumn() - 1, 0)
							selectionProvider.setSelection(newSelection)
						}
					} else if(selection instanceof TextSelection) {
						if(moveLeft(document, textSelection.getOffset(), textSelection.getLength())) {
							selectionProvider.setSelection(new TextSelection(document, textSelection.getOffset() - 1, textSelection.getLength()))
						}
					}

				}

			}

		}
		return null
	}

	def static moveLeft(IDocument document, int offset, int length) {
		if(offset > 0) {
			val column = document.getColumnOfOffset(offset)
			if(column > 0) {
				val charToLeft = document.getChar(offset - 1)
				document.replace(offset - 1, length + 1, document.get(offset, length) + charToLeft)
				return true
			}
		}
	}

	def static getColumnOfOffset(IDocument document, int offset) {
		return offset - document.getLineOffset(document.getLineOfOffset(offset))
	}

}
