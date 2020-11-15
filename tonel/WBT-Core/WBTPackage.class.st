Class {
	#name : #WBTPackage,
	#superclass : #WBTBuildTarget,
	#instVars : [
		'name',
		'buildEnvironment',
		'elements',
		'dependencies',
		'buildObjectDirectory',
		'mainElements',
		'buildTargetDependencies',
		'hostPlatformVariableEnvironment',
		'includeDirectories',
		'publicIncludeDirectories',
		'activeIncludeDirectories'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #adding }
WBTPackage >> activeIncludeDirectories [
	^ activeIncludeDirectories ifNil: [ activeIncludeDirectories := (includeDirectories , publicIncludeDirectories) collect: [ :each | each fullName ] ]
]

{ #category : #adding }
WBTPackage >> addElement: anElement [
	self assert: anElement package isNil.
	anElement package: self.
	elements add: anElement.
	anElement isMainElementTarget ifTrue: [
		mainElements add: anElement
	].
	^ anElement
]

{ #category : #accessing }
WBTPackage >> allExportedLibrariesLinkerArguments [
	self flag: 'FIXME: include the dependencies here also.'.
	^ self exportedLibrariesLinkerArguments

]

{ #category : #accessing }
WBTPackage >> buildEnvironment [
	^ buildEnvironment
]

{ #category : #accessing }
WBTPackage >> buildEnvironment: anObject [
	buildEnvironment := anObject
]

{ #category : #'as yet unclassified' }
WBTPackage >> buildObjectDirectory: aDirectory [
	buildObjectDirectory := aDirectory asFileReference.
]

{ #category : #'as yet unclassified' }
WBTPackage >> buildTargetDependencies [
	^ buildTargetDependencies ifNil: [ buildTargetDependencies := dependencies , mainElements ]
]

{ #category : #accessing }
WBTPackage >> dependencies [
	^ dependencies
]

{ #category : #'as yet unclassified' }
WBTPackage >> evaluateScriptFromFile: file [
	| fileReference |
	fileReference := file asFileReference.
	^ self inFolder: fileReference parent evaluateScript: fileReference contents
]

{ #category : #accessing }
WBTPackage >> exportedLibraries [
	^ mainElements select: [ :each | each isExportedLibrary ]
]

{ #category : #accessing }
WBTPackage >> exportedLibrariesLinkerArguments [
	^ buildEnvironment platform toolchain formatLinkerArgumentsForLinkingLibraries: self exportedLibraries
]

{ #category : #'as yet unclassified' }
WBTPackage >> generateTargetFile: fileName inputFiles: inputFiles withCommand: compilationCommand [
	^ self addElement: (self buildEnvironment generateTargetFile: fileName inputFiles: inputFiles withCommand: compilationCommand)
]

{ #category : #'as yet unclassified' }
WBTPackage >> generateTargetFile: fileName inputFiles: inputFiles withCommand: compilationCommand variables: variables [
	^ self addElement: (self buildEnvironment generateTargetFile: fileName inputFiles: inputFiles withCommand: compilationCommand  variables: variables)
]

{ #category : #'as yet unclassified' }
WBTPackage >> getMainTargetNamed: expectedName ifAbsent: absentBlock [
	^ mainElements detect: [ :each | each name = expectedName ] ifNone: absentBlock
]

{ #category : #'as yet unclassified' }
WBTPackage >> hostPlatformVariableEnvironment [
	^ hostPlatformVariableEnvironment ifNil: [ hostPlatformVariableEnvironment := WBTVariableSubstitutionEnvironment parent: buildEnvironment hostPlatformVariableEnvironment withVariables: {
		#WBT_ACTIVE_INCLUDE_DIRECTORIES . [ self activeIncludeDirectories ]
	}]
]

{ #category : #adding }
WBTPackage >> importLibrary: libraryName [
	^ self importLibrary: libraryName with: [:importedLibrary | ]
]

{ #category : #adding }
WBTPackage >> importLibrary: libraryName fromDebianPackage: debianPackageName [
	^ self importLibrary: libraryName
]

{ #category : #adding }
WBTPackage >> importLibrary: libraryName fromLibFolder: libraryFolderName [
	^ self importLibrary: libraryName with: [:importedLibrary |
		importedLibrary
			importLibFolder: libraryFolderName
	]
]

{ #category : #adding }
WBTPackage >> importLibrary: libraryName fromLibFolder: libraryFolderName binFolder: libraryBinaryFolder [
	^ self importLibrary: libraryName with: [:importedLibrary |
		importedLibrary
			importLibFolder: libraryFolderName;
			binaryLibFolder: libraryBinaryFolder
	]
]

{ #category : #adding }
WBTPackage >> importLibrary: libraryName with: aBlock [
	| importedLibraryTarget |
	importedLibraryTarget := self addElement: (WBTImportedLibraryTarget new
		name: libraryName;
		yourself
	).
	aBlock value: importedLibraryTarget.
	importedLibraryTarget generateBinaryInstallationTarget.
	^ importedLibraryTarget
]

{ #category : #adding }
WBTPackage >> importPackage: packageName [
	dependencies add: packageName
]

{ #category : #adding }
WBTPackage >> importPhanapiBintrayLibrary: libraryName fromUser: bintrayUser repository: repositoryName package: packageName [
	| dynlibPath parentFolder |
	(Smalltalk globals at: #PhaNAPIBintray)
		fetchLibrary: libraryName fromUser: bintrayUser repository: repositoryName package: packageName.
	dynlibPath := (Smalltalk globals at: #PhaNAPI)
		fullLibraryPathForCurrentPlatform: libraryName package: repositoryName.
	parentFolder := dynlibPath parent fullName.
	^ self importLibrary: libraryName fromLibFolder: parentFolder binFolder: parentFolder
]

{ #category : #'as yet unclassified' }
WBTPackage >> inFolder: folder evaluateBlock: block [
	^ block value: (self makeScriptEnvironmentInFolder: folder)
]

{ #category : #'as yet unclassified' }
WBTPackage >> inFolder: folder evaluateScript: scriptSource [
	^ (self makeScriptEnvironmentInFolder: folder)
		evaluateScript: scriptSource
]

{ #category : #adding }
WBTPackage >> includeDirectories: directoriesToInclude [
	directoriesToInclude do: [ :each | self includeDirectory: each ]
]

{ #category : #adding }
WBTPackage >> includeDirectory: aDirectoryToInclude [
	includeDirectories add: aDirectoryToInclude asFileReference
]

{ #category : #adding }
WBTPackage >> includePublicDirectories: directoriesToInclude [
	directoriesToInclude do: [ :each | self includePublicDirectory: each ]
]

{ #category : #adding }
WBTPackage >> includePublicDirectory: aDirectoryToInclude [
	publicIncludeDirectories add: aDirectoryToInclude asFileReference asAbsolute canonicalize
]

{ #category : #initialization }
WBTPackage >> initialize [
	super initialize.
	dependencies := OrderedCollection new.
	elements := OrderedCollection new.
	mainElements := OrderedCollection new.
	includeDirectories := OrderedCollection new.
	publicIncludeDirectories := OrderedCollection new.
]

{ #category : #testing }
WBTPackage >> isRootPackage [
	^ name = self buildEnvironment mainPackageName
]

{ #category : #accessing }
WBTPackage >> mainElements [
	^ mainElements
]

{ #category : #actions }
WBTPackage >> makeExportedLibraries [
	self flag: 'TODO: Implement myself'
]

{ #category : #'as yet unclassified' }
WBTPackage >> makeScriptEnvironmentInFolder: folder [
	^ WBTScriptEnvironment new
		buildEnvironment: buildEnvironment;
		package: self;
		workingDirectory: folder asFileReference asAbsolute canonicalize;
		yourself
]

{ #category : #accessing }
WBTPackage >> name [
	^ name
]

{ #category : #accessing }
WBTPackage >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WBTPackage >> package [
	^ self
]

{ #category : #'as yet unclassified' }
WBTPackage >> substitutionVariablesEnvironment [
	^ buildEnvironment hostPlatformSubstitutionVariables
]

{ #category : #accessing }
WBTPackage >> targetOutputTargets [
	^ mainElements
]

{ #category : #'as yet unclassified' }
WBTPackage >> validBuildObjectDirectory [
	^ buildObjectDirectory ifNil: [ buildObjectDirectory := buildEnvironment validBuildObjectDirectory / name ]
]

{ #category : #'as yet unclassified' }
WBTPackage >> validBuildOutputDirectory [
	^ buildEnvironment validBuildOutputDirectory
]

{ #category : #'as yet unclassified' }
WBTPackage >> wbtSolveLinkLibrariesInPackage: targetPackage [
	^ self exportedLibraries
]
