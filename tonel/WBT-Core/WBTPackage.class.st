Class {
	#name : #WBTPackage,
	#superclass : #WBTBuildTarget,
	#instVars : [
		'name',
		'buildEnvironment',
		'elements',
		'dependencies',
		'buildObjectDirectory',
		'buildOutputDirectory',
		'mainElements',
		'buildTargetDependencies'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #adding }
WBTPackage >> addElement: anElement [
	self assert: anElement package isNil.
	anElement package: self.
	elements add: anElement.
	anElement isModuleTarget ifTrue: [
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
WBTPackage >> buildOutputDirectory: aDirectory [
	buildOutputDirectory := aDirectory asFileReference.
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
	^ buildEnvironment platform toolchain formatLinkerArgumentsForImportingLibraries: self exportedLibraries
]

{ #category : #adding }
WBTPackage >> importLibrary: libraryName [
	self addElement: (WBTLibraryTarget new
		name: name;
		importLibName: libraryName;
		yourself
	).

]

{ #category : #adding }
WBTPackage >> importLibrary: libraryName fromDebianPackage: debianPackageName [
	self importLibrary: libraryName
]

{ #category : #adding }
WBTPackage >> importLibrary: libraryName fromLibFolder: libraryFolderName [
	self addElement: (WBTLibraryTarget new
		name: name;
		importLibName: libraryName;
		importLibFolder: libraryFolderName;
		yourself
	).
]

{ #category : #adding }
WBTPackage >> importLibrary: libraryName fromLibFolder: libraryFolderName binFolder: libraryBinaryFolder [
	self addElement: (WBTLibraryTarget new
		name: name;
		importLibName: libraryName;
		importLibFolder: libraryFolderName;
		binaryLibFolder: libraryBinaryFolder;
		yourself
	).
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
	self importLibrary: libraryName fromLibFolder: parentFolder binFolder: parentFolder
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

{ #category : #initialization }
WBTPackage >> initialize [
	super initialize.
	dependencies := OrderedCollection new.
	elements := OrderedCollection new.
	mainElements := OrderedCollection new.
]

{ #category : #actions }
WBTPackage >> installExportedLibrariesInto: outputDirectory [
	self exportedLibraries do: [ :each | each installInto: outputDirectory ]
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

{ #category : #'instance creation' }
WBTPackage >> newCommandLineCommandBuildAction: command inputFiles: inputFiles outputFile: outputFile [
	^ WBTCommandLineCommandBuildAction new
		command: command;
		variables: (Dictionary newFromPairs: {
			'WBT_INPUT_FILES' . inputFiles .
			'WBT_OUTPUT_FILE' . outputFile .
		});
		parentEnvironment: self substitutionVariablesEnvironment;
		inputFiles: inputFiles;
		outputFiles: { outputFile };
		yourself
]

{ #category : #'as yet unclassified' }
WBTPackage >> substitutionVariablesEnvironment [
	^ buildEnvironment hostPlatformSubstitutionVariables
]

{ #category : #'as yet unclassified' }
WBTPackage >> validBuildObjectDirectory [
	^ buildObjectDirectory ifNil: [ buildObjectDirectory := buildEnvironment validBuildObjectDirectory / name ]
]

{ #category : #'as yet unclassified' }
WBTPackage >> validBuildOutputDirectory [
	^ buildOutputDirectory ifNil: [ buildOutputDirectory := buildEnvironment validBuildOutputDirectory ]
]
