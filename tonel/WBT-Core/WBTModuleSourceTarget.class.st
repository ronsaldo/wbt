Class {
	#name : #WBTModuleSourceTarget,
	#superclass : #WBTPackageElementTarget,
	#category : #'WBT-Core-Targets'
}

{ #category : #adding }
WBTModuleSourceTarget >> addIntermediateObjectFilesToModule: targetModule [
	"By default do nothing"
]

{ #category : #hook }
WBTModuleSourceTarget >> computeIndirectExtraDependenciesForModuleTarget [
	"By default do nothing."
]
