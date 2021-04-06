Class {
	#name : #WBTExternalLibraryBuilder,
	#superclass : #WBTLibraryBuilder,
	#instVars : [
		'sourceDirectory',
		'buildDirectory',
		'artifactDirectory',
		'extraVariables',
		'installDirectory'
	],
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> artifactDirectory: artifactDirectoryName [
	artifactDirectory := self validBuildDirectory resolve: (target buildEnvironment substitute: artifactDirectoryName variables: {
		#WBT_SOURCE_DIRECTORY . self validSourceDirectory.
		#WBT_BUILD_DIRECTORY . self validBuildDirectory.
		#WBT_INSTALL_DIRECTORY . self validInstallDirectory.
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
	self configureWithCMakeFlags: ''
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> configureWithCMakeFlags: flags [
	self configureWithCommand: '$(WBT_CMAKE_CONFIGURE) ' , flags
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
	^ target buildEnvironment substituteAndExecuteCommandLineCommand: command inDirectory: self validBuildDirectory variables: extraVariables , {
		#WBT_SOURCE_DIRECTORY . self validSourceDirectory.
		#WBT_BUILD_DIRECTORY . self validBuildDirectory.
		#WBT_INSTALL_DIRECTORY . self validInstallDirectory.
	}
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> extraVariables [
	^ extraVariables
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> extraVariables: theExtraVariables [
	extraVariables := theExtraVariables
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> initialize [
	super initialize.
	extraVariables := #().
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> installPrefixDirectory: artifactDirectoryName [
	artifactDirectory := self validBuildDirectory resolve: (target buildEnvironment substitute: artifactDirectoryName variables: {
		#WBT_SOURCE_DIRECTORY . self validSourceDirectory.
		#WBT_BUILD_DIRECTORY . self validBuildDirectory.
		#WBT_INSTALL_DIRECTORY . self validInstallDirectory.
	}) asFileReference.

	artifactDirectory exists ifFalse: [ self error: 'Failed to find the artifact directory.' ].
	target
		importLibFolder: artifactDirectory / 'lib';
		binaryLibFolder: artifactDirectory / 'bin';
		generateBinaryInstallationTarget
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> installWithCMake [
	self
		buildWithCommand: '$(WBT_CMAKE_INSTALL)';
		installPrefixDirectory: '$(WBT_INSTALL_DIRECTORY)'
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> sourceDirectory: relativeSourceDirectory [
	sourceDirectory := script workingDirectory resolve: relativeSourceDirectory asFileReference
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> useCMakeReleaseMode [
	self extraVariables: #(
		WBT_BUILD_MODE Release
	)
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> useSeparateBuildDirectory [
	buildDirectory := target package validBuildObjectDirectory / (target name , '-build').
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> validBuildDirectory [
	^ buildDirectory ifNil: [ buildDirectory := self validSourceDirectory ]
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> validInstallDirectory [
	^ installDirectory ifNil: [ installDirectory := target package validBuildObjectDirectory / (target name , '-install'). ]
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> validSourceDirectory [
	^ sourceDirectory ifNil: [ sourceDirectory := script workingDirectory  ]
]
