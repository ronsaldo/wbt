Class {
	#name : #WBTDirectoryCreationBuildAction,
	#superclass : #WBTBuildAction,
	#instVars : [
		'directory'
	],
	#category : #'WBT-Core-Actions'
}

{ #category : #accessing }
WBTDirectoryCreationBuildAction >> directory [
	^ directory
]

{ #category : #accessing }
WBTDirectoryCreationBuildAction >> directory: anObject [
	directory := anObject
]

{ #category : #execution }
WBTDirectoryCreationBuildAction >> execute [
	directory asFileReference ensureCreateDirectory.
	^ true
]
