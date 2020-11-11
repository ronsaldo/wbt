Class {
	#name : #WBTBuildEnvironment,
	#superclass : #WBTObject,
	#instVars : [
		'packageSpecLocations',
		'targetPlatform',
		'hostPlatform',
		'buildPlatform',
		'packages',
		'buildObjectDirectory',
		'buildOutputDirectory',
		'languages',
		'buildPlatformVariableEnvironment',
		'hostPlatformVariableEnvironment',
		'targetPlatformVariableEnvironment',
		'buildDirectory',
		'buildCacheDirectory',
		'buildMode',
		'buildResourcesDirectory'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forCurrentPlatform [
	^ self forPlatform: WBTPlatform current
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forCurrentPlatformWithClang [
	^ self forPlatform: WBTPlatform currentWithClang
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forHostPlatform: hostPlatform [
	| currentPlatform |
	currentPlatform := WBTPlatform current.
	^ self new
		buildPlatform: currentPlatform;
		hostPlatform: hostPlatform;
		targetPlatform: hostPlatform;
		yourself
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forLinux [
	^ self forPlatform: WBTPlatform linux
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forLinuxClang [
	^ self forPlatform: WBTPlatform linuxClang
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forLinuxGCC [
	^ self forPlatform: WBTPlatform linuxGCC
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forOSX [
	^ self forPlatform: WBTPlatform osx
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forPlatform: platform [
	^ self new platform: platform; yourself
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forWindowsClangCLX64 [
	^ self forPlatform: WBTPlatform windowsClangCLX64
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forWindowsClangCLX86 [
	^ self forPlatform: WBTPlatform windowsClangCLX86
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forWindowsClangX64 [
	^ self forPlatform: WBTPlatform windowsClangX64
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forWindowsClangX86 [
	^ self forPlatform: WBTPlatform windowsClangX86
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forWindowsX64 [
	^ self forPlatform: WBTPlatform windowsX64
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forWindowsX86 [
	^ self forPlatform: WBTPlatform windowsX86
]

{ #category : #bootstrapping }
WBTBuildEnvironment >> addMainPackageWithBlock: aBlock [
	^ self addPackageNamed: self mainPackageName inFolder: FileSystem workingDirectory withBlock: aBlock
]

{ #category : #bootstrapping }
WBTBuildEnvironment >> addPackageNamed: packageName inFolder: folder withBlock: aBlock [
	| package |
	package := (self getOrCreatePackageNamed: packageName).
	package inFolder: folder evaluateBlock: aBlock.
	^ package
]

{ #category : #bootstrapping }
WBTBuildEnvironment >> addPackageNamed: packageName scriptEnvironmentInFolder: folder [
	^ (self getOrCreatePackageNamed: packageName) makeScriptEnvironmentInFolder: folder
]

{ #category : #bootstrapping }
WBTBuildEnvironment >> addPackageNamed: packageName withBlock: aBlock [
	^ self addPackageNamed: packageName inFolder: FileSystem workingDirectory withBlock: aBlock
]

{ #category : #adding }
WBTBuildEnvironment >> addPackageSpecLocation: location [
	(packageSpecLocations includes: location) ifFalse: [ 
		packageSpecLocations add: location
	]

]

{ #category : #adding }
WBTBuildEnvironment >> addPackageSpecLocations: locations [
	locations do: [:each | self addPackageSpecLocation: each].
	
]

{ #category : #accessing }
WBTBuildEnvironment >> architecture [
	^ self platform architecture
]

{ #category : #accessing }
WBTBuildEnvironment >> buildCacheDirectory: aDirectory [
	buildCacheDirectory := aDirectory asFileReference asAbsolute canonicalize 

]

{ #category : #accessing }
WBTBuildEnvironment >> buildDirectory: aDirectory [
	buildDirectory := aDirectory asFileReference asAbsolute canonicalize 

]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> buildMainPackage [
	^ self buildPackageNamed: self mainPackageName
]

{ #category : #bootstrapping }
WBTBuildEnvironment >> buildMainPackageWithBlock: aBlock [
	^ self buildPackageNamed: self mainPackageName withBlock: aBlock
]

{ #category : #accessing }
WBTBuildEnvironment >> buildMode [
	^ buildMode
]

{ #category : #accessing }
WBTBuildEnvironment >> buildMode: anObject [
	buildMode := anObject
]

{ #category : #accessing }
WBTBuildEnvironment >> buildObjectDirectory: aDirectory [
	buildObjectDirectory := aDirectory asFileReference asAbsolute canonicalize 

]

{ #category : #accessing }
WBTBuildEnvironment >> buildOutputDirectory: aDirectory [
	buildOutputDirectory := aDirectory asFileReference asAbsolute canonicalize 

]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> buildPackageNamed: packageName [
	^ self buildPackagesNamed: { packageName }
]

{ #category : #bootstrapping }
WBTBuildEnvironment >> buildPackageNamed: packageName withBlock: aBlock [
	^ self
		addPackageNamed: packageName withBlock: aBlock;
		buildPackageNamed: packageName
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> buildPackagesNamed: aCollectionOfPackageNames [
	| sorter |
	sorter := WBTBuildTargetDependencySorter new.
	aCollectionOfPackageNames do: [ :each |
		sorter addBuildTarget: (self getOrLoadPackageNamed: each)
	].
	
	^ sorter unsatisfiedBuildTargets allSatisfy: [ :each | each runTargetBuildActions ]
]

{ #category : #accessing }
WBTBuildEnvironment >> buildPlatform [
	^ buildPlatform
]

{ #category : #accessing }
WBTBuildEnvironment >> buildPlatform: anObject [
	buildPlatform := anObject.
	buildPlatform environment: self.
]

{ #category : #accessing }
WBTBuildEnvironment >> buildPlatformVariableEnvironment [
	^ buildPlatformVariableEnvironment ifNil: [ buildPlatformVariableEnvironment := buildPlatform variableEnvironment ]
]

{ #category : #accessing }
WBTBuildEnvironment >> buildResourcesDirectory: aDirectory [
	buildResourcesDirectory := aDirectory asFileReference asAbsolute canonicalize 

]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> devNullRedirection [
	^ Smalltalk os isWindows ifFalse: [ ' > /dev/null' ] ifTrue: [ ' > NUL' ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> executeCommandAndReadStdout: command [
	^ LibC resultOfCommand: command
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> executeCommandLineCommand: command [
	| exitCode |
	exitCode := LibC system: command.
	^ Smalltalk os isWindows
		ifTrue: [ exitCode ]
		ifFalse: [ exitCode >> 8 ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> executeCommandSilently: command [
	^ self executeCommandLineCommand: command , self devNullRedirection
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> getOrCreatePackageNamed: packageName [
	^ packages at: packageName ifAbsentPut: [ WBTPackage new
			name: packageName;
			buildEnvironment: self;
			yourself ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> getOrLoadPackageNamed: packageName [
	^ packages at: packageName ifAbsent: [ self loadPackageNamed: packageName ]
]

{ #category : #accessing }
WBTBuildEnvironment >> hostPlatform [
	^ hostPlatform
]

{ #category : #accessing }
WBTBuildEnvironment >> hostPlatform: anObject [
	hostPlatform := anObject.
	hostPlatform environment: self.
]

{ #category : #accessing }
WBTBuildEnvironment >> hostPlatformVariableEnvironment [
	^ hostPlatformVariableEnvironment ifNil: [ hostPlatformVariableEnvironment := hostPlatform variableEnvironment ]
]

{ #category : #initialization }
WBTBuildEnvironment >> initialize [
	super initialize.
	packages := Dictionary new.
	packageSpecLocations := OrderedCollection new.
	languages := WBTLanguage allSupportedLanguages.
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> installFile: sourceFile in: destFile [
	| sourceFileReference destFileReference |
	sourceFileReference := sourceFile asFileReference.
	destFileReference := destFile asFileReference.
	sourceFileReference exists ifFalse: [ ^ self ].
	destFileReference parent ensureCreateDirectory.
	destFileReference exists ifTrue: [ destFileReference delete ].
	sourceFile copyTo: destFileReference
]

{ #category : #accessing }
WBTBuildEnvironment >> languageForFileExtension: anExtension [
	^ languages detect: [ :each | each handlesFileExtension: anExtension ] ifNone: [ nil ]
]

{ #category : #bootstrapping }
WBTBuildEnvironment >> loadPackageNamed: packageName [
	| package |
	package := nil.
	packageSpecLocations do: [ :each |
		| specScript |
		specScript := each / packageName / 'wbt.st'.
		specScript isFile ifTrue: [
			package ifNil: [ package := self getOrCreatePackageNamed: packageName ].
			package evaluateScriptFromFile: specScript
		]
	].

	^ package
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> mainPackageName [
	^ #Root
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> makeImplicitSourceFileDependencyFor: fileName [
	| relativeFileRef absoluteFileRef extension language |
	absoluteFileRef := relativeFileRef := fileName asFileReference.
	relativeFileRef isAbsolute ifTrue: [ relativeFileRef := relativeFileRef basename asFileReference ].
	
	absoluteFileRef := absoluteFileRef asAbsolute canonicalize.
	extension := absoluteFileRef extension asLowercase.
	language := self validLanguageForFileExtension: extension.

	^ language makeSourceFileElementFor: absoluteFileRef withRelativeFileReference: relativeFileRef
]

{ #category : #accessing }
WBTBuildEnvironment >> platform [
	^ self hostPlatform
]

{ #category : #accessing }
WBTBuildEnvironment >> platform: aPlatform [
	self
		hostPlatform: aPlatform;
		buildPlatform: aPlatform;
		targetPlatform: aPlatform.
]

{ #category : #'build mode' }
WBTBuildEnvironment >> setDebugBuildMode [
	self buildMode: #debug.
]

{ #category : #'build mode' }
WBTBuildEnvironment >> setMinSizeBuildMode [
	self buildMode: #minSize.
]

{ #category : #'build mode' }
WBTBuildEnvironment >> setReleaseBuildMode [
	self buildMode: #release.
]

{ #category : #'build mode' }
WBTBuildEnvironment >> setReleaseWithDebugInfoBuildMode [
	self buildMode: #relWithDebInfo.
]

{ #category : #accessing }
WBTBuildEnvironment >> targetPlatform [
	^ targetPlatform
]

{ #category : #accessing }
WBTBuildEnvironment >> targetPlatform: anObject [
	targetPlatform := anObject.
	targetPlatform environment: self
]

{ #category : #accessing }
WBTBuildEnvironment >> targetPlatformVariableEnvironment [
	^ targetPlatformVariableEnvironment ifNil: [ targetPlatformVariableEnvironment := targetPlatform variableEnvironment ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildCacheDirectory [
	^ buildCacheDirectory ifNil: [ self validBuildDirectory / 'cache' ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildDirectory [
	^ buildDirectory ifNil: [FileSystem workingDirectory]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildObjectDirectory [
	^ buildObjectDirectory ifNil: [ self validBuildDirectory / 'obj' ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildOutputDirectory [
	^ buildOutputDirectory ifNil: [ self validBuildDirectory / 'out' ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildResourcesDirectory [
	^ buildResourcesDirectory ifNil: [ self validBuildOutputDirectory / 'resources' ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validLanguageForFileExtension: extension [
	^ (self languageForFileExtension: extension) ifNil: [ WBTNullLanguage uniqueInstance ].
]
