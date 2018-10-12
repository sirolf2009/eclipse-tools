package com.sirolf2009.eclipsetools.handlers;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.TextSelection;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.ISelectionProvider;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.statushandlers.StatusManager;
import org.eclipse.ui.texteditor.AbstractDecoratedTextEditor;

public class MoveSelectionLeft extends AbstractHandler {

	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
		final IWorkbenchPage page = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage();
		final AbstractDecoratedTextEditor editor = (AbstractDecoratedTextEditor) page.getActiveEditor();
		final ISelectionProvider selectionProvider = editor.getSelectionProvider();
		final ISelection selection = editor.getSelectionProvider().getSelection();
		if(!selection.isEmpty() && selection instanceof TextSelection) {
			final TextSelection textSelection = (TextSelection) selection;
			final String selectedText = textSelection.getText();
			final IDocument document = editor.getDocumentProvider().getDocument(editor.getEditorInput());

			if(textSelection.getOffset() > 0) {
				try {
					final char charToLeft = document.getChar(textSelection.getOffset() - 1);
					document.replace(textSelection.getOffset() - 1, textSelection.getLength() + 1, selectedText + charToLeft);
					selectionProvider.setSelection(new TextSelection(document, textSelection.getOffset() - 1, textSelection.getLength()));
				} catch(final Exception e) {
					final IStatus status = new Status(IStatus.ERROR, "sirolf2009-eclipse-tools", "Error while moving left", e);
					StatusManager.getManager().handle(status, StatusManager.SHOW);
				}
			}
		}
		return null;
	}

}