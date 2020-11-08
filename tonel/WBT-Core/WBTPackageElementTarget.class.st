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

{ #category : #testing }
WBTPackageElementTarget >> isExecutableProgram [
	^ false
]

{ #category : #testing }
WBTPackageElementTarget >> isExportedLibrary [
	^ false
]

{ #category : #testing }
WBTPackageElementTarget >> isLibrary [
	^ false
]

{ #category : #testing }
WBTPackageElementTarget >> isModuleTarget [
	^ false
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
