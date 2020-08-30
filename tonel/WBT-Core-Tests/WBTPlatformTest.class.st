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

{ #category : #tests }
WBTPlatformTest >> testWindowsClangCLX64 [
	| platform |
	platform := WBTPlatform windowsClangCLX64.
	self assert: platform name equals: #windows.
	self assert: platform architecture canonicalName equals: #x86_64.
	self assert: platform architecture name equals: #x64.
	self assert: platform toolchain isMSVCStyle.
]

{ #category : #tests }
WBTPlatformTest >> testWindowsClangCLX86 [
	| platform |
	platform := WBTPlatform windowsClangCLX86.
	self assert: platform name equals: #windows.
	self assert: platform architecture canonicalName equals: #i686.
	self assert: platform architecture name equals: #x86.
	self assert: platform toolchain isMSVCStyle.
]

{ #category : #tests }
WBTPlatformTest >> testWindowsClangX64 [
	| platform |
	platform := WBTPlatform windowsClangX64.
	self assert: platform name equals: #windows.
	self assert: platform architecture canonicalName equals: #x86_64.
	self assert: platform architecture name equals: #x64.
	self assert: platform toolchain isUnixStyle.
]

{ #category : #tests }
WBTPlatformTest >> testWindowsClangX86 [
	| platform |
	platform := WBTPlatform windowsClangX86.
	self assert: platform name equals: #windows.
	self assert: platform architecture canonicalName equals: #i686.
	self assert: platform architecture name equals: #x86.
	self assert: platform toolchain isUnixStyle.
]

{ #category : #tests }
WBTPlatformTest >> testWindowsX64 [
	| platform |
	platform := WBTPlatform windowsX64.
	self assert: platform name equals: #windows.
	self assert: platform architecture canonicalName equals: #x86_64.
	self assert: platform architecture name equals: #x64.
	self assert: platform toolchain isMSVCStyle.
]

{ #category : #tests }
WBTPlatformTest >> testWindowsX86 [
	| platform |
	platform := WBTPlatform windowsX86.
	self assert: platform name equals: #windows.
	self assert: platform architecture canonicalName equals: #i686.
	self assert: platform architecture name equals: #x86.
	self assert: platform toolchain isMSVCStyle.
]
