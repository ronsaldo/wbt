Class {
	#name : #WBTModuleTarget,
	#superclass : #WBTPackageElementTarget,
	#instVars : [
		'name',
		'sources',
		'intermediateObjectFiles',
		'linkerLanguage',
		'outputFileReference',
		'buildTargetDependencies'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #adding }
WBTModuleTarget >> addIntermediateObjectFile: aSourceFile [
	self package addElement: aSourceFile.
	intermediateObjectFiles add: aSourceFile.

]

{ #category : #adding }
WBTModuleTarget >> addIntermediateObjectFiles: aCollectionOfIntermediateObjectFiles [
	aCollectionOfIntermediateObjectFiles do: [ :each | self addIntermediateObjectFile: each ].
]

{ #category : #adding }
WBTModuleTarget >> addSource: aSourceFile [
	self package addElement: aSourceFile.
	sources add: aSourceFile.
	aSourceFile addIntermediateObjectFilesToModule: self.
]

{ #category : #adding }
WBTModuleTarget >> addSources: aCollectionOfSources [
	aCollectionOfSources do: [ :each | self addSource: each ].
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> allObjectFiles [
	^ self buildTargetDependencies select: [ :each | each isObjectFile ]
]

{ #category : #converting }
WBTModuleTarget >> asFileReference [
	^ outputFileReference
]

{ #category : #converting }
WBTModuleTarget >> asWBTVarSubstitution [
	self assert: outputFileReference isNotNil.
	^ outputFileReference asWBTVarSubstitution
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> buildTargetDependencies [
	^ buildTargetDependencies ifNil: [ buildTargetDependencies := sources , intermediateObjectFiles ]
]

{ #category : #initialization }
WBTModuleTarget >> initialize [
	super initialize.
	sources := OrderedCollection new.
	intermediateObjectFiles := OrderedCollection new.
]

{ #category : #accessing }
WBTModuleTarget >> intermediateObjectFiles [
	^ intermediateObjectFiles
]

{ #category : #testing }
WBTModuleTarget >> isModuleTarget [
	^ true
]

{ #category : #accessing }
WBTModuleTarget >> name [
	^ name
]

{ #category : #accessing }
WBTModuleTarget >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> outputFileName [
	self subclassResponsibility
]

{ #category : #accessing }
WBTModuleTarget >> outputFileReference [
	^ outputFileReference ifNil: [ outputFileReference := self package validBuildOutputDirectory / self outputFileName ]
]

{ #category : #accessing }
WBTModuleTarget >> outputFileReference: anObject [
	outputFileReference := anObject
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> selectBuildAction [
	self subclassResponsibility
]

{ #category : #accessing }
WBTModuleTarget >> sources [
	^ sources
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> validLinkerLanguage [
	linkerLanguage ifNotNil: [ ^ linkerLanguage ].

	linkerLanguage := WBTNullLanguage uniqueInstance.
	sources do: [ :each |
		each language linkPriority > linkerLanguage linkPriority ifTrue: [
			linkerLanguage := each language.
		]
	].

	^ linkerLanguage
]
