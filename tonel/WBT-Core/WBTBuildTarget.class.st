Class {
	#name : #WBTBuildTarget,
	#superclass : #WBTObject,
	#instVars : [
		'buildActions'
	],
	#category : #'WBT-Core-Targets'
}

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

{ #category : #converting }
WBTBuildTarget >> asWBTVarSubstitution [
	self error: 'Invalid target in variable substitution'
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> buildActions [
	^ buildActions ifNil: [ buildActions := #() ]
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> buildTargetDependencies [
	^ #()
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> ensureIsBuilt [
	self runBuildActions
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
WBTBuildTarget >> isStaticLibrary [
	^ false
]

{ #category : #accessing }
WBTBuildTarget >> name [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> runBuildActions [
	^ self withUnsatisfiedSortedDependencies allSatisfy: [ :each | each runTargetBuildActions]
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> runTargetBuildActions [
	self buildActions do: [ :each | each execute ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> withSortedDependencies [
	^ WBTBuildTargetDependencySorter new addBuildTarget: self; value
]

{ #category : #'as yet unclassified' }
WBTBuildTarget >> withUnsatisfiedSortedDependencies [
	^ WBTBuildTargetDependencySorter new addBuildTarget: self; unsatisfiedBuildTargets
]
