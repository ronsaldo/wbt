Class {
	#name : #WBTPackage,
	#superclass : #WBTBuildElement,
	#instVars : [
		'name',
		'buildEnvironment',
		'elements',
		'dependencies',
		'buildObjectDirectory',
		'buildOutputDirectory'
	],
	#category : #'WBT-Core'
}

{ #category : #adding }
WBTPackage >> addElement: anElement [
	elements add: anElement.
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
	^ elements select: [ :each | each isExportedLibrary ]
]

{ #category : #accessing }
WBTPackage >> exportedLibrariesLinkerArguments [
	^ buildEnvironment platform toolchain formatLinkerArgumentsForImportingLibraries: self exportedLibraries
]

{ #category : #adding }
WBTPackage >> importLibrary: libraryName [
	self addElement: (WBTLibrary new
		package: self;
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
	self addElement: (WBTLibrary new
		package: self;
		importLibName: libraryName;
		importLibFolder: libraryFolderName;
		yourself
	).
]

{ #category : #adding }
WBTPackage >> importLibrary: libraryName fromLibFolder: libraryFolderName binFolder: libraryBinaryFolder [
	self addElement: (WBTLibrary new
		package: self;
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
]

{ #category : #actions }
WBTPackage >> installExportedLibrariesInto: outputDirectory [
	self exportedLibraries do: [ :each | each installInto: outputDirectory ]
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

{ #category : #'as yet unclassified' }
WBTPackage >> validBuildObjectDirectory [
	^ buildObjectDirectory ifNil: [ buildObjectDirectory := buildEnvironment validBuildObjectDirectory / name ]
]

{ #category : #'as yet unclassified' }
WBTPackage >> validBuildOutputDirectory [
	^ buildOutputDirectory ifNil: [ buildOutputDirectory := buildEnvironment validBuildOutputDirectory ]
]
