Class {
	#name : #WBTScriptEnvironment,
	#superclass : #Object,
	#instVars : [
		'buildEnvironment',
		'workingDirectory',
		'package'
	],
	#category : #'WBT-Core'
}

{ #category : #accessing }
WBTScriptEnvironment >> buildEnvironment [
	^ buildEnvironment
]

{ #category : #accessing }
WBTScriptEnvironment >> buildEnvironment: anObject [
	buildEnvironment := anObject
]

{ #category : #'as yet unclassified' }
WBTScriptEnvironment >> evaluateScript: scriptSource [
	^ self class compiler receiver: self; evaluate: scriptSource
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
	package importLibrary: libraryName fromLibFolder: libraryFolderName
]

{ #category : #adding }
WBTScriptEnvironment >> importLibrary: libraryName fromLibFolder: libFolder binFolder: binaryFolder [
	package importLibrary: libraryName fromLibFolder: libFolder binFolder: binaryFolder
]

{ #category : #adding }
WBTScriptEnvironment >> importPackage: packageName [
	^ package importPackage: packageName
]

{ #category : #adding }
WBTScriptEnvironment >> importPhanapiBintrayLibrary: libraryName fromUser: bintrayUser repository: repositoryName package: packageName [
	| dynlib importLib |
	dynlib := self platform toolchain formatDynamicLibraryFileName: libraryName.
	importLib := self platform toolchain formatDynamicLibraryImportFileName: libraryName.
	
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

{ #category : #accessing }
WBTScriptEnvironment >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
WBTScriptEnvironment >> workingDirectory: anObject [
	workingDirectory := anObject
]
