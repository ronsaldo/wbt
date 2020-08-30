Metacello new
  baseline: 'WBT';
  repository: 'gitlocal://tonel';
  load.

"Save the image"
(Smalltalk saveAs: 'wbt')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].
