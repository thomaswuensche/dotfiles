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


jump_has_empty_row = (direction) ->
  editor = atom.workspace.getActiveTextEditor()
  cursor = editor.getCursorBufferPosition()

  rows = [1..atom.config.get('line-jumper.numberOfLines')]

  if direction == 'up'
    rows = rows.map (i) -> editor.getBuffer().isRowBlank(cursor.row - i)
  else
    rows = rows.map (i) -> editor.getBuffer().isRowBlank(cursor.row + i)

  return rows.some (row_empty) -> row_empty == true


at_last_row = ->
  editor = atom.workspace.getActiveTextEditor()
  return editor.getCursorBufferPosition().row == editor.getBuffer().getLastRow()


atom.commands.add 'atom-text-editor',
'custom:dynamic-line-jump-down': ->
  editor = atom.workspace.getActiveTextEditor()

  if jump_has_empty_row('down')
    editor.moveToBeginningOfNextParagraph()

    while editor.getBuffer().isRowBlank(editor.getCursorBufferPosition().row) and not at_last_row()
      editor.moveDown()

    if at_last_row() and editor.getBuffer().isRowBlank(editor.getCursorBufferPosition().row)
      editor.moveUp()
  else
    editor.moveDown(atom.config.get('line-jumper.numberOfLines'))

  editor.moveToFirstCharacterOfLine()


atom.commands.add 'atom-text-editor',
  'custom:select-line-contents': ->
    editor = atom.workspace.getActiveTextEditor()
    editor.moveToFirstCharacterOfLine()
    editor.selectToEndOfLine()


setCursorBufferPositions = (editor, points) ->
  for point, index in points
    if index == 0
      editor.setCursorBufferPosition(point)
    else
      editor.addCursorAtBufferPosition(point)


atom.commands.add 'atom-text-editor',
  'custom:duplicate-and-comment-line': ->
    editor = atom.workspace.getActiveTextEditor()

    buffer = editor.getBuffer()
    checkpoint = buffer.createCheckpoint()

    ranges = editor.getSelectedBufferRanges()

    texts_to_insert = []
    for range in ranges
      range_start = [range.start.row, 0]
      range_end = [range.end.row, Infinity]

      text = editor.getTextInBufferRange([range_start, range_end])
      texts_to_insert.push({text: text, row: range.start.row})

    editor.toggleLineCommentsInSelection()

    points = ranges.map (range) -> [range.end.row, 0]
    setCursorBufferPositions(editor, points)

    editor.insertNewlineBelow()

    cursors = editor.getCursorBufferPositions()

    cursors.sort (a, b) -> a.row - b.row
    texts_to_insert.sort (a, b) -> a.row - b.row
    ranges.sort (a, b) -> a.start.row - b.start.row

    added_lines = 0
    for cursor, index in cursors
      editor.setCursorBufferPosition([cursor.row + added_lines, cursor.column])

      if cursor.column != 0
        editor.deleteToBeginningOfLine()

      editor.insertText(texts_to_insert[index].text)

      cursors[index] = editor.getCursorBufferPosition()
      added_lines += ranges[index].getRowCount() - 1

    setCursorBufferPositions(editor, cursors)
    editor.moveToEndOfLine()

    buffer.groupChangesSinceCheckpoint(checkpoint)
