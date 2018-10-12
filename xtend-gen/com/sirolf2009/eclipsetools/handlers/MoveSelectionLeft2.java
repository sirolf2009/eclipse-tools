package com.sirolf2009.eclipsetools.handlers;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.TextSelection;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.ISelectionProvider;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.texteditor.AbstractDecoratedTextEditor;
import org.eclipse.xtext.xbase.lib.Exceptions;

@SuppressWarnings("all")
public class MoveSelectionLeft2 extends AbstractHandler {
  @Override
  public Object execute(final ExecutionEvent event) throws ExecutionException {
    try {
      final IWorkbenchPage page = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage();
      IEditorPart _activeEditor = page.getActiveEditor();
      final AbstractDecoratedTextEditor editor = ((AbstractDecoratedTextEditor) _activeEditor);
      final ISelectionProvider selectionProvider = editor.getSelectionProvider();
      final ISelection selection = editor.getSelectionProvider().getSelection();
      if (((!selection.isEmpty()) && (selection instanceof TextSelection))) {
        final TextSelection textSelection = ((TextSelection) selection);
        final String selectedText = textSelection.getText();
        final IDocument document = editor.getDocumentProvider().getDocument(editor.getEditorInput());
        int _offset = textSelection.getOffset();
        boolean _greaterThan = (_offset > 0);
        if (_greaterThan) {
          int _offset_1 = textSelection.getOffset();
          int _minus = (_offset_1 - 1);
          final char charToLeft = document.getChar(_minus);
          int _offset_2 = textSelection.getOffset();
          int _minus_1 = (_offset_2 - 1);
          int _length = textSelection.getLength();
          int _plus = (_length + 1);
          document.replace(_minus_1, _plus, (selectedText + Character.valueOf(charToLeft)));
          int _offset_3 = textSelection.getOffset();
          int _minus_2 = (_offset_3 - 1);
          int _length_1 = textSelection.getLength();
          TextSelection _textSelection = new TextSelection(document, _minus_2, _length_1);
          selectionProvider.setSelection(_textSelection);
        }
      }
      return null;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}
