Class {
	#name : #WBTTouchFileBuildAction,
	#superclass : #WBTBuildAction,
	#instVars : [
		'fileReference'
	],
	#category : #'WBT-Core-Actions'
}

{ #category : #execution }
WBTTouchFileBuildAction >> execute [
	fileReference parent ensureCreateDirectory.
	fileReference ensureDelete.
	fileReference writeStreamDo: [ :out | out truncate ].
	^ true
]

{ #category : #accessing }
WBTTouchFileBuildAction >> fileReference [
	^ fileReference
]

{ #category : #accessing }
WBTTouchFileBuildAction >> fileReference: anObject [
	fileReference := anObject
]
