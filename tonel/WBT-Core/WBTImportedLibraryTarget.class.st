"
I represent an external library that is imported into the WBT tool.
"
Class {
	#name : #WBTImportedLibraryTarget,
	#superclass : #WBTLibraryTarget,
	#instVars : [
		'importLibFolder',
		'binaryLibFolder',
		'binaryInstallTargets'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #accessing }
WBTImportedLibraryTarget >> binaryLibFolder [
	^ binaryLibFolder
]

{ #category : #accessing }
WBTImportedLibraryTarget >> binaryLibFolder: anObject [
	binaryLibFolder := anObject
]

{ #category : #'as yet unclassified' }
WBTImportedLibraryTarget >> buildTargetDependencies [
	^ binaryInstallTargets
]

{ #category : #accessing }
WBTImportedLibraryTarget >> currentOutputVersionTimestamp [
	^ self class alwaysOldTimeStamp
]

{ #category : #installation }
WBTImportedLibraryTarget >> exportedDynamicLibraries [
	| dynamicLibrarySuffix binaryLibFolderFileReference |
	binaryLibFolder ifNil: [ ^ #() ].
	dynamicLibrarySuffix := self platform dynamicLibrarySuffix.
	dynamicLibrarySuffix ifEmpty: [ ^ #() ].
	
	binaryLibFolderFileReference := binaryLibFolder asFileReference.
	^ binaryLibFolderFileReference allChildren select: [ :each | each isDirectory not and: [ each basename includesSubstring: dynamicLibrarySuffix ] ]
]

{ #category : #'as yet unclassified' }
WBTImportedLibraryTarget >> generateBinaryInstallationTarget [
	| dynamicLibraries outputDirectoryFileRef binaryLibFolderFileRef |
	dynamicLibraries := self exportedDynamicLibraries.
	dynamicLibraries ifEmpty: [ ^ self ].
	
	outputDirectoryFileRef := package validBuildOutputDirectory.
	binaryLibFolderFileRef := binaryLibFolder asFileReference.
	binaryInstallTargets := dynamicLibraries collect: [ :each |
		| relativeName destFile |
		relativeName := each relativeTo: binaryLibFolderFileRef.
		destFile := outputDirectoryFileRef resolve: relativeName.
		self buildEnvironment makeOutputInstallFileTargetFrom: each into: destFile
	].
]

{ #category : #accessing }
WBTImportedLibraryTarget >> importLibFolder [
	^ importLibFolder
]

{ #category : #accessing }
WBTImportedLibraryTarget >> importLibFolder: anObject [
	importLibFolder := anObject
]

{ #category : #initialization }
WBTImportedLibraryTarget >> initialize [
	super initialize.
	binaryInstallTargets := #().
]

{ #category : #testing }
WBTImportedLibraryTarget >> isImportedLibrary [
	^ true
]

{ #category : #accessing }
WBTImportedLibraryTarget >> isSatisfiedBuildTarget [
	^ self buildTargetDependencies allSatisfy: [ :each | each isSatisfiedBuildTarget ]
]

{ #category : #accessing }
WBTImportedLibraryTarget >> newestBuildTargetDependenciesTimestamp [
	^ self class alwaysOldTimeStamp
]

{ #category : #testing }
WBTImportedLibraryTarget >> requiresLocalRPath [
	^ self exportedDynamicLibraries isNotEmpty
]

{ #category : #'as yet unclassified' }
WBTImportedLibraryTarget >> selectBuildAction [
	"Nothing is required here"
]
