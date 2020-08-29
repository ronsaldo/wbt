"
A WBTPlatformTest is a test class for testing the behavior of WBTPlatform
"
Class {
	#name : #WBTPlatformTest,
	#superclass : #TestCase,
	#category : #'WBT-Core-Tests'
}

{ #category : #tests }
WBTPlatformTest >> testLinux [
	| platform |
	platform := WBTPlatform linux.
	self assert: platform name equals: #linux.
	self assert: platform toolchain isUnixStyle.
]

{ #category : #tests }
WBTPlatformTest >> testLinuxClang [
	| platform |
	platform := WBTPlatform linuxClang.
	self assert: platform name equals: #linux.
	self assert: platform toolchain isUnixStyle.
	self assert: (platform toolchain cc includesSubstring: 'clang').
]

{ #category : #tests }
WBTPlatformTest >> testLinuxGCC [
	| platform |
	platform := WBTPlatform linuxGCC.
	self assert: platform name equals: #linux.
	self assert: platform toolchain isUnixStyle.
	self assert: (platform toolchain cc includesSubstring: 'gcc').
]

{ #category : #tests }
WBTPlatformTest >> testOSX [
	| platform |
	platform := WBTPlatform osx.
	self assert: platform name equals: #osx.
	self assert: platform toolchain isUnixStyle.
	self assert: (platform toolchain cc includesSubstring: 'clang').
]
