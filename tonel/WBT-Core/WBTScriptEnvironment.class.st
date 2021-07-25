Class {
	#name : #WBTScriptEnvironment,
	#superclass : #Object,
	#instVars : [
		'buildEnvironment',
		'workingDirectory',
		'package'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #accessing }
WBTScriptEnvironment >> architecture [
	^ buildEnvironment architecture
]

{ #category : #accessing }
WBTScriptEnvironment >> buildEnvironment [
	^ buildEnvironment
]

{ #category : #accessing }
WBTScriptEnvironment >> buildEnvironment: anObject [
	buildEnvironment := anObject
]

{ #category : #adding }
WBTScriptEnvironment >> bundle: bundleName with: aBlock [
	| builder |
	builder := WBTBundleBuilder for: self named: bundleName.
	aBlock value: builder.
	^ builder finish
]

{ #category : #adding }
WBTScriptEnvironment >> bundleWithSource: sourceName [
	^ self bundleWithSource: sourceName with: [:bundle | ]
]

{ #category : #adding }
WBTScriptEnvironment >> bundleWithSource: sourceName with: aBlock [
	| program |
	program := self programWithSource: sourceName.
	^ self bundle: sourceName asFileReference basenameWithoutExtension with: [ :bundle |
		bundle program: program.
		aBlock value: bundle
	]
]

{ #category : #adding }
WBTScriptEnvironment >> dynamicLibrary: programName with: aBlock [
	| builder |
	builder := WBTDynamicLibraryBuilder for: self named: programName.
	aBlock value: builder.
	^ builder finish
]

{ #category : #'as yet unclassified' }
WBTScriptEnvironment >> ensureSourceFileExists: sourceFile [
	(workingDirectory resolve: sourceFile asFileReference) exists ifFalse: [
		self error: ('Failed to find source file named: {1}' format: {sourceFile})
	]
]

{ #category : #'as yet unclassified' }
WBTScriptEnvironment >> evaluateScript: scriptSource [
	^ self class compiler receiver: self; evaluate: scriptSource
]

{ #category : #adding }
WBTScriptEnvironment >> externalLibrary: libraryName buildWith: aBlock [
	| builder |
	builder := WBTExternalLibraryBuilder for: self named: libraryName.
	builder fetchParametersFromCacheOrBuildWith: aBlock.
	^ builder module
]

{ #category : #adding }
WBTScriptEnvironment >> guiBundleWithSource: sourceName [
	^ self guiBundleWithSource: sourceName with: [:bundle | ]
]

{ #category : #adding }
WBTScriptEnvironment >> guiBundleWithSource: sourceName with: aBlock [
	| program |
	program := self guiProgramWithSource: sourceName.
	^ self bundle: sourceName asFileReference basenameWithoutExtension with: [ :bundle |
		bundle program: program.
		aBlock value: bundle
	]
]

{ #category : #adding }
WBTScriptEnvironment >> guiProgramWithSource: sourceName [
	^ self guiProgramWithSource: sourceName with: [:prog | ]
]

{ #category : #adding }
WBTScriptEnvironment >> guiProgramWithSource: sourceName with: aBlock [
	^ self program: sourceName asFileReference basenameWithoutExtension with: [ :prog |
		prog
			source: sourceName;
			setForGUI.
		aBlock value: prog
	]
]

{ #category : #adding }
WBTScriptEnvironment >> importLibraries: names fromLibFolder: libraryFolderName [
	names do: [ :each |
		self importLibrary: each fromLibFolder: libraryFolderName
	]
]

{ #category : #adding }
WBTScriptEnvironment >> importLibraries: names fromLibFolder: libraryFolderName binFolder: binaryFolder [
	names do: [ :each |
		self importLibrary: each fromLibFolder: libraryFolderName binFolder: binaryFolder
	]
]

{ #category : #adding }
WBTScriptEnvironment >> importLibrary: libraryName [
	package importLibrary: libraryName
]

{ #category : #adding }
WBTScriptEnvironment >> importLibrary: libraryName fromDebianPackage: debianPackageName [
	self package importLibrary: libraryName fromDebianPackage: debianPackageName
]

{ #category : #adding }
WBTScriptEnvironment >> importLibrary: libraryName fromLibFolder: libraryFolderName [
	package importLibrary: libraryName fromLibFolder: (self solveRelativePath: libraryFolderName)
]

{ #category : #adding }
WBTScriptEnvironment >> importLibrary: libraryName fromLibFolder: libFolder binFolder: binaryFolder [
	package importLibrary: libraryName fromLibFolder: (self solveRelativePath: libFolder) binFolder: (self solveRelativePath: binaryFolder)
]

{ #category : #adding }
WBTScriptEnvironment >> importLibrary: libraryName withFlags: flags [
	package importLibrary: libraryName withFlags: flags
]

{ #category : #adding }
WBTScriptEnvironment >> importPackage: packageName [
	^ package importPackage: packageName
]

{ #category : #adding }
WBTScriptEnvironment >> importPhanapiBintrayLibrary: libraryName fromUser: bintrayUser repository: repositoryName package: packageName [
	| dynlib importLib |
	dynlib := self platform formatDynamicLibraryFileName: libraryName.
	importLib := self platform formatDynamicLibraryImportFileName: libraryName.
	
	{
		workingDirectory .
		workingDirectory / #lib .
	} do: [ :baseLocation |
		((baseLocation / dynlib) isFile and: [ (baseLocation / importLib) isFile ]) ifTrue: [
			^ self importLibrary: baseLocation fromLibFolder: baseLocation binFolder: baseLocation
		].
	].
	
	package importPhanapiBintrayLibrary: libraryName fromUser: bintrayUser repository: repositoryName package: packageName
]

{ #category : #adding }
WBTScriptEnvironment >> includeDirectories: directoriesToInclude [
	directoriesToInclude do: [ :each | self includeDirectory: each ]
]

{ #category : #adding }
WBTScriptEnvironment >> includeDirectory: aDirectoryToInclude [
	package includeDirectory: (workingDirectory resolve: aDirectoryToInclude asFileReference).
]

{ #category : #adding }
WBTScriptEnvironment >> includePublicDirectories: directoriesToInclude [
	directoriesToInclude do: [ :each | self includePublicDirectory: each ]
]

{ #category : #adding }
WBTScriptEnvironment >> library: programName with: aBlock [
	| builder |
	builder := WBTLibraryBuilder for: self named: programName.
	aBlock value: builder.
	^ builder module
]

{ #category : #adding }
WBTScriptEnvironment >> objectLibrary: programName with: aBlock [
	| builder |
	builder := WBTObjectLibraryBuilder for: self named: programName.
	aBlock value: builder.
	^ builder finish
]

{ #category : #accessing }
WBTScriptEnvironment >> package [
	^ package
]

{ #category : #accessing }
WBTScriptEnvironment >> package: anObject [
	package := anObject
]

{ #category : #accessing }
WBTScriptEnvironment >> platform [
	^ buildEnvironment platform
]

{ #category : #adding }
WBTScriptEnvironment >> program: programName with: aBlock [
	| builder |
	builder := WBTProgramBuilder for: self named: programName.
	aBlock value: builder.
	^ builder finish
]

{ #category : #adding }
WBTScriptEnvironment >> programWithSource: sourceName [
	^ self programWithSource: sourceName with: [:prog | ]
]

{ #category : #adding }
WBTScriptEnvironment >> programWithSource: sourceName with: aBlock [
	^ self program: sourceName asFileReference basenameWithoutExtension with: [ :prog |
		prog source: sourceName.
		aBlock value: prog
	]
]

{ #category : #adding }
WBTScriptEnvironment >> resourceLibrary: programName with: aBlock [
	| builder |
	builder := WBTResourceLibraryBuilder for: self named: programName.
	aBlock value: builder.
	^ builder finish
]

{ #category : #adding }
WBTScriptEnvironment >> solveRelativePath: path [
	^ (workingDirectory resolve: path asFileReference) fullName
]

{ #category : #'as yet unclassified' }
WBTScriptEnvironment >> solveSourceFile: fileName [
	| relativeFileRef solvedFileReference extension language |
	solvedFileReference := relativeFileRef := fileName asFileReference.
	relativeFileRef isAbsolute ifTrue: [ relativeFileRef := relativeFileRef basename asFileReference ].
	
	self ensureSourceFileExists: fileName.
	solvedFileReference := (workingDirectory resolve: solvedFileReference) asAbsolute canonicalize.
	extension := solvedFileReference extension asLowercase.
	language := self buildEnvironment validLanguageForFileExtension: extension.

	^ language makeSourceFileElementFor: solvedFileReference withRelativeFileReference: relativeFileRef
]

{ #category : #'as yet unclassified' }
WBTScriptEnvironment >> solveSourceFileOrGlobPattern: fileNameOrGlobPattern [
	^ (fileNameOrGlobPattern includesAnyOf: '*?') ifTrue: [
		self solveSourceGlobPattern: fileNameOrGlobPattern
	] ifFalse: [ 
		{self solveSourceFile: fileNameOrGlobPattern}
	]
]

{ #category : #'as yet unclassified' }
WBTScriptEnvironment >> solveSourceGlobPattern: globPattern [
	self halt
]

{ #category : #adding }
WBTScriptEnvironment >> staticLibrary: programName with: aBlock [
	| builder |
	builder := WBTStaticLibraryBuilder for: self named: programName.
	aBlock value: builder.
	^ builder finish
]

{ #category : #accessing }
WBTScriptEnvironment >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
WBTScriptEnvironment >> workingDirectory: anObject [
	workingDirectory := anObject
]
