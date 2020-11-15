Class {
	#name : #WBTPackageElementTarget,
	#superclass : #WBTBuildTarget,
	#instVars : [
		'package'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #converting }
WBTPackageElementTarget >> asFileReference [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WBTPackageElementTarget >> makeInstallIntoTarget: destFileReference [
	| destFileTarget |
	destFileTarget := WBTFileTarget for: destFileReference.
	destFileTarget
		addDependency: self;
		addBuildAction: (WBTInstallFileBuildAction new
			sourceFileReference: self asFileReference;
			destFileReference: destFileReference;
			yourself).
	^ destFileTarget
]

{ #category : #accessing }
WBTPackageElementTarget >> package [
	^ package
]

{ #category : #accessing }
WBTPackageElementTarget >> package: anObject [
	package := anObject
]

{ #category : #accessing }
WBTPackageElementTarget >> platform [
	^ self buildEnvironment platform
]

{ #category : #accessing }
WBTPackageElementTarget >> toolchain [
	^ self platform toolchain
]
