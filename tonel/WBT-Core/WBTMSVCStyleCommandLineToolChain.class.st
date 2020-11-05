Class {
	#name : #WBTMSVCStyleCommandLineToolChain,
	#superclass : #WBTCommandLineToolChain,
	#instVars : [
		'cl',
		'link'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> cl [
	^ cl
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> cl: anObject [
	cl := anObject
]

{ #category : #testing }
WBTMSVCStyleCommandLineToolChain >> isMSVCStyle [
	^ true
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> link [
	^ link
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> link: anObject [
	link := anObject
]

{ #category : #initialization }
WBTMSVCStyleCommandLineToolChain >> setForClangCL [
	self setForWindowsCommon.
	cl := 'clang-cl.exe'.
	link := 'link.exe'.
]

{ #category : #initialization }
WBTMSVCStyleCommandLineToolChain >> setForMSVC [
	self setForWindowsCommon.
	cl := 'cl.exe'.
	link := 'link.exe'.
]

{ #category : #initialization }
WBTMSVCStyleCommandLineToolChain >> setForWindowsCommon [
]
