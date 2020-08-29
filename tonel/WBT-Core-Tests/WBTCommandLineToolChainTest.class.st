"
A WBTCommandLineToolChainTest is a test class for testing the behavior of WBTCommandLineToolChain
"
Class {
	#name : #WBTCommandLineToolChainTest,
	#superclass : #TestCase,
	#category : #'WBT-Core-Tests'
}

{ #category : #tests }
WBTCommandLineToolChainTest >> testUnixClang [
	| toolchain |
	toolchain := WBTToolChain unixClang.
	self assert: toolchain isUnixStyle.
	self assert: toolchain isCommandLineToolChain.
	self assert: toolchain cc equals: 'clang'.
	self assert: toolchain cxx equals: 'clang++'.
	self assert: toolchain ld equals: 'ld'.
	self assert: toolchain ar equals: 'ar'.
	self assert: toolchain objcopy equals: 'objcopy'.

]

{ #category : #tests }
WBTCommandLineToolChainTest >> testUnixGCC [
	| toolchain |
	toolchain := WBTToolChain unixGCC.
	self assert: toolchain isUnixStyle.
	self assert: toolchain isCommandLineToolChain.
	self assert: toolchain cc equals: 'gcc'.
	self assert: toolchain cxx equals: 'g++'.
	self assert: toolchain ld equals: 'ld'.
	self assert: toolchain ar equals: 'ar'.
	self assert: toolchain objcopy equals: 'objcopy'.
]
