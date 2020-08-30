"
A WBTArchitectureTest is a test class for testing the behavior of WBTArchitecture
"
Class {
	#name : #WBTArchitectureTest,
	#superclass : #TestCase,
	#category : #'WBT-Core-Tests'
}

{ #category : #tests }
WBTArchitectureTest >> testX64 [
	| architecture |
	architecture := WBTArchitecture x64.
	self assert: architecture name equals: #x64.
	self assert: architecture canonicalName equals: #x86_64.
]

{ #category : #tests }
WBTArchitectureTest >> testX86 [
	| architecture |
	architecture := WBTArchitecture x86.
	self assert: architecture name equals: #x86.
	self assert: architecture canonicalName equals: #i686.
]
