Extension { #name : #String }

{ #category : #'*WBT-Core' }
String >> withPlatformSpecificLineEndings [
	^ Smalltalk os isWindows
		ifTrue: [ self withInternetLineEndings ]
		ifFalse: [ self withUnixLineEndings ]
]
