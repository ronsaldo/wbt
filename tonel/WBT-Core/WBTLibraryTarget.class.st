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

{ #category : #'as yet unclassified' }
WBTLibraryTarget >> importLinkerFlags [
	^ nil
]

{ #category : #testing }
WBTLibraryTarget >> isExportedLibrary [
	^ true
]

{ #category : #testing }
WBTLibraryTarget >> isLibrary [
	^ true
]

{ #category : #testing }
WBTLibraryTarget >> requiresLocalRPath [
	^ false
]

{ #category : #'as yet unclassified' }
WBTLibraryTarget >> wbtSolveLinkLibrariesInPackage: targetPackage [
	^ {self}
]
