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
WBTBundleBuilder >> program [
	^ target program
]

{ #category : #'as yet unclassified' }
WBTBundleBuilder >> program: program [
	target program: program
]

{ #category : #initialization }
WBTBundleBuilder >> setForGUI [
	target program win32Subsystem: #WINDOWS
]

{ #category : #'as yet unclassified' }
WBTBundleBuilder >> source: source [
	^ self program: (script program: target name with: [:prog |
		prog source: source
	])
]

{ #category : #'as yet unclassified' }
WBTBundleBuilder >> sources: sources [
	^ self program: (script program: target name with: [:prog |
		prog sources: sources
	])
]
