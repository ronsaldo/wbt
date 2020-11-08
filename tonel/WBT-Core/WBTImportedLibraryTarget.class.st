"
I represent an external library that is imported into the WBT tool.
"
Class {
	#name : #WBTImportedLibraryTarget,
	#superclass : #WBTLibraryTarget,
	#instVars : [
		'importLibFolder',
		'binaryLibFolder'
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

{ #category : #installation }
WBTImportedLibraryTarget >> exportedDynamicLibraries [
	| dynamicLibrarySuffix binaryLibFolderFileReference |
	binaryLibFolder ifNil: [ ^ #() ].
	dynamicLibrarySuffix := self platform dynamicLibrarySuffix.
	dynamicLibrarySuffix ifEmpty: [ ^ #() ].
	
	binaryLibFolderFileReference := binaryLibFolder asFileReference.
	^ binaryLibFolderFileReference allChildren select: [ :each | each isDirectory not and: [ each basename includesSubstring: dynamicLibrarySuffix ] ]
]

{ #category : #accessing }
WBTImportedLibraryTarget >> importLibFolder [
	^ importLibFolder
]

{ #category : #accessing }
WBTImportedLibraryTarget >> importLibFolder: anObject [
	importLibFolder := anObject
]

{ #category : #installation }
WBTImportedLibraryTarget >> installInto: outputDirectory [
	| outputDirectoryFileRef dynamicLibraries binaryLibFolderFileRef |
	dynamicLibraries := self exportedDynamicLibraries.
	dynamicLibraries ifEmpty: [ ^ self ].
	outputDirectoryFileRef := outputDirectory asFileReference.
	binaryLibFolderFileRef := binaryLibFolder asFileReference.
	dynamicLibraries do: [ :each |
		| relativeName destFile |
		relativeName := each relativeTo: binaryLibFolderFileRef.
		destFile := outputDirectoryFileRef resolve: relativeName.
		self buildEnvironment installFile: each in: destFile
	].
]

{ #category : #testing }
WBTImportedLibraryTarget >> isImportedLibrary [
	^ true
]

{ #category : #'as yet unclassified' }
WBTImportedLibraryTarget >> selectBuildAction [
	"Nothing is required here"
]
