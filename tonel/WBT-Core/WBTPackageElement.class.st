Class {
	#name : #WBTPackageElement,
	#superclass : #Object,
	#category : #'WBT-Core'
}

{ #category : #testing }
WBTPackageElement >> isExportedLibrary [
	^ false
]

{ #category : #testing }
WBTPackageElement >> isLibrary [
	^ false
]
