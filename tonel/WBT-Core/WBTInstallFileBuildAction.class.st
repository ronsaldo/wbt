Class {
	#name : #WBTInstallFileBuildAction,
	#superclass : #WBTBuildAction,
	#instVars : [
		'sourceFileReference',
		'destFileReference',
		'optional'
	],
	#category : #'WBT-Core-Actions'
}

{ #category : #accessing }
WBTInstallFileBuildAction >> destFileReference [
	^ destFileReference
]

{ #category : #accessing }
WBTInstallFileBuildAction >> destFileReference: anObject [
	destFileReference := anObject
]

{ #category : #execution }
WBTInstallFileBuildAction >> execute [
	sourceFileReference exists ifFalse: [ ^ self optional ].
	destFileReference parent ensureCreateDirectory.
	destFileReference exists ifTrue: [ destFileReference delete ].
	sourceFileReference copyTo: destFileReference.
	^ true
]

{ #category : #accessing }
WBTInstallFileBuildAction >> optional [
	^ optional ifNil: [ optional := false ]
]

{ #category : #accessing }
WBTInstallFileBuildAction >> optional: aBoolean [
	optional := aBoolean
]

{ #category : #accessing }
WBTInstallFileBuildAction >> sourceFileReference [
	^ sourceFileReference
]

{ #category : #accessing }
WBTInstallFileBuildAction >> sourceFileReference: anObject [
	sourceFileReference := anObject
]
