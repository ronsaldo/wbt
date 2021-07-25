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
		'buildResourcesDirectory',
		'buildModeDirectory',
		'buildBundleDirectory',
		'buildBundleTempDirectory'
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
WBTBuildEnvironment class >> forCurrentPlatformWithLLD [
	^ self forPlatform: WBTPlatform currentWithLLD
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forEmscripten [
	^ self forPlatform: WBTPlatform emscripten
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
WBTBuildEnvironment class >> forUWPClangX64 [
	^ self forPlatform: WBTPlatform uwpClangCLX64
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forUWPClangX86 [
	^ self forPlatform: WBTPlatform uwpClangCLX86
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forUWPLLDX64 [
	^ self forPlatform: WBTPlatform uwpLLDX64
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forUWPLLDX86 [
	^ self forPlatform: WBTPlatform uwpLLDX86
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forUWPX64 [
	^ self forPlatform: WBTPlatform uwpX64
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forUWPX86 [
	^ self forPlatform: WBTPlatform uwpX86
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forWebAssembly32 [
	^ self forPlatform: WBTPlatform webAssembly32
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

{ #category : #building }
WBTBuildEnvironment >> addMainPackageInFolder: sourceFolder with: aBlock [
	^ self addPackageNamed: self mainPackageName inFolder: sourceFolder with: aBlock
]

{ #category : #building }
WBTBuildEnvironment >> addMainPackageWith: aBlock [
	^ self addPackageNamed: self mainPackageName with: aBlock
]

{ #category : #building }
WBTBuildEnvironment >> addPackageNamed: packageName inFolder: folder with: aBlock [
	| package |
	package := (self getOrCreatePackageNamed: packageName).
	package inFolder: folder evaluateBlock: aBlock.
	^ package
]

{ #category : #building }
WBTBuildEnvironment >> addPackageNamed: packageName scriptEnvironmentInFolder: folder [
	^ (self getOrCreatePackageNamed: packageName) makeScriptEnvironmentInFolder: folder
]

{ #category : #building }
WBTBuildEnvironment >> addPackageNamed: packageName with: aBlock [
	^ self addPackageNamed: packageName inFolder: FileSystem workingDirectory with: aBlock
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

{ #category : #building }
WBTBuildEnvironment >> buildMainPackageInFolder: sourceFolder with: aBlock [
	^ self buildPackageNamed: self mainPackageName inFolder: sourceFolder with: aBlock
]

{ #category : #building }
WBTBuildEnvironment >> buildMainPackageWith: aBlock [
	^ self buildPackageNamed: self mainPackageName with: aBlock
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

{ #category : #building }
WBTBuildEnvironment >> buildPackageNamed: packageName inFolder: sourceFolder with: aBlock [
	^ self
		addPackageNamed: packageName inFolder: sourceFolder with: aBlock;
		buildPackageNamed: packageName
]

{ #category : #building }
WBTBuildEnvironment >> buildPackageNamed: packageName with: aBlock [
	^ self
		addPackageNamed: packageName with: aBlock;
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
WBTBuildEnvironment >> configurationFileTargetFor: fileName withContent: content [
	| fileReference |
	fileReference := fileName asFileReference.
	(fileReference exists not or: [ fileReference contents ~= content ]) ifTrue: [
		fileReference parent ensureCreateDirectory.
		fileReference writeStreamDo: [ :out |
			out truncate; nextPutAll: content
		]
	].

	^ self makeFileTargetFor: fileReference
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
	Stdio stdout nextPutAll: command; lf.
	exitCode := LibC system: command.
	^ Smalltalk os isWindows
		ifTrue: [ exitCode ]
		ifFalse: [ exitCode >> 8 ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> executeCommandLineCommand: command inDirectory: directory [
	| formattedCommand |
	formattedCommand := 'cd ' , directory asWBTVarSubstitution asWBTEscapedVarSubstitution , ' && ' , command.
	^ self executeCommandLineCommand: formattedCommand
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> executeCommandSilently: command [
	^ self executeCommandLineCommand: command , self devNullRedirection
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> generateTargetFile: fileName inputFiles: inputFiles withCommand: compilationCommand [
	^ self generateTargetFile: fileName inputFiles: inputFiles withCommand: compilationCommand variables: #()
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> generateTargetFile: fileName inputFiles: inputFiles withCommand: compilationCommand variables: variables [
	| targetFile |
	targetFile := self makeFileTargetFor: fileName.
	^ targetFile
		addDependencies: inputFiles;
		addBuildAction: (self newCommandLineCommandBuildAction: compilationCommand inputFiles: inputFiles outputFile: targetFile variables: variables);
		yourself
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

{ #category : #testing }
WBTBuildEnvironment >> hasBuildModeWithDebugInformation [
	^ #(debug assert minsize relwithdebinfo) includes: self buildMode asLowercase
]

{ #category : #testing }
WBTBuildEnvironment >> hasMinimalSizeBuildMode [
	^ #(minsize) includes: self buildMode asLowercase
]

{ #category : #testing }
WBTBuildEnvironment >> hasReleaseBuildMode [
	^ #(minsize relwithdebinfo release) includes: self buildMode asLowercase
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
	self setDebugBuildMode.
]

{ #category : #accessing }
WBTBuildEnvironment >> languageForFileExtension: anExtension [
	^ languages detect: [ :each | each handlesFileExtension: anExtension ] ifNone: [ nil ]
]

{ #category : #private }
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
WBTBuildEnvironment >> makeFileTargetFor: fileName [
	| relativeFileRef absoluteFileRef extension language |
	absoluteFileRef := relativeFileRef := fileName asFileReference.
	relativeFileRef isAbsolute ifTrue: [ relativeFileRef := relativeFileRef basename asFileReference ].
	
	absoluteFileRef := absoluteFileRef asAbsolute canonicalize.
	extension := absoluteFileRef extension asLowercase.
	language := self validLanguageForFileExtension: extension.

	^ language makeSourceFileElementFor: absoluteFileRef withRelativeFileReference: relativeFileRef
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> makeOutputInstallFileTargetFrom: sourceFile into: destFile [
	| sourceFileReference destFileReference sourceFileTarget |
	sourceFileReference := sourceFile asFileReference.
	destFileReference := destFile asFileReference.
	
	sourceFileTarget := WBTFileTarget for: sourceFileReference.
	^ sourceFileTarget makeInstallIntoTarget: destFileReference
]

{ #category : #'instance creation' }
WBTBuildEnvironment >> newCommandLineCommandBuildAction: command inputFiles: inputFiles outputFile: outputFile variables: variables [
	^ self newCommandLineCommandBuildAction: command inputFiles: inputFiles outputFile: outputFile variables: variables parentEnvironment: self hostPlatformVariableEnvironment
]

{ #category : #'instance creation' }
WBTBuildEnvironment >> newCommandLineCommandBuildAction: command inputFiles: inputFiles outputFile: outputFile variables: variables parentEnvironment: parentEnvironment [
	^ WBTCommandLineCommandBuildAction new
		command: command;
		variableEnvironment: (WBTVariableSubstitutionEnvironment parent: parentEnvironment withVariables: variables , {
			'WBT_INPUT_FILES' . inputFiles .
			'WBT_OUTPUT_FILE' . outputFile .
		});
		inputFiles: inputFiles;
		outputFiles: { outputFile };
		yourself
]

{ #category : #'instance creation' }
WBTBuildEnvironment >> newCommandLineCommandBuildAction: command inputFiles: inputFiles outputFile: outputFile variables: variables parentEnvironment: parentEnvironment workingDirectory: workingDirectory [
	^ WBTCommandLineCommandBuildAction new
		command: command;
		variableEnvironment: (WBTVariableSubstitutionEnvironment parent: parentEnvironment withVariables: variables , {
			'WBT_INPUT_FILES' . inputFiles .
			'WBT_OUTPUT_FILE' . outputFile .
		});
		inputFiles: inputFiles;
		outputFiles: { outputFile };
		workingDirectory: workingDirectory;
		yourself
]

{ #category : #'instance creation' }
WBTBuildEnvironment >> newCommandLineCommandBuildAction: command inputFiles: inputFiles outputFile: outputFile variables: variables workingDirectory: workingDirectory [
	^ self newCommandLineCommandBuildAction: command inputFiles: inputFiles outputFile: outputFile variables: variables parentEnvironment: self hostPlatformVariableEnvironment workingDirectory: workingDirectory
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
WBTBuildEnvironment >> setAssertBuildMode [
	self buildMode: #assert
]

{ #category : #'build mode' }
WBTBuildEnvironment >> setDebugBuildMode [
	self buildMode: #debug
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

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> substitute: string variables: extraSubstitutionVariables [
	| variableEnvironment |
	variableEnvironment := (WBTVariableSubstitutionEnvironment parent: self hostPlatformVariableEnvironment)
		setVariables: extraSubstitutionVariables;
		yourself.

	^ (string wbtSubstituteVariablesWith: [ :varName |
		variableEnvironment substitutionForVariable: varName
	]) withUnixLineEndings
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> substituteAndExecuteCommandLineCommand: command inDirectory: workingDirectory variables: extraSubstitutionVariables [
	| formattedCommand |
	formattedCommand := (self substitute: command variables: extraSubstitutionVariables) copyReplaceAll: String lf with: String space.
	self assert: formattedCommand isNotEmpty.
	^ self executeCommandLineCommand: formattedCommand inDirectory: workingDirectory
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
WBTBuildEnvironment >> validBuildBundleDirectory [
	^ buildBundleDirectory ifNil: [ self validBuildModeDirectory / 'bundle' ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildBundleTempDirectory [
	^ buildBundleTempDirectory ifNil: [ self validBuildModeDirectory / 'bundle-temp' ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildCacheDirectory [
	^ buildCacheDirectory ifNil: [ self validBuildModeDirectory / 'cache' ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildDirectory [
	^ buildDirectory ifNil: [FileSystem workingDirectory]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildModeDirectory [
	^ buildModeDirectory ifNil: [buildModeDirectory := self validBuildDirectory / self buildMode ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildObjectDirectory [
	^ buildObjectDirectory ifNil: [ self validBuildModeDirectory / 'obj' ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildOutputDirectory [
	^ buildOutputDirectory ifNil: [ self validBuildModeDirectory / 'out' ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildResourcesDirectory [
	^ buildResourcesDirectory ifNil: [ self validBuildOutputDirectory / 'resources' ]
]

{ #category : #accessing }
WBTBuildEnvironment >> validExternalDependencyCacheDirectory [
	^ self validBuildCacheDirectory / 'external-deps'
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validLanguageForFileExtension: extension [
	^ (self languageForFileExtension: extension) ifNil: [ WBTNullLanguage uniqueInstance ].
]
