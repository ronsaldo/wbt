Class {
	#name : #WBTModuleTarget,
	#superclass : #WBTPackageElementTarget,
	#instVars : [
		'name',
		'sources',
		'intermediateObjectFiles',
		'linkLibrariesFolders',
		'linkLibraries',
		'linkerLanguage',
		'outputFileReference',
		'buildTargetDependencies',
		'indirectLinkLibraries',
		'linkerArguments',
		'indirectLinkerArguments',
		'allLinkerArguments',
		'allLinkLibraries',
		'allObjectFiles'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #adding }
WBTModuleTarget >> addIndirectLinkLibraries: libraries [
	libraries do: [ :each | self addIndirectLinkLibrary: each ]
]

{ #category : #adding }
WBTModuleTarget >> addIndirectLinkLibrary: importLibraryName [
	self assert: allLinkLibraries isNil.
	indirectLinkLibraries addAll: (importLibraryName wbtSolveLinkLibrariesInPackage: package)
]

{ #category : #adding }
WBTModuleTarget >> addIndirectLinkerArgument: argument [
	self assert: allLinkerArguments isNil.
	indirectLinkerArguments add: argument
]

{ #category : #adding }
WBTModuleTarget >> addIndirectLinkerArguments: arguments [
	self assert: allLinkerArguments isNil.
	indirectLinkerArguments addAll: arguments
]

{ #category : #adding }
WBTModuleTarget >> addIntermediateObjectFile: aSourceFile [
	self package addElement: aSourceFile.
	intermediateObjectFiles add: aSourceFile.
	aSourceFile addIntermediateObjectFilesToModule: self.
	^ aSourceFile
]

{ #category : #adding }
WBTModuleTarget >> addIntermediateObjectFiles: aCollectionOfIntermediateObjectFiles [
	aCollectionOfIntermediateObjectFiles do: [ :each | self addIntermediateObjectFile: each ].
]

{ #category : #adding }
WBTModuleTarget >> addLinkLibraries: libraries [
	libraries do: [ :each | self addLinkLibrary: each ]
]

{ #category : #adding }
WBTModuleTarget >> addLinkLibrary: importLibraryName [
	self assert: allLinkLibraries isNil.
	linkLibraries addAll: (importLibraryName wbtSolveLinkLibrariesInPackage: package)
]

{ #category : #adding }
WBTModuleTarget >> addLinkLibraryFolder: importLibraryFolder [
	linkLibrariesFolders add: importLibraryFolder
]

{ #category : #adding }
WBTModuleTarget >> addLinkerArgument: argument [
	self assert: allLinkerArguments isNil.
	linkerArguments add: argument
]

{ #category : #adding }
WBTModuleTarget >> addLinkerArguments: arguments [
	self assert: allLinkerArguments isNil.
	linkerArguments addAll: arguments
]

{ #category : #adding }
WBTModuleTarget >> addSource: aSourceFile [
	self package addElement: aSourceFile.
	sources add: aSourceFile.
	aSourceFile addIntermediateObjectFilesToModule: self.
]

{ #category : #adding }
WBTModuleTarget >> addSources: aCollectionOfSources [
	aCollectionOfSources do: [ :each | self addSource: each ].
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> allLinkLibraries [
	^ allLinkLibraries ifNil: [allLinkLibraries := linkLibraries , indirectLinkLibraries ]
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> allLinkLibrariesDirectories [
	^ linkLibrariesFolders
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> allLinkerArguments [
	^ allLinkerArguments ifNil: [allLinkerArguments := linkerArguments , indirectLinkerArguments ]
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> allObjectFiles [
	^ allObjectFiles ifNil: [allObjectFiles := self buildTargetDependencies select: [ :each | each isObjectFile ] ]
]

{ #category : #converting }
WBTModuleTarget >> asFileReference [
	^ outputFileReference
]

{ #category : #converting }
WBTModuleTarget >> asWBTVarSubstitution [
	self assert: outputFileReference isNotNil.
	^ outputFileReference asWBTVarSubstitution
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> buildTargetDependencies [
	^ buildTargetDependencies ifNil: [
		self computeIndirectExtraDependenciesForModuleTarget.
		buildTargetDependencies := sources , intermediateObjectFiles , (self allLinkLibraries reject: [:each | each isImportedLibrary])
	]
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> computeIndirectExtraDependenciesForModuleTarget [
	sources do: [ :each | each computeIndirectExtraDependenciesForModuleTarget ].
	intermediateObjectFiles do: [ :each | each computeIndirectExtraDependenciesForModuleTarget ].
]

{ #category : #initialization }
WBTModuleTarget >> initialize [
	super initialize.
	sources := OrderedCollection new.
	intermediateObjectFiles := OrderedCollection new.
	linkLibrariesFolders := OrderedCollection new.
	linkLibraries := OrderedCollection new.
	linkerArguments := OrderedCollection new.
	indirectLinkLibraries := OrderedCollection new.
	indirectLinkerArguments := OrderedCollection new.

]

{ #category : #accessing }
WBTModuleTarget >> intermediateObjectFiles [
	^ intermediateObjectFiles
]

{ #category : #testing }
WBTModuleTarget >> isModuleTarget [
	^ true
]

{ #category : #accessing }
WBTModuleTarget >> name [
	^ name
]

{ #category : #accessing }
WBTModuleTarget >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> outputFileName [
	self subclassResponsibility
]

{ #category : #accessing }
WBTModuleTarget >> outputFileReference [
	^ outputFileReference ifNil: [ outputFileReference := self package validBuildOutputDirectory / self outputFileName ]
]

{ #category : #accessing }
WBTModuleTarget >> outputFileReference: anObject [
	outputFileReference := anObject
]

{ #category : #testing }
WBTModuleTarget >> requiresPositionIndependentCode [
	^ false
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> selectBuildAction [
	self subclassResponsibility
]

{ #category : #accessing }
WBTModuleTarget >> sources [
	^ sources
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> sysmelModuleTarget [
	^ self propertyAt: #sysmelModuleTarget ifAbsentPut: [
		self addIntermediateObjectFile: (MbndWBTSysmelModuleTarget new wbtModule: self).
	]
]

{ #category : #accessing }
WBTModuleTarget >> targetOutputFileReferences [
	^ self asFileReference ifNil: [#()] ifNotNil: [:fr | { fr }]
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> validLinkerLanguage [
	linkerLanguage ifNotNil: [ ^ linkerLanguage ].

	linkerLanguage := WBTNullLanguage uniqueInstance.
	sources do: [ :each |
		each language linkPriority > linkerLanguage linkPriority ifTrue: [
			linkerLanguage := each language.
		]
	].

	^ linkerLanguage
]
