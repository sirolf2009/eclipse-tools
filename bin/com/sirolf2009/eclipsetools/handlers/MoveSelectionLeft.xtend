package com.sirolf2009.eclipsetools.handlers

import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.jface.text.TextSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.texteditor.AbstractDecoratedTextEditor

class MoveSelectionLeft extends AbstractHandler {

	override execute(ExecutionEvent event) throws ExecutionException {
		val page = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage()
		val editor = page.getActiveEditor() as AbstractDecoratedTextEditor
		val selectionProvider = editor.getSelectionProvider()
		val selection = editor.getSelectionProvider().getSelection()
		if(!selection.isEmpty() && selection instanceof TextSelection) {
			val textSelection = selection as TextSelection
			val selectedText = textSelection.getText()
			val document = editor.getDocumentProvider().getDocument(editor.getEditorInput())

			if(textSelection.getOffset() > 0) {
				val charToLeft = document.getChar(textSelection.getOffset() - 1)
				document.replace(textSelection.getOffset() - 1, textSelection.getLength() + 1, selectedText + charToLeft)
				selectionProvider.setSelection(new TextSelection(document, textSelection.getOffset() - 1, textSelection.getLength()))
			}
		}
		return null
	}

}