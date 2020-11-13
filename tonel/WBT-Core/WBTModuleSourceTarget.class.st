Class {
	#name : #WBTModuleSourceTarget,
	#superclass : #WBTPackageElementTarget,
	#category : #'WBT-Core-Targets'
}

{ #category : #adding }
WBTModuleSourceTarget >> addIntermediateObjectFilesToModule: targetModule [
	"By default do nothing"
]

{ #category : #converting }
WBTModuleSourceTarget >> asFileReference [
	self subclassResponsibility
]

{ #category : #hook }
WBTModuleSourceTarget >> computeIndirectExtraDependenciesForModuleTarget [
	"By default do nothing."
]

{ #category : #converting }
WBTModuleSourceTarget >> relativeFileReference [
	self subclassResponsibility
]

{ #category : #accessing }
WBTModuleSourceTarget >> targetOutputFileReferences [
	^ { self asFileReference }
]
