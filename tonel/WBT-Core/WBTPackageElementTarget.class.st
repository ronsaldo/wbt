Class {
	#name : #WBTPackageElementTarget,
	#superclass : #WBTBuildTarget,
	#instVars : [
		'package'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #accessing }
WBTPackageElementTarget >> buildEnvironment [
	^ package buildEnvironment
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
