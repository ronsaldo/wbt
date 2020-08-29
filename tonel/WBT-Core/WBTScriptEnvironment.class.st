Class {
	#name : #WBTScriptEnvironment,
	#superclass : #Object,
	#instVars : [
		'package'
	],
	#category : #'WBT-Core'
}

{ #category : #adding }
WBTScriptEnvironment >> addLibrary: libraryName fromDebianPackage: debianPackageName [
	self package addLibrary: libraryName fromDebianPackage: debianPackageName
]

{ #category : #adding }
WBTScriptEnvironment >> addLibrary: libraryName fromFolder: libraryFolderName [
	package addLibrary: libraryName fromFolder: libraryFolderName
]

{ #category : #adding }
WBTScriptEnvironment >> addLibrary: libraryName fromImportFolder: libraryImportFolder binaryFolder: libraryBinaryFolder [
	package addLibrary: libraryName fromImportFolder: libraryImportFolder binaryFolder: libraryBinaryFolder
]

{ #category : #adding }
WBTScriptEnvironment >> addPhanapiBintrayLibrary: libraryName fromUser: bintrayUser repository: repositoryName package: packageName [
	self package addPhanapiBintrayLibrary: libraryName fromUser: bintrayUser repository: repositoryName package: packageName
]

{ #category : #accessing }
WBTScriptEnvironment >> package [
	^ package
]

{ #category : #accessing }
WBTScriptEnvironment >> package: anObject [
	package := anObject
]
