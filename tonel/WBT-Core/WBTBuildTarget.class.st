Class {
	#name : #WBTBuildTarget,
	#superclass : #WBTObject,
	#instVars : [
		'buildActions',
		'newestBuildTargetDependenciesTimestamp',
		'currentOutputVersionTimestamp'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #constants }
WBTBuildTarget class >> alwaysNewToDateTimeStamp [
	^ Float infinity
]

{ #category : #constants }
WBTBuildTarget class >> alwaysOldTimeStamp [
	^ Float negativeInfinity
]

{ #category : #adding }
WBTBuildTarget >> addBuildAction: anAction [
	self assert: anAction parentTarget isNil.
	buildActions := self buildActions copyWith: anAction.
	anAction parentTarget: self
]

{ #category : #adding }
WBTBuildTarget >> addCommandLineCommandBuildAction: command inputFiles: inputFile outputFile: outputFile [
	self addCommandLineCommandBuildAction: command inputFiles: inputFile outputFile: outputFile variables: #()
]

{ #category : #adding }
WBTBuildTarget >> addCommandLineCommandBuildAction: command inputFiles: inputFile outputFile: outputFile variables: variables [
	self addBuildAction: (self package newCommandLineCommandBuildAction: command inputFiles: inputFile outputFile: outputFile variables: variables)
]

{ #category : #adding }
WBTBuildTarget >> addDirectoryCreationBuildAction: directoryFileReference [
	self addBuildAction: (WBTDirectoryCreationBuildAction new directory: directoryFileReference)
]

{ #category : #adding }
WBTBuildTarget >> addLazyBuildActionsWith: aBlock [
	^ self addBuildAction: (WBTLazyBuildActions new block: aBlock)
]

{ #category : #converting }
WBTBuildTarget >> asWBTVarSubstitution [
	self error: 'Invalid target in variable substitution'
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> buildActions [
	^ buildActions ifNil: [ buildActions := #() ]
]

{ #category : #accessing }
WBTBuildTarget >> buildEnvironment [
	^ self package buildEnvironment
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> buildTargetDependencies [
	^ #()
]

{ #category : #accessing }
WBTBuildTarget >> currentOutputVersionTimestamp [
	^ currentOutputVersionTimestamp ifNil: [
		currentOutputVersionTimestamp := self class alwaysNewToDateTimeStamp.
		self targetOutputFileReferences do: [ :each |
			each exists ifTrue: [ 
				currentOutputVersionTimestamp := currentOutputVersionTimestamp min: each modificationTime asUnixTime
			] ifFalse: [
				currentOutputVersionTimestamp := self class alwaysOldTimeStamp
			]
		].
		self targetOutputTargets do: [ :each |
			currentOutputVersionTimestamp := currentOutputVersionTimestamp min: each currentVersionTimestamp
		].
	
		currentOutputVersionTimestamp
	]
]

{ #category : #accessing }
WBTBuildTarget >> currentVersionTimestamp [
	^ self currentOutputVersionTimestamp max: self newestBuildTargetDependenciesTimestamp
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> ensureIsBuilt [
	self runBuildActions ifFalse: [ self error: 'Failed to load module that is not completely built'. ]
]

{ #category : #accessing }
WBTBuildTarget >> hostPlatformVariableEnvironment [
	^ self package hostPlatformVariableEnvironment
]

{ #category : #accessing }
WBTBuildTarget >> invalidateTimestamps [
	newestBuildTargetDependenciesTimestamp := nil.
	currentOutputVersionTimestamp := nil.
]

{ #category : #testing }
WBTBuildTarget >> isDynamicLibrary [
	^ false
]

{ #category : #testing }
WBTBuildTarget >> isExecutableProgram [
	^ false
]

{ #category : #testing }
WBTBuildTarget >> isExportedLibrary [
	^ false
]

{ #category : #testing }
WBTBuildTarget >> isImportedLibrary [
	^ false
]

{ #category : #testing }
WBTBuildTarget >> isLibrary [
	^ false
]

{ #category : #testing }
WBTBuildTarget >> isMainElementTarget [
	^ false
]

{ #category : #testing }
WBTBuildTarget >> isModuleTarget [
	^ false
]

{ #category : #testing }
WBTBuildTarget >> isObjectFile [
	^ false
]

{ #category : #testing }
WBTBuildTarget >> isObjectLibrary [
	^ false
]

{ #category : #testing }
WBTBuildTarget >> isSatisfiedBuildTarget [
	^ self currentOutputVersionTimestamp >= self newestBuildTargetDependenciesTimestamp
]

{ #category : #testing }
WBTBuildTarget >> isStaticLibrary [
	^ false
]

{ #category : #testing }
WBTBuildTarget >> isUnsatifiedBuildTarget [
	^ self isSatisfiedBuildTarget not
]

{ #category : #accessing }
WBTBuildTarget >> name [
	^ self subclassResponsibility
]

{ #category : #adding }
WBTBuildTarget >> newCommandLineCommandBuildAction: command inputFiles: inputFile outputFile: outputFile [
	^ self package newCommandLineCommandBuildAction: command inputFiles: inputFile outputFile: outputFile
]

{ #category : #adding }
WBTBuildTarget >> newCommandLineCommandBuildAction: command inputFiles: inputFile outputFile: outputFile variables: variables [
	^ self buildEnvironment newCommandLineCommandBuildAction: command inputFiles: inputFile outputFile: outputFile variables: variables parentEnvironment: self hostPlatformVariableEnvironment
]

{ #category : #accessing }
WBTBuildTarget >> newestBuildTargetDependenciesTimestamp [
	^ newestBuildTargetDependenciesTimestamp ifNil: [
		newestBuildTargetDependenciesTimestamp := self class alwaysOldTimeStamp.
		self buildTargetDependencies do: [ :each |
			newestBuildTargetDependenciesTimestamp := newestBuildTargetDependenciesTimestamp max: each currentVersionTimestamp
		].

		newestBuildTargetDependenciesTimestamp
	].
]

{ #category : #accessing }
WBTBuildTarget >> package [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> runBuildActions [
	^ self withUnsatisfiedSortedDependencies allSatisfy: [ :each | each runTargetBuildActions]
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> runTargetBuildActions [
	currentOutputVersionTimestamp := nil.
	^ self buildActions allSatisfy: [ :each | each execute ]
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> selectBuildAction [
	""
]

{ #category : #accessing }
WBTBuildTarget >> targetOutputFileReferences [
	^ #()
]

{ #category : #accessing }
WBTBuildTarget >> targetOutputTargets [
	^ #()
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> withSortedDependencies [
	^ WBTBuildTargetDependencySorter new addBuildTarget: self; value
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> withUnsatisfiedSortedDependencies [
	^ WBTBuildTargetDependencySorter new addBuildTarget: self; unsatisfiedBuildTargets
]
