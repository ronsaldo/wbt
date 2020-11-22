Extension { #name : #WinPlatform }

{ #category : #'*WBT-Core' }
WinPlatform >> wbtPlatform [
	^ Smalltalk wordSize = 4
		ifTrue: [ WBTPlatform win32 ]
		ifFalse: [ WBTPlatform win64 ]
]

{ #category : #'*WBT-Core' }
WinPlatform >> wbtPlatformWithClang [
	^ Smalltalk wordSize = 4
		ifTrue: [ WBTPlatform windowsClangCLX86 ]
		ifFalse: [ WBTPlatform windowsClangCLX64 ]
]

{ #category : #'*WBT-Core' }
WinPlatform >> wbtPlatformWithLLD [
	^ Smalltalk wordSize = 4
		ifTrue: [ WBTPlatform windowsLLDX86 ]
		ifFalse: [ WBTPlatform windowsLLDX64 ]
]
