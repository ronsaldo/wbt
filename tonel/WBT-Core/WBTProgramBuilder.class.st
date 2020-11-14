Class {
	#name : #WBTProgramBuilder,
	#superclass : #WBTModuleBuilder,
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTProgramBuilder >> createTargetNamed: moduleName [
	^ WBTExecutableProgramTarget new
		name: moduleName;
		yourself
]
