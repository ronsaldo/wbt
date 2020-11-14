Class {
	#name : #WBTModuleTarget,
	#superclass : #WBTMainElementTarget,
	#instVars : [
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
		'allObjectFiles',
		'indirectResources',
		'resources',
		'allResources'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #adding }
WBTModuleTarget >> addEnsureOutputDirectoryCreationBuildAction [
	^ self addDirectoryCreationBuildAction: self outputFileReference parent
]

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
WBTModuleTarget >> addIndirectResource: newResource [
	indirectResources add: newResource
]

{ #category : #adding }
WBTModuleTarget >> addIndirectResources: newResources [
	newResources do: [ :each | self addIndirectResource: each ]
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
WBTModuleTarget >> addResource: newResource [
	resources add: newResource
]

{ #category : #adding }
WBTModuleTarget >> addResources: newResources [
	resources do: [ :each | self addResource: each ]
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

{ #category : #'as yet unclassified' }
WBTModuleTarget >> allResources [
	^ allResources ifNil: [allResources := resources , indirectResources ]
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> allResourcesRecursively [
	| result visited |
	result := OrderedCollection new.
	visited := Set new.
	self gatherAllResourceRecursivelyInto: result visited: visited.
	^ result
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
		buildTargetDependencies := sources , intermediateObjectFiles ,
		self allLinkLibraries ,
		self allResources
	]
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> computeIndirectExtraDependenciesForModuleTarget [
	sources do: [ :each | each computeIndirectExtraDependenciesForModuleTarget ].
	intermediateObjectFiles do: [ :each | each computeIndirectExtraDependenciesForModuleTarget ].
]

{ #category : #'as yet unclassified' }
WBTModuleTarget >> gatherAllResourceRecursivelyInto: result visited: visited [
	(visited includes: self) ifTrue: [ ^ self ].
	self allResources do: [ :each |
		(visited includes: each) ifFalse: [
			result add: each.
			visited add: each
		]
	].

	self allLinkLibraries do: [ :each |
		each gatherAllResourceRecursivelyInto: result visited: visited
	]
]

{ #category : #initialization }
WBTModuleTarget >> initialize [
	super initialize.
	sources := OrderedCollection new.
	intermediateObjectFiles := OrderedCollection new.
	resources := OrderedCollection new.
	linkLibrariesFolders := OrderedCollection new.
	linkLibraries := OrderedCollection new.
	linkerArguments := OrderedCollection new.
	indirectLinkLibraries := OrderedCollection new.
	indirectLinkerArguments := OrderedCollection new.
	indirectResources := OrderedCollection new.

]

{ #category : #accessing }
WBTModuleTarget >> intermediateObjectFiles [
	^ intermediateObjectFiles
]

{ #category : #testing }
WBTModuleTarget >> isModuleTarget [
	^ true
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

{ #category : #'as yet unclassified' }
WBTModuleTarget >> wbtSolveMainElementInPackage: targetPackage [
	^ self
]
