Class {
	#name : #WBTUnixStyleCommandLineToolChain,
	#superclass : #WBTCommandLineToolChain,
	#instVars : [
		'cc',
		'cxx',
		'ld',
		'ar',
		'objcopy',
		'rpathLocalLinkerArgument'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> ar [
	^ ar
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> ar: anObject [
	ar := anObject
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> cc [
	^ cc
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> cc: anObject [
	cc := anObject
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> cxx [
	^ cxx
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> cxx: anObject [
	cxx := anObject
]

{ #category : #initialization }
WBTUnixStyleCommandLineToolChain >> initialize [
	super initialize.
	importLibraryFolderArgumentPrefix := '-L'.
	importLibraryArgumentPrefix := '-l'.

]

{ #category : #testing }
WBTUnixStyleCommandLineToolChain >> isUnixStyle [
	^ true
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> ld [
	^ ld
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> ld: anObject [
	ld := anObject
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> objcopy [
	^ objcopy
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> objcopy: anObject [
	objcopy := anObject
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> rpathLocalLinkerArgument [
	^ rpathLocalLinkerArgument
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> rpathLocalLinkerArgument: anObject [
	rpathLocalLinkerArgument := anObject
]

{ #category : #initialization }
WBTUnixStyleCommandLineToolChain >> setForClang [
	self setForUnixCommon.
	cc := 'clang'.
	cxx := 'clang++'
]

{ #category : #initialization }
WBTUnixStyleCommandLineToolChain >> setForGCC [
	self setForUnixCommon.
	cc := 'gcc'.
	cxx := 'g++'
]

{ #category : #initialization }
WBTUnixStyleCommandLineToolChain >> setForUnixCommon [
	ld := 'ld'.
	ar := 'ar'.
	objcopy := 'objcopy'.
]

{ #category : #initialization }
WBTUnixStyleCommandLineToolChain >> setForWindowsClang [
	cc := 'clang.exe'.
	cxx := 'clang++.exe'.
]
