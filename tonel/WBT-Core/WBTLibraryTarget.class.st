Class {
	#name : #WBTLibraryTarget,
	#superclass : #WBTModuleTarget,
	#category : #'WBT-Core-Targets'
}

{ #category : #accessing }
WBTLibraryTarget >> importLibFolder [
	^ self package validBuildOutputDirectory
]

{ #category : #'as yet unclassified' }
WBTLibraryTarget >> importLibName [
	^ name
]

{ #category : #testing }
WBTLibraryTarget >> isExportedLibrary [
	^ true
]

{ #category : #testing }
WBTLibraryTarget >> isLibrary [
	^ true
]

{ #category : #'as yet unclassified' }
WBTLibraryTarget >> wbtSolveLinkLibraryInPackage: targetPackage [
	^ self
]
