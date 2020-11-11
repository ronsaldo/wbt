Class {
	#name : #WBTModuleBuilder,
	#superclass : #WBTObject,
	#instVars : [
		'script',
		'module'
	],
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTModuleBuilder class >> for: script named: moduleName [
	^ self new initializeForScript: script withModuleName: moduleName; yourself
]

{ #category : #'as yet unclassified' }
WBTModuleBuilder >> createModuleNamed: moduleName [
	self subclassResponsibility
]

{ #category : #initialization }
WBTModuleBuilder >> finish [
	module selectBuildAction.
	^ module
]

{ #category : #initialization }
WBTModuleBuilder >> initializeForScript: theScript withModuleName: theModuleName [
	script := theScript.
	module := self createModuleNamed: theModuleName.
	script package addElement: module.
]

{ #category : #'as yet unclassified' }
WBTModuleBuilder >> linkLibraries: aCollection [
	aCollection do: [ :each | self linkLibrary: each ].
]

{ #category : #'as yet unclassified' }
WBTModuleBuilder >> linkLibrary: libraryModuleOrName [
	module addLinkLibrary: libraryModuleOrName
]

{ #category : #accessing }
WBTModuleBuilder >> module [
	^ module
]

{ #category : #accessing }
WBTModuleBuilder >> package [
	^ script package
]

{ #category : #accessing }
WBTModuleBuilder >> script [
	^ script
]

{ #category : #accessing }
WBTModuleBuilder >> source: sourceFileName [
	| solvedSources |
	solvedSources := script solveSourceFileOrGlobPattern: sourceFileName.
	module addSources: solvedSources
]

{ #category : #accessing }
WBTModuleBuilder >> sources: aCollectionOfSources [
	aCollectionOfSources do: [ :each | self source: each ]
]
