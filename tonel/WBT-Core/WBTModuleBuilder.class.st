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

{ #category : #adding }
WBTModuleBuilder >> resource: resourceFileName [
	| relativePath absolutePath |
	relativePath := resourceFileName asFileReference.
	absolutePath := script workingDirectory resolve: relativePath.
	target addResource: absolutePath withRelativePath: relativePath

]

{ #category : #adding }
WBTModuleBuilder >> resource: resourceFileName withRelativePath: relativePath [
	| absolutePath |
	absolutePath := script workingDirectory resolve: resourceFileName asFileReference.
	target addResource: absolutePath withRelativePath: relativePath

]

{ #category : #adding }
WBTModuleBuilder >> resources: aCollectionOfResources [
	aCollectionOfResources do: [ :each | self resource: each ]
]

{ #category : #adding }
WBTModuleBuilder >> resourcesDirectory: rawResourceDirectory [
	target addResourcesDirectory: (script workingDirectory resolve: rawResourceDirectory asFileReference)

]

{ #category : #adding }
WBTModuleBuilder >> resourcesDirectory: rawResourceDirectory prefix: prefix [
	target addResourcesDirectory: (script workingDirectory resolve: rawResourceDirectory asFileReference) withPrefix: prefix

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
