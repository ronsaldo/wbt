Class {
	#name : #WBTBuildEnvironment,
	#superclass : #Object,
	#instVars : [
		'packageSpecLocations',
		'targetPlatform',
		'hostPlatform',
		'buildPlatform',
		'packages'
	],
	#category : #'WBT-Core'
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

{ #category : #adding }
WBTBuildEnvironment >> addPackageSpecLocations: locations [
	packageSpecLocations addAll: locations
]

{ #category : #accessing }
WBTBuildEnvironment >> buildPlatform [
	^ buildPlatform
]

{ #category : #accessing }
WBTBuildEnvironment >> buildPlatform: anObject [
	buildPlatform := anObject
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
WBTBuildEnvironment >> initialize [
	super initialize.
	packages := Dictionary new.
	packageSpecLocations := OrderedCollection new.
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
