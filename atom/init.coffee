# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

# atom.commands.dispatch(atom.views.getView(atom.workspace), 'structure-view:show')

atom.commands.add 'atom-text-editor',
  'custom:duplicate-and-comment-line': ->
    editor = atom.workspace.getActiveTextEditor()
    row = editor.getCursorBufferPosition().row
    text = editor.lineTextForBufferRow(row)
    editor.toggleLineCommentsInSelection()
    editor.insertNewlineBelow()
    editor.deleteToBeginningOfLine()
    editor.insertText(text)
