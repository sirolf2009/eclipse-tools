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
public class MoveSelectionRight extends AbstractHandler {
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
        int _length = textSelection.getLength();
        int _plus = (_offset + _length);
        int _length_1 = document.getLength();
        boolean _lessThan = (_plus < _length_1);
        if (_lessThan) {
          int _offset_1 = textSelection.getOffset();
          int _length_2 = textSelection.getLength();
          int _plus_1 = (_offset_1 + _length_2);
          final char charToRight = document.getChar(_plus_1);
          int _offset_2 = textSelection.getOffset();
          int _length_3 = textSelection.getLength();
          int _plus_2 = (_length_3 + 1);
          String _plus_3 = (Character.valueOf(charToRight) + selectedText);
          document.replace(_offset_2, _plus_2, _plus_3);
          int _offset_3 = textSelection.getOffset();
          int _plus_4 = (_offset_3 + 1);
          int _length_4 = textSelection.getLength();
          TextSelection _textSelection = new TextSelection(document, _plus_4, _length_4);
          selectionProvider.setSelection(_textSelection);
        }
      }
      return null;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}
