Class {
	#name : #WBTBuildEnvironment,
	#superclass : #Object,
	#instVars : [
		'packageSpecLocations',
		'targetPlatform',
		'hostPlatform',
		'buildPlatform',
		'packages',
		'buildObjectDirectory',
		'buildOutputDirectory',
		'languages',
		'buildPlatformSubstitutionVariables',
		'hostPlatformSubstitutionVariables',
		'targetPlatformSubstitutionVariables'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #'as yet unclassified' }
WBTBuildEnvironment class >> forCurrentPlatform [
	^ self forPlatform: Smalltalk os current wbtPlatform
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

{ #category : #adding }
WBTBuildEnvironment >> addPackageSpecLocations: locations [
	packageSpecLocations addAll: locations
]

{ #category : #accessing }
WBTBuildEnvironment >> architecture [
	^ self platform architecture
]

{ #category : #accessing }
WBTBuildEnvironment >> buildObjectDirectory: aDirectory [
	buildObjectDirectory := aDirectory asFileReference
]

{ #category : #accessing }
WBTBuildEnvironment >> buildOutputDirectory: aDirectory [
	buildOutputDirectory := aDirectory asFileReference
]

{ #category : #bootstrapping }
WBTBuildEnvironment >> buildPackageNamed: packageName inFolder: folder withBlock: aBlock [
	| package |
	package := (self getOrCreatePackageNamed: packageName).
	package inFolder: folder evaluateBlock: aBlock.
	^ package
]

{ #category : #bootstrapping }
WBTBuildEnvironment >> buildPackageNamed: packageName scriptEnvironmentInFolder: folder [
	^ (self getOrCreatePackageNamed: packageName) makeScriptEnvironmentInFolder: folder
]

{ #category : #accessing }
WBTBuildEnvironment >> buildPlatform [
	^ buildPlatform
]

{ #category : #accessing }
WBTBuildEnvironment >> buildPlatform: anObject [
	buildPlatform := anObject
]

{ #category : #initialization }
WBTBuildEnvironment >> buildPlatformSubstitutionVariables [
	^ buildPlatformSubstitutionVariables ifNil: [ buildPlatformSubstitutionVariables := Dictionary newFromPairs: buildPlatform substitutionVariables ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> executeBuildCommandLineCommand: command [
	^ (LibC system: command) = 0
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> executeCommandAndReadStdout: command [
	^ LibC resultOfCommand: command
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> getOrCreatePackageNamed: packageName [
	^ packages at: packageName ifAbsentPut: [ WBTPackage new
			name: packageName;
			buildEnvironment: self;
			yourself ]
]

{ #category : #accessing }
WBTBuildEnvironment >> hostPlatform [
	^ hostPlatform
]

{ #category : #accessing }
WBTBuildEnvironment >> hostPlatform: anObject [
	hostPlatform := anObject
]

{ #category : #initialization }
WBTBuildEnvironment >> hostPlatformSubstitutionVariables [
	^ hostPlatformSubstitutionVariables ifNil: [ hostPlatformSubstitutionVariables := Dictionary newFromPairs: hostPlatform substitutionVariables ]
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

{ #category : #accessing }
WBTBuildEnvironment >> targetPlatform [
	^ targetPlatform
]

{ #category : #accessing }
WBTBuildEnvironment >> targetPlatform: anObject [
	targetPlatform := anObject
]

{ #category : #initialization }
WBTBuildEnvironment >> targetPlatformSubstitutionVariables [
	^ targetPlatformSubstitutionVariables ifNil: [ targetPlatformSubstitutionVariables := Dictionary newFromPairs: buildPlatform substitutionVariables ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildObjectDirectory [
	^ buildObjectDirectory ifNil: [ FileSystem workingDirectory / 'obj' ]
]

{ #category : #'as yet unclassified' }
WBTBuildEnvironment >> validBuildOutputDirectory [
	^ buildOutputDirectory ifNil: [ FileSystem workingDirectory / 'out' ]
]
