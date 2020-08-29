Class {
	#name : #WBTCommandLineToolChain,
	#superclass : #WBTToolChain,
	#instVars : [
		'importLibraryFolderArgumentPrefix',
		'importLibraryArgumentPrefix',
		'objectFilePrefix',
		'objectFileSuffix',
		'executablePrefix',
		'executableSuffix',
		'staticLibraryPrefix',
		'staticLibrarySuffix',
		'dynamicLibraryPrefix',
		'dynamicLibrarySuffix',
		'dynamicLibraryImportPrefix',
		'dynamicLibraryImportSuffix'
	],
	#category : #'WBT-Core'
}

{ #category : #accessing }
WBTCommandLineToolChain >> dynamicLibraryImportPrefix [
	^ dynamicLibraryImportPrefix
]

{ #category : #accessing }
WBTCommandLineToolChain >> dynamicLibraryImportPrefix: anObject [
	dynamicLibraryImportPrefix := anObject
]

{ #category : #accessing }
WBTCommandLineToolChain >> dynamicLibraryImportSuffix [
	^ dynamicLibraryImportSuffix
]

{ #category : #accessing }
WBTCommandLineToolChain >> dynamicLibraryImportSuffix: anObject [
	dynamicLibraryImportSuffix := anObject
]

{ #category : #accessing }
WBTCommandLineToolChain >> dynamicLibraryPrefix [
	^ dynamicLibraryPrefix
]

{ #category : #accessing }
WBTCommandLineToolChain >> dynamicLibraryPrefix: anObject [
	dynamicLibraryPrefix := anObject
]

{ #category : #accessing }
WBTCommandLineToolChain >> dynamicLibrarySuffix [
	^ dynamicLibrarySuffix
]

{ #category : #accessing }
WBTCommandLineToolChain >> dynamicLibrarySuffix: anObject [
	dynamicLibrarySuffix := anObject
]

{ #category : #accessing }
WBTCommandLineToolChain >> executablePrefix [
	^ executablePrefix
]

{ #category : #accessing }
WBTCommandLineToolChain >> executablePrefix: anObject [
	executablePrefix := anObject
]

{ #category : #accessing }
WBTCommandLineToolChain >> executableSuffix [
	^ executableSuffix
]

{ #category : #accessing }
WBTCommandLineToolChain >> executableSuffix: anObject [
	executableSuffix := anObject
]

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> formatDynamicLibraryFileName: libraryName [
	^ self dynamicLibraryPrefix , libraryName , self dynamicLibrarySuffix
]

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> formatDynamicLibraryImportFileName: libraryName [
	^ self dynamicLibraryImportPrefix , libraryName , self dynamicLibraryImportSuffix
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForImportingLibraries: libraries [
	| result |
	result := OrderedCollection new.
	self formatLinkerArgumentsForImportingLibraries: libraries into: result.
	^ result
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForImportingLibraries: libraries into: out [
	libraries do: [ :each |
		self formatLinkerArgumentsForImportingLibrary: each into: out
	].
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForImportingLibrary: library into: out [
	library importLibFolder ifNotNil: [:folder |
		out add: self importLibraryFolderArgumentPrefix , folder
	].

	library importLibName ifNotNil: [ :lib |
		out add: self importLibraryArgumentPrefix , lib
	].

]

{ #category : #accessing }
WBTCommandLineToolChain >> importLibraryArgumentPrefix [
	^ importLibraryArgumentPrefix
]

{ #category : #accessing }
WBTCommandLineToolChain >> importLibraryArgumentPrefix: anObject [
	importLibraryArgumentPrefix := anObject
]

{ #category : #accessing }
WBTCommandLineToolChain >> importLibraryFolderArgumentPrefix [
	^ importLibraryFolderArgumentPrefix
]

{ #category : #accessing }
WBTCommandLineToolChain >> importLibraryFolderArgumentPrefix: anObject [
	importLibraryFolderArgumentPrefix := anObject
]

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> inferImportLibFromDynamicLibrary: libraryPath [
	| basename libraryPathFileReference |
	libraryPathFileReference := libraryPath asFileReference.
	basename := libraryPathFileReference basename.
	(dynamicLibraryPrefix isNotEmpty and: [basename beginsWith: dynamicLibraryPrefix]) ifTrue: [ 
		basename := basename allButFirst: dynamicLibraryPrefix size
	].
	(dynamicLibrarySuffix isNotEmpty and: [basename endsWith: dynamicLibrarySuffix]) ifTrue: [ 
		basename := basename allButLast: dynamicLibrarySuffix size
	].
	^ libraryPath parent / (dynamicLibraryImportPrefix , basename , dynamicLibraryImportSuffix)
]

{ #category : #testing }
WBTCommandLineToolChain >> isCommandLineToolChain [
	^ true
]

{ #category : #accessing }
WBTCommandLineToolChain >> objectFilePrefix [
	^ objectFilePrefix
]

{ #category : #accessing }
WBTCommandLineToolChain >> objectFilePrefix: anObject [
	objectFilePrefix := anObject
]

{ #category : #accessing }
WBTCommandLineToolChain >> objectFileSuffix [
	^ objectFileSuffix
]

{ #category : #accessing }
WBTCommandLineToolChain >> objectFileSuffix: anObject [
	objectFileSuffix := anObject
]

{ #category : #accessing }
WBTCommandLineToolChain >> staticLibraryPrefix [
	^ staticLibraryPrefix
]

{ #category : #accessing }
WBTCommandLineToolChain >> staticLibraryPrefix: anObject [
	staticLibraryPrefix := anObject
]

{ #category : #accessing }
WBTCommandLineToolChain >> staticLibrarySuffix [
	^ staticLibrarySuffix
]

{ #category : #accessing }
WBTCommandLineToolChain >> staticLibrarySuffix: anObject [
	staticLibrarySuffix := anObject
]
