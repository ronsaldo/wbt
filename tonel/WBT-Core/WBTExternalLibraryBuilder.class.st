Class {
	#name : #WBTExternalLibraryBuilder,
	#superclass : #WBTLibraryBuilder,
	#instVars : [
		'sourceDirectory',
		'buildDirectory',
		'artifactDirectory',
		'extraVariables',
		'installDirectory',
		'cacheDirectory'
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
	self configureWithCommand: '$(WBT_CMAKE_CONFIGURE)' variables: {
		#CMAKE_CONFIGURE_FLAGS . flags 
	}
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> configureWithCommand: command [
	self configureWithCommand: command variables: #() 
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> configureWithCommand: command variables: variables [
	(self executeCommand: command  variables: variables) = 0 ifFalse: [
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
	^ self executeCommand: command variables: #()
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> executeCommand: command variables: variables [
	self validBuildDirectory ensureCreateDirectory.
	^ target buildEnvironment substituteAndExecuteCommandLineCommand: command inDirectory: self validBuildDirectory variables: extraVariables , {
		#WBT_SOURCE_DIRECTORY . self validSourceDirectory.
		#WBT_BUILD_DIRECTORY . self validBuildDirectory.
		#WBT_INSTALL_DIRECTORY . self validInstallDirectory.
	} , variables
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
WBTExternalLibraryBuilder >> fetchParametersFromCacheOrBuildWith: aBlock [
	| buildCacheFileReference |
	buildCacheFileReference := self validExternalDependencyCacheDirectory / (target name , '-cache.json').
	buildCacheFileReference exists ifTrue: [ 
		| cacheData |
		cacheData := NeoJSONReader fromString: buildCacheFileReference contents.
		target
			importLibFolder: (cacheData at: 'importLibFolder') asFileReference;
			binaryLibFolder: (cacheData at: 'binaryLibFolder') asFileReference;
			generateBinaryInstallationTarget
	] ifFalse: [
		| cacheData |
		aBlock value: self.

		cacheData := NeoJSONWriter toStringPretty: (Dictionary newFromPairs: { 
			'importLibFolder' . target importLibFolder asFileReference fullName.
			'binaryLibFolder' . target binaryLibFolder asFileReference fullName.
		}).

		buildCacheFileReference parent ensureCreateDirectory.
		buildCacheFileReference writeStreamDo: [:out | out truncate; nextPutAll: cacheData ].
		
		"target importLibFolder: artifactDirectory / target buildEnvironment platform installImportLibFolderName;
		binaryLibFolder: artifactDirectory / target buildEnvironment platform installBinaryLibFolderName;
		generateBinaryInstallationTarget"
	].

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
		importLibFolder: artifactDirectory / target buildEnvironment platform installImportLibFolderName;
		binaryLibFolder: artifactDirectory / target buildEnvironment platform installBinaryLibFolderName;
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
WBTExternalLibraryBuilder >> validExternalDependencyCacheDirectory [
	^ cacheDirectory ifNil: [ cacheDirectory := target package validExternalDependencyCacheDirectory ]
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> validInstallDirectory [
	^ installDirectory ifNil: [ installDirectory := target package validBuildObjectDirectory / (target name , '-install'). ]
]

{ #category : #'as yet unclassified' }
WBTExternalLibraryBuilder >> validSourceDirectory [
	^ sourceDirectory ifNil: [ sourceDirectory := script workingDirectory  ]
]
