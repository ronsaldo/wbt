Class {
	#name : #WBTPlatform,
	#superclass : #Object,
	#instVars : [
		'name',
		'triple',
		'toolchain'
	],
	#category : #'WBT-Core'
}

{ #category : #'as yet unclassified' }
WBTPlatform class >> linux [
	^ self linuxGCC
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> linuxClang [
	^ self new
		name: #linux;
		toolchain: WBTToolChain linuxClang;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> linuxGCC [
	^ self new
		name: #linux;
		toolchain: WBTToolChain linuxGCC;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> osx [
	^ self new
		name: #osx;
		toolchain: WBTToolChain osxClang;
		yourself
]

{ #category : #accessing }
WBTPlatform >> name [
	^ name
]

{ #category : #accessing }
WBTPlatform >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WBTPlatform >> toolchain [
	^ toolchain
]

{ #category : #accessing }
WBTPlatform >> toolchain: anObject [
	toolchain := anObject
]

{ #category : #accessing }
WBTPlatform >> triple [
	^ triple
]

{ #category : #accessing }
WBTPlatform >> triple: anObject [
	triple := anObject
]
