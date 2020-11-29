Class {
	#name : #WBTExternalLibraryBuilder,
	#superclass : #WBTLibraryBuilder,
	#instVars : [
		'sourceDirectory',
		'buildDirectory',
		'artifactDirectory'
	],
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> artifactDirectory: artifactDirectoryName [
	artifactDirectory := self validBuildDirectory resolve: (target buildEnvironment substitute: artifactDirectoryName variables: {
		#WBT_SOURCE_DIRECTORY . self validSourceDirectory.
		#WBT_BUILD_DIRECTORY . self validBuildDirectory.
	}) asFileReference.

	artifactDirectory exists ifFalse: [ self error: 'Failed to find the artifact directory.' ].
	target
		importLibFolder: artifactDirectory;
		binaryLibFolder: artifactDirectory;
		generateBinaryInstallationTarget
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> buildWithCMake [
	self buildWithCommand: '$(WBT_CMAKE_BUILD)'
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> buildWithCommand: command [
	(self executeCommand: command) = 0 ifFalse: [
		self error: 'Failed to build external library'
	]
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> configureWithCMake [
	self configureWithCommand: '$(WBT_CMAKE_CONFIGURE)'
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> configureWithCommand: command [
	(self executeCommand: command) = 0 ifFalse: [
		self error: 'Failed to configure external library'
	]
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> createTargetNamed: moduleName [
	^ WBTImportedLibraryTarget new
		name: moduleName;
		yourself
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> executeCommand: command [
	self validBuildDirectory ensureCreateDirectory.
	^ target buildEnvironment substituteAndExecuteCommandLineCommand: command inDirectory: self validBuildDirectory variables: {
		#WBT_SOURCE_DIRECTORY . self validSourceDirectory.
		#WBT_BUILD_DIRECTORY . self validBuildDirectory.
	}
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> sourceDirectory: relativeSourceDirectory [
	sourceDirectory := script workingDirectory resolve: relativeSourceDirectory asFileReference
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> useSeparateBuildDirectory [
	buildDirectory := target package validBuildObjectDirectory / target name.
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> validBuildDirectory [
	^ buildDirectory ifNil: [ buildDirectory := self validSourceDirectory ]
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> validSourceDirectory [
	^ sourceDirectory ifNil: [ sourceDirectory := script workingDirectory  ]
]
