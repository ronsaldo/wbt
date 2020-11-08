Class {
	#name : #WBTLibraryTarget,
	#superclass : #WBTModuleTarget,
	#instVars : [
		'importLibName',
		'importLibFolder',
		'binaryLibFolder'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #accessing }
WBTLibraryTarget >> binaryLibFolder [
	^ binaryLibFolder
]

{ #category : #accessing }
WBTLibraryTarget >> binaryLibFolder: anObject [
	binaryLibFolder := anObject
]

{ #category : #installation }
WBTLibraryTarget >> exportedDynamicLibraries [
	| dynamicLibrarySuffix binaryLibFolderFileReference |
	binaryLibFolder ifNil: [ ^ #() ].
	dynamicLibrarySuffix := self platform dynamicLibrarySuffix.
	dynamicLibrarySuffix ifEmpty: [ ^ #() ].
	
	binaryLibFolderFileReference := binaryLibFolder asFileReference.
	^ binaryLibFolderFileReference allChildren select: [ :each | each isDirectory not and: [ each basename includesSubstring: dynamicLibrarySuffix ] ]
]

{ #category : #accessing }
WBTLibraryTarget >> importLibFolder [
	^ importLibFolder
]

{ #category : #accessing }
WBTLibraryTarget >> importLibFolder: anObject [
	importLibFolder := anObject
]

{ #category : #accessing }
WBTLibraryTarget >> importLibName [
	^ importLibName
]

{ #category : #accessing }
WBTLibraryTarget >> importLibName: anObject [
	importLibName := anObject
]

{ #category : #installation }
WBTLibraryTarget >> installInto: outputDirectory [
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
WBTLibraryTarget >> isExportedLibrary [
	^ true
]

{ #category : #testing }
WBTLibraryTarget >> isLibrary [
	^ true
]
