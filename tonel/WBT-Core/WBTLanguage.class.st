Class {
	#name : #WBTLanguage,
	#superclass : #Object,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WBT-Core-Language'
}

{ #category : #'as yet unclassified' }
WBTLanguage class >> allSupportedLanguages [
	| result |
	result := OrderedCollection new.
	self allSubclassesDo: [ :each |
		each isSupported ifTrue: [
			result add: each uniqueInstance
		]
	].
	^ result
]

{ #category : #testing }
WBTLanguage class >> isSupported [
	^ false
]

{ #category : #accessing }
WBTLanguage class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'as yet unclassified' }
WBTLanguage >> createBuildActionForDynamicLibrary: dynamicLibrary [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WBTLanguage >> createBuildActionForExecutableProgram: executableProgram [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WBTLanguage >> createBuildActionForStaticLibrary: staticLibrary [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WBTLanguage >> createIntermediateObjectFilesFor: sourceFile module: targetModule [
	"Nothing required here."
]

{ #category : #'as yet unclassified' }
WBTLanguage >> handlesFileExtension: aFileExtension [
	^ false
]

{ #category : #testing }
WBTLanguage >> isObjectFile [
	^ false
]

{ #category : #'as yet unclassified' }
WBTLanguage >> linkPriority [
	^ 0
]

{ #category : #'as yet unclassified' }
WBTLanguage >> makeSourceFileElementFor: fileReference withRelativeFileReference: relativeFileReference [
	^ WBTFileTarget new
		language: self;
		fileReference: fileReference;
		relativeFileReference: relativeFileReference;
		yourself
]
