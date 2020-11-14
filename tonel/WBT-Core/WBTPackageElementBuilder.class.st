Class {
	#name : #WBTPackageElementBuilder,
	#superclass : #WBTObject,
	#instVars : [
		'script',
		'target'
	],
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTPackageElementBuilder class >> for: script named: moduleName [
	^ self new initializeForScript: script withTargetName: moduleName; yourself
]

{ #category : #'as yet unclassified' }
WBTPackageElementBuilder >> createTargetNamed: moduleName [
	self subclassResponsibility
]

{ #category : #initialization }
WBTPackageElementBuilder >> finish [
	target selectBuildAction.
	^ target
]

{ #category : #initialization }
WBTPackageElementBuilder >> initializeForScript: theScript withTargetName: theModuleName [
	script := theScript.
	target := self createTargetNamed: theModuleName.
	script package addElement: target.
]

{ #category : #accessing }
WBTPackageElementBuilder >> script [
	^ script
]

{ #category : #accessing }
WBTPackageElementBuilder >> target [
	^ target
]
