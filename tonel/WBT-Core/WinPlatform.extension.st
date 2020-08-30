Extension { #name : #WinPlatform }

{ #category : #'*WBT-Core' }
WinPlatform >> wbtPlatform [
	^ Smalltalk wordSize = 4
		ifTrue: [ WBTPlatform win32 ]
		ifFalse: [ WBTPlatform win64 ]
]
