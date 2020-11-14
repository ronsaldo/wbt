Class {
	#name : #WBTModuleBuilder,
	#superclass : #WBTPackageElementBuilder,
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTModuleBuilder >> linkLibraries: aCollection [
	aCollection do: [ :each | self linkLibrary: each ].
]

{ #category : #'as yet unclassified' }
WBTModuleBuilder >> linkLibrary: libraryModuleOrName [
	target addLinkLibrary: libraryModuleOrName
]

{ #category : #accessing }
WBTModuleBuilder >> module [
	^ target
]

{ #category : #accessing }
WBTModuleBuilder >> package [
	^ script package
]

{ #category : #accessing }
WBTModuleBuilder >> source: sourceFileName [
	| solvedSources |
	solvedSources := script solveSourceFileOrGlobPattern: sourceFileName.
	target addSources: solvedSources
]

{ #category : #accessing }
WBTModuleBuilder >> sources: aCollectionOfSources [
	aCollectionOfSources do: [ :each | self source: each ]
]
