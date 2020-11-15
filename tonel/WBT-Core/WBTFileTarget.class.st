Class {
	#name : #WBTFileTarget,
	#superclass : #WBTModuleSourceTarget,
	#instVars : [
		'fileReference',
		'relativeFileReference',
		'language',
		'dependencies'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #'instance creation' }
WBTFileTarget class >> for: aFileReference [
	^ self new
		language: WBTNullLanguage uniqueInstance;
		fileReference: aFileReference;
		relativeFileReference: aFileReference basename asFileReference;
		yourself
]

{ #category : #adding }
WBTFileTarget >> addDependencies: aCollectionOfDependencies [
	aCollectionOfDependencies do: [:each | self addDependency: each ]
]

{ #category : #adding }
WBTFileTarget >> addDependency: aDependency [
	dependencies := dependencies copyWith: aDependency
]

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

{ #category : #testing }
WBTFileTarget >> exists [
	^ fileReference exists
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

{ #category : #testing }
WBTFileTarget >> isSatisfiedBuildTarget [
	fileReference exists ifFalse: [ ^ false ].
	^ super isSatisfiedBuildTarget
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
