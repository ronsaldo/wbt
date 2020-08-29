Class {
	#name : #WBTLibrary,
	#superclass : #WBTPackageElement,
	#instVars : [
		'importLibName',
		'importLibFolder',
		'runtimeBinaryFileReference'
	],
	#category : #'WBT-Core'
}

{ #category : #accessing }
WBTLibrary >> importLibFolder [
	^ importLibFolder
]

{ #category : #accessing }
WBTLibrary >> importLibFolder: anObject [
	importLibFolder := anObject
]

{ #category : #accessing }
WBTLibrary >> importLibName [
	^ importLibName
]

{ #category : #accessing }
WBTLibrary >> importLibName: anObject [
	importLibName := anObject
]

{ #category : #testing }
WBTLibrary >> isExportedLibrary [
	^ true
]

{ #category : #testing }
WBTLibrary >> isLibrary [
	^ true
]

{ #category : #accessing }
WBTLibrary >> runtimeBinaryFileReference [
	^ runtimeBinaryFileReference
]

{ #category : #accessing }
WBTLibrary >> runtimeBinaryFileReference: anObject [
	runtimeBinaryFileReference := anObject
]
