Class {
	#name : #WBTPackage,
	#superclass : #Object,
	#instVars : [
		'exportedLibraries'
	],
	#category : #'WBT-Core'
}

{ #category : #adding }
WBTPackage >> addLibrary: libraryName fromDebianPackage: debianPackageName [
	exportedLibraries add: libraryName
]

{ #category : #adding }
WBTPackage >> addLibrary: libraryName fromFolder: libraryFolderName [
	exportedLibraries add: libraryName.
]

{ #category : #adding }
WBTPackage >> addLibrary: libraryName fromImportFolder: libraryImportFolder binaryFolder: libraryBinaryFolder [
	exportedLibraries add: libraryName.
]

{ #category : #adding }
WBTPackage >> addPhanapiBintrayLibrary: libraryName fromUser: bintrayUser repository: repositoryName package: packageName [
	exportedLibraries add: libraryName
]

{ #category : #accessing }
WBTPackage >> exportedLibraries [
	^ exportedLibraries
]

{ #category : #initialization }
WBTPackage >> initialize [
	super initialize.
	exportedLibraries := OrderedCollection new.
]
