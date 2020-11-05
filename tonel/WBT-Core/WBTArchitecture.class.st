Class {
	#name : #WBTArchitecture,
	#superclass : #Object,
	#instVars : [
		'canonicalName',
		'name'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #construction }
WBTArchitecture class >> x64 [
	^ self new
		name: #x64;
		canonicalName: #x86_64;
		yourself
]

{ #category : #construction }
WBTArchitecture class >> x86 [
	^ self new
		name: #x86;
		canonicalName: #i686;
		yourself
]

{ #category : #accessing }
WBTArchitecture >> canonicalName [
	^ canonicalName
]

{ #category : #accessing }
WBTArchitecture >> canonicalName: anObject [
	canonicalName := anObject
]

{ #category : #accessing }
WBTArchitecture >> name [
	^ name
]

{ #category : #accessing }
WBTArchitecture >> name: anObject [
	name := anObject
]
