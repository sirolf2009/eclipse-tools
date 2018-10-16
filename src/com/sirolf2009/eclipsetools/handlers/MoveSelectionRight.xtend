package com.sirolf2009.eclipsetools.handlers

import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.jface.text.TextSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.texteditor.ITextEditor

class MoveSelectionRight extends AbstractHandler {

	override execute(ExecutionEvent event) throws ExecutionException {
		val page = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage()
		val editor = page.getActiveEditor() as ITextEditor
		val selectionProvider = editor.getSelectionProvider()
		val selection = editor.getSelectionProvider().getSelection()
		if(!selection.isEmpty() && selection instanceof TextSelection) {
			val textSelection = selection as TextSelection
			val selectedText = textSelection.getText()
			val document = editor.getDocumentProvider().getDocument(editor.getEditorInput())

			if(textSelection.getLength() == 0) {
				new MoveParamRight().execute(event)
			} else {
				if(textSelection.getOffset() + textSelection.getLength() < document.getLength()) {
					val charToRight = document.getChar(textSelection.getOffset() + textSelection.getLength())
					document.replace(textSelection.getOffset(), textSelection.getLength() + 1, charToRight + selectedText)
					selectionProvider.setSelection(new TextSelection(document, textSelection.getOffset() + 1, textSelection.getLength()))
				}
			}
		}
		return null
	}

}
