Class {
	#name : #WBTArchitecture,
	#superclass : #Object,
	#instVars : [
		'canonicalName',
		'name',
		'subarchitecture',
		'pointerSize'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #construction }
WBTArchitecture class >> arm [
	^ self new
		name: #arm;
		canonicalName: #arm;
		pointerSize: 4;
		yourself
]

{ #category : #construction }
WBTArchitecture class >> arm64 [
	^ self new
		name: #arm64;
		canonicalName: #arm64;
		pointerSize: 8;
		yourself
]

{ #category : #construction }
WBTArchitecture class >> armv5 [
	^ self arm
		name: #armv5;
		subarchitecture: #v5;
		yourself
]

{ #category : #construction }
WBTArchitecture class >> armv6 [
	^ self arm
		name: #armv6;
		subarchitecture: #v6;
		yourself
]

{ #category : #construction }
WBTArchitecture class >> armv6k [
	^ self arm
		name: #armv6k;
		subarchitecture: #v6k;
		yourself
]

{ #category : #construction }
WBTArchitecture class >> armv6m [
	^ self arm
		name: #armv6m;
		subarchitecture: #v6m;
		yourself
]

{ #category : #construction }
WBTArchitecture class >> armv7 [
	^ self arm
		name: #armv7;
		subarchitecture: #v7;
		yourself
]

{ #category : #construction }
WBTArchitecture class >> armv7a [
	^ self arm
		name: #armv7a;
		subarchitecture: #v7a;
		yourself
]

{ #category : #construction }
WBTArchitecture class >> armv7m [
	^ self arm
		name: #armv7m;
		subarchitecture: #v7m;
		yourself
]

{ #category : #'as yet unclassified' }
WBTArchitecture class >> forCurrentPlatform [
	^ Smalltalk wordSize = 4
		ifTrue: [ self x86 ]
		ifFalse: [ self x64 ]
]

{ #category : #construction }
WBTArchitecture class >> mipsel [
	^ self new
		name: #mipsel;
		canonicalName: #mipsel;
		pointerSize: 4;
		yourself
]

{ #category : #construction }
WBTArchitecture class >> wasm [
	^ self wasm32
]

{ #category : #construction }
WBTArchitecture class >> wasm32 [
	^ self new
		name: #wasm32;
		canonicalName: #wasm32;
		pointerSize: 4;
		yourself
]

{ #category : #construction }
WBTArchitecture class >> wasm64 [
	^ self new
		name: #wasm64;
		canonicalName: #wasm64;
		pointerSize: 8;
		yourself
]

{ #category : #construction }
WBTArchitecture class >> x64 [
	^ self new
		name: #x64;
		canonicalName: #x86_64;
		pointerSize: 8;
		yourself
]

{ #category : #construction }
WBTArchitecture class >> x86 [
	^ self new
		name: #x86;
		canonicalName: #i686;
		pointerSize: 4;
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

{ #category : #testing }
WBTArchitecture >> isAMD64 [
	^ canonicalName = #x86_64
]

{ #category : #testing }
WBTArchitecture >> isARM [
	^ canonicalName = #arm
]

{ #category : #testing }
WBTArchitecture >> isARM32 [
	^ canonicalName = #arm
]

{ #category : #testing }
WBTArchitecture >> isARM64 [
	^ canonicalName = #arm64
]

{ #category : #testing }
WBTArchitecture >> isI686 [
	^ canonicalName = #i686
]

{ #category : #testing }
WBTArchitecture >> isMIPS [
	^ canonicalName beginsWith: #mips
]

{ #category : #testing }
WBTArchitecture >> isMIPSEL [
	^ canonicalName = #mipsel
]

{ #category : #testing }
WBTArchitecture >> isWASM [
	^ canonicalName beginsWith: #wasm
]

{ #category : #testing }
WBTArchitecture >> isWASM32 [
	^ canonicalName = #wasm32
]

{ #category : #testing }
WBTArchitecture >> isWASM64 [
	^ canonicalName = #wasm64
]

{ #category : #testing }
WBTArchitecture >> isWebAssembly [
	^ canonicalName beginsWith: #wasm
]

{ #category : #testing }
WBTArchitecture >> isWebAssembly32 [
	^ canonicalName = #wasm32
]

{ #category : #testing }
WBTArchitecture >> isWebAssembly64 [
	^ canonicalName = #wasm64
]

{ #category : #testing }
WBTArchitecture >> isX64 [
	^ canonicalName = #x86_64
]

{ #category : #testing }
WBTArchitecture >> isX86 [
	^ canonicalName = #i686
]

{ #category : #testing }
WBTArchitecture >> isX86_32 [
	^ canonicalName = #i686
]

{ #category : #testing }
WBTArchitecture >> isX86_64 [
	^ canonicalName = #x86_64
]

{ #category : #accessing }
WBTArchitecture >> name [
	^ name
]

{ #category : #accessing }
WBTArchitecture >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WBTArchitecture >> pointerSize [
	^ pointerSize
]

{ #category : #accessing }
WBTArchitecture >> pointerSize: anObject [
	pointerSize := anObject
]

{ #category : #accessing }
WBTArchitecture >> subarchitecture [
	^ subarchitecture
]

{ #category : #accessing }
WBTArchitecture >> subarchitecture: anObject [
	subarchitecture := anObject
]
