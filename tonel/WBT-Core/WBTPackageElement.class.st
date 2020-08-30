Class {
	#name : #WBTPackageElement,
	#superclass : #Object,
	#instVars : [
		'package'
	],
	#category : #'WBT-Core'
}

{ #category : #accessing }
WBTPackageElement >> buildEnvironment [
	^ package buildEnvironment
]

{ #category : #testing }
WBTPackageElement >> isExportedLibrary [
	^ false
]

{ #category : #testing }
WBTPackageElement >> isLibrary [
	^ false
]

{ #category : #accessing }
WBTPackageElement >> package [
	^ package
]

{ #category : #accessing }
WBTPackageElement >> package: anObject [
	package := anObject
]

{ #category : #accessing }
WBTPackageElement >> platform [
	^ self buildEnvironment platform
]

{ #category : #accessing }
WBTPackageElement >> toolchain [
	^ self platform toolchain
]
