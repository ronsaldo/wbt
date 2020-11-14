Class {
	#name : #WBTBundleBuilder,
	#superclass : #WBTPackageElementBuilder,
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTBundleBuilder >> bundle [
	^ target
]

{ #category : #'as yet unclassified' }
WBTBundleBuilder >> createTargetNamed: targetName [
	^ WBTBundleTarget new
		name: targetName;
		yourself
]

{ #category : #'as yet unclassified' }
WBTBundleBuilder >> program: program [
	target program: program
]
