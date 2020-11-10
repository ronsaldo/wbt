Class {
	#name : #WBTFileTarget,
	#superclass : #WBTPackageElementTarget,
	#instVars : [
		'fileReference',
		'relativeFileReference',
		'language',
		'dependencies'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #adding }
WBTFileTarget >> addIntermediateObjectFilesToModule: targetModule [
	language createIntermediateObjectFilesFor: self module: targetModule

]

{ #category : #converting }
WBTFileTarget >> asFileReference [
	^ fileReference
]

{ #category : #converting }
WBTFileTarget >> asWBTVarSubstitution [
	self assert: fileReference isNotNil.
	^ fileReference asWBTVarSubstitution
]

{ #category : #'as yet unclassified' }
WBTFileTarget >> buildTargetDependencies [
	^ dependencies
]

{ #category : #accessing }
WBTFileTarget >> dependencies [
	^ dependencies
]

{ #category : #accessing }
WBTFileTarget >> dependencies: anObject [
	dependencies := anObject
]

{ #category : #accessing }
WBTFileTarget >> fileReference [
	^ fileReference
]

{ #category : #accessing }
WBTFileTarget >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #initialization }
WBTFileTarget >> initialize [
	super initialize.
	language := WBTNullLanguage uniqueInstance.
	dependencies := #().
]

{ #category : #testing }
WBTFileTarget >> isObjectFile [
	^ language isObjectFile
]

{ #category : #accessing }
WBTFileTarget >> language [
	^ language
]

{ #category : #accessing }
WBTFileTarget >> language: anObject [
	language := anObject
]

{ #category : #accessing }
WBTFileTarget >> name [
	^ relativeFileReference fullPath fullName
]

{ #category : #accessing }
WBTFileTarget >> relativeFileReference [
	^ relativeFileReference
]

{ #category : #accessing }
WBTFileTarget >> relativeFileReference: anObject [
	relativeFileReference := anObject
]
