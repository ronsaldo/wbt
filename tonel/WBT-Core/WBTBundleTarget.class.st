Class {
	#name : #WBTBundleTarget,
	#superclass : #WBTMainElementTarget,
	#instVars : [
		'program',
		'buildTargetDependencies',
		'bundleType',
		'outputFileReferences'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #adding }
WBTBundleTarget >> addDependency: dependency [
	buildTargetDependencies add: dependency
]

{ #category : #adding }
WBTBundleTarget >> addOutputFileReference: aFileReference [
	outputFileReferences add: aFileReference
]

{ #category : #'as yet unclassified' }
WBTBundleTarget >> buildTargetDependencies [
	^ buildTargetDependencies
]

{ #category : #'as yet unclassified' }
WBTBundleTarget >> bundleType [
	^ bundleType ifNil: [ bundleType := self platform defaultBundleType ]
]

{ #category : #accessing }
WBTBundleTarget >> bundleType: anObject [
	bundleType := anObject
]

{ #category : #initialization }
WBTBundleTarget >> initialize [
	super initialize.
	buildTargetDependencies := OrderedCollection new.
	outputFileReferences := OrderedCollection new.
]

{ #category : #accessing }
WBTBundleTarget >> outputFileReferences [
	^ outputFileReferences
]

{ #category : #accessing }
WBTBundleTarget >> program [
	^ program
]

{ #category : #accessing }
WBTBundleTarget >> program: anObject [
	program := anObject.
]

{ #category : #'as yet unclassified' }
WBTBundleTarget >> selectBuildAction [
	program ifNotNil: [
		self addDependency: (program wbtSolveMainElementInPackage: package)
	].
	self bundleType selectBuildActionsFor: self
]

{ #category : #adding }
WBTBundleTarget >> targetOutputFileReferences [
	^ outputFileReferences
]
