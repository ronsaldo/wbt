Class {
	#name : #WBTLibrary,
	#superclass : #WBTPackageElement,
	#instVars : [
		'importLibName',
		'importLibFolder',
		'binaryLibFolder'
	],
	#category : #'WBT-Core'
}

{ #category : #accessing }
WBTLibrary >> binaryLibFolder [
	^ binaryLibFolder
]

{ #category : #accessing }
WBTLibrary >> binaryLibFolder: anObject [
	binaryLibFolder := anObject
]

{ #category : #installation }
WBTLibrary >> exportedDynamicLibraries [
	| dynamicLibrarySuffix binaryLibFolderFileReference |
	binaryLibFolder ifNil: [ ^ #() ].
	dynamicLibrarySuffix := self platform dynamicLibrarySuffix.
	dynamicLibrarySuffix ifEmpty: [ ^ #() ].
	
	binaryLibFolderFileReference := binaryLibFolder asFileReference.
	^ binaryLibFolderFileReference allChildren select: [ :each | each isDirectory not and: [ each basename includesSubstring: dynamicLibrarySuffix ] ]
]

{ #category : #accessing }
WBTLibrary >> importLibFolder [
	^ importLibFolder
]

{ #category : #accessing }
WBTLibrary >> importLibFolder: anObject [
	importLibFolder := anObject
]

{ #category : #accessing }
WBTLibrary >> importLibName [
	^ importLibName
]

{ #category : #accessing }
WBTLibrary >> importLibName: anObject [
	importLibName := anObject
]

{ #category : #installation }
WBTLibrary >> installInto: outputDirectory [
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
WBTLibrary >> isExportedLibrary [
	^ true
]

{ #category : #testing }
WBTLibrary >> isLibrary [
	^ true
]
