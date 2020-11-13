"
A WBTArchitectureTest is a test class for testing the behavior of WBTArchitecture
"
Class {
	#name : #WBTArchitectureTest,
	#superclass : #TestCase,
	#category : #'WBT-Core-Tests'
}

{ #category : #tests }
WBTArchitectureTest >> testArm [
	| architecture |
	architecture := WBTArchitecture arm.
	self assert: architecture isARM.
	self assert: architecture isARM32.
	self assert: architecture name equals: #arm.
	self assert: architecture canonicalName equals: #arm.
	self assert: architecture subarchitecture isNil.
	self assert: architecture pointerSize equals: 4.
]

{ #category : #tests }
WBTArchitectureTest >> testArm64 [
	| architecture |
	architecture := WBTArchitecture arm64.
	self assert: architecture isARM64.
	self assert: architecture name equals: #arm64.
	self assert: architecture canonicalName equals: #arm64.
	self assert: architecture subarchitecture isNil.
	self assert: architecture pointerSize equals: 8.
]

{ #category : #tests }
WBTArchitectureTest >> testArmv5 [
	| architecture |
	architecture := WBTArchitecture armv5.
	self assert: architecture isARM.
	self assert: architecture isARM32.
	self assert: architecture name equals: #armv5.
	self assert: architecture canonicalName equals: #arm.
	self assert: architecture subarchitecture equals: #v5.
	self assert: architecture pointerSize equals: 4.
]

{ #category : #tests }
WBTArchitectureTest >> testArmv6 [
	| architecture |
	architecture := WBTArchitecture armv6.
	self assert: architecture isARM.
	self assert: architecture isARM32.
	self assert: architecture name equals: #armv6.
	self assert: architecture canonicalName equals: #arm.
	self assert: architecture subarchitecture equals: #v6.
	self assert: architecture pointerSize equals: 4.
]

{ #category : #tests }
WBTArchitectureTest >> testArmv6k [
	| architecture |
	architecture := WBTArchitecture armv6k.
	self assert: architecture isARM.
	self assert: architecture isARM32.
	self assert: architecture name equals: #armv6k.
	self assert: architecture canonicalName equals: #arm.
	self assert: architecture subarchitecture equals: #v6k.
	self assert: architecture pointerSize equals: 4.
]

{ #category : #tests }
WBTArchitectureTest >> testArmv6m [
	| architecture |
	architecture := WBTArchitecture armv6m.
	self assert: architecture isARM.
	self assert: architecture isARM32.
	self assert: architecture name equals: #armv6m.
	self assert: architecture canonicalName equals: #arm.
	self assert: architecture subarchitecture equals: #v6m.
	self assert: architecture pointerSize equals: 4.
]

{ #category : #tests }
WBTArchitectureTest >> testArmv7 [
	| architecture |
	architecture := WBTArchitecture armv7.
	self assert: architecture isARM.
	self assert: architecture isARM32.
	self assert: architecture name equals: #armv7.
	self assert: architecture canonicalName equals: #arm.
	self assert: architecture subarchitecture equals: #v7.
	self assert: architecture pointerSize equals: 4.
]

{ #category : #tests }
WBTArchitectureTest >> testArmv7a [
	| architecture |
	architecture := WBTArchitecture armv7a.
	self assert: architecture isARM.
	self assert: architecture isARM32.
	self assert: architecture name equals: #armv7a.
	self assert: architecture canonicalName equals: #arm.
	self assert: architecture subarchitecture equals: #v7a.
	self assert: architecture pointerSize equals: 4.
]

{ #category : #tests }
WBTArchitectureTest >> testArmv7m [
	| architecture |
	architecture := WBTArchitecture armv7m.
	self assert: architecture isARM.
	self assert: architecture isARM32.
	self assert: architecture name equals: #armv7m.
	self assert: architecture canonicalName equals: #arm.
	self assert: architecture subarchitecture equals: #v7m.
	self assert: architecture pointerSize equals: 4.
]

{ #category : #tests }
WBTArchitectureTest >> testMipsel [
	| architecture |
	architecture := WBTArchitecture mipsel.
	self assert: architecture isMIPS.
	self assert: architecture isMIPSEL.
	self assert: architecture name equals: #mipsel.
	self assert: architecture canonicalName equals: #mipsel.
	self assert: architecture subarchitecture isNil.
	self assert: architecture pointerSize equals: 4.
]

{ #category : #tests }
WBTArchitectureTest >> testWAsm [
	| architecture |
	architecture := WBTArchitecture wasm.
	self assert: architecture isWASM.
	self assert: architecture isWebAssembly.
	self assert: (architecture name beginsWith: #wasm).
	self assert: (architecture canonicalName beginsWith: #wasm).
	self assert: architecture subarchitecture isNil.

]

{ #category : #tests }
WBTArchitectureTest >> testWAsm32 [
	| architecture |
	architecture := WBTArchitecture wasm32.
	self assert: architecture isWASM.
	self assert: architecture isWASM32.
	self assert: architecture isWebAssembly.
	self assert: architecture isWebAssembly32.
	self assert: architecture name equals: #wasm32.
	self assert: architecture canonicalName equals: #wasm32.
	self assert: architecture subarchitecture isNil.
	self assert: architecture pointerSize equals: 4.
]

{ #category : #tests }
WBTArchitectureTest >> testWAsm64 [
	| architecture |
	architecture := WBTArchitecture wasm64.
	self assert: architecture isWASM.
	self assert: architecture isWASM64.
	self assert: architecture isWebAssembly.
	self assert: architecture isWebAssembly64.
	self assert: architecture name equals: #wasm64.
	self assert: architecture canonicalName equals: #wasm64.
	self assert: architecture subarchitecture isNil.
	self assert: architecture pointerSize equals: 8.
]

{ #category : #tests }
WBTArchitectureTest >> testX64 [
	| architecture |
	architecture := WBTArchitecture x64.
	self assert: architecture isX86_64.
	self assert: architecture isX64.
	self assert: architecture isAMD64.
	self assert: architecture name equals: #x64.
	self assert: architecture canonicalName equals: #x86_64.
	self assert: architecture subarchitecture isNil.
	self assert: architecture pointerSize equals: 8.
]

{ #category : #tests }
WBTArchitectureTest >> testX86 [
	| architecture |
	architecture := WBTArchitecture x86.
	self assert: architecture isX86.
	self assert: architecture isX86_32.
	self assert: architecture isI686.
	self assert: architecture name equals: #x86.
	self assert: architecture canonicalName equals: #i686.
	self assert: architecture subarchitecture isNil.
	self assert: architecture pointerSize equals: 4.
]
