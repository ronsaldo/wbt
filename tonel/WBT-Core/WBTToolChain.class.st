Class {
	#name : #WBTToolChain,
	#superclass : #Object,
	#category : #'WBT-Core-Environment'
}

{ #category : #'as yet unclassified' }
WBTToolChain class >> linuxClang [
	^ self unixClang
		rpathLocalLinkerArgument: '-Wl,-rpath=.';
		yourself
]

{ #category : #'as yet unclassified' }
WBTToolChain class >> linuxGCC [
	^ self unixGCC
		rpathLocalLinkerArgument: '-Wl,-rpath=.';
		yourself
]

{ #category : #'as yet unclassified' }
WBTToolChain class >> osxClang [
	^ self unixClang
]

{ #category : #'as yet unclassified' }
WBTToolChain class >> unixClang [
	^ WBTUnixStyleCommandLineToolChain new setForClang
]

{ #category : #'as yet unclassified' }
WBTToolChain class >> unixGCC [
	^ WBTUnixStyleCommandLineToolChain new setForGCC
]

{ #category : #'as yet unclassified' }
WBTToolChain class >> windowsClang [
	^ WBTUnixStyleCommandLineToolChain new setForWindowsClang
]

{ #category : #'as yet unclassified' }
WBTToolChain class >> windowsClangCL [
	^ WBTMSVCStyleCommandLineToolChain new setForClangCL
]

{ #category : #'as yet unclassified' }
WBTToolChain class >> windowsMSVC [
	^ WBTMSVCStyleCommandLineToolChain new setForMSVC
]

{ #category : #testing }
WBTToolChain >> isCommandLineToolChain [
	^ false
]

{ #category : #testing }
WBTToolChain >> isMSVCStyle [
	^ false
]

{ #category : #testing }
WBTToolChain >> isUnixStyle [
	^ false
]

{ #category : #'as yet unclassified' }
WBTToolChain >> substitutionVariables [
	^ #()
]
