"
A WBTBuildEnvironmentTest is a test class for testing the behavior of WBTBuildEnvironment
"
Class {
	#name : #WBTBuildEnvironmentTest,
	#superclass : #TestCase,
	#category : #'WBT-Core-Tests'
}

{ #category : #tests }
WBTBuildEnvironmentTest >> testForCurrentPlatform [
	| buildEnvironment |
	buildEnvironment := WBTBuildEnvironment forCurrentPlatform.
	self assert: (#(linux windows osx) includes: buildEnvironment platform name).
]

{ #category : #tests }
WBTBuildEnvironmentTest >> testForLinux [
	| buildEnvironment |
	buildEnvironment := WBTBuildEnvironment forLinux.
	self assert: buildEnvironment platform name equals: #linux.
]

{ #category : #tests }
WBTBuildEnvironmentTest >> testForLinuxClang [
	| buildEnvironment |
	buildEnvironment := WBTBuildEnvironment forLinuxClang.
	self assert: buildEnvironment platform name equals: #linux.
	self assert: (buildEnvironment platform toolchain cc includesSubstring: 'clang').
]

{ #category : #tests }
WBTBuildEnvironmentTest >> testForLinuxGCC [
	| buildEnvironment |
	buildEnvironment := WBTBuildEnvironment forLinuxGCC.
	self assert: buildEnvironment platform name equals: #linux.
	self assert: (buildEnvironment platform toolchain cc includesSubstring: 'gcc').
]

{ #category : #tests }
WBTBuildEnvironmentTest >> testForOSX [
	| buildEnvironment |
	buildEnvironment := WBTBuildEnvironment forOSX.
	self assert: buildEnvironment platform name equals: #osx.
	self assert: (buildEnvironment platform toolchain cc includesSubstring: 'clang').
]

{ #category : #tests }
WBTBuildEnvironmentTest >> testForWindowsClangCLX64 [
	| buildEnvironment |
	buildEnvironment := WBTBuildEnvironment forWindowsClangCLX64.
	self assert: buildEnvironment platform name equals: #windows.
	self assert: buildEnvironment platform architecture name equals: #x64.
	self assert: buildEnvironment platform toolchain isMSVCStyle.
	self assert: (buildEnvironment platform toolchain cl includesSubstring: 'clang-cl').
]

{ #category : #tests }
WBTBuildEnvironmentTest >> testForWindowsClangCLX86 [
	| buildEnvironment |
	buildEnvironment := WBTBuildEnvironment forWindowsClangCLX86.
	self assert: buildEnvironment platform name equals: #windows.
	self assert: buildEnvironment platform architecture name equals: #x86.
	self assert: buildEnvironment platform toolchain isMSVCStyle.
	self assert: (buildEnvironment platform toolchain cl includesSubstring: 'clang-cl').
]

{ #category : #tests }
WBTBuildEnvironmentTest >> testForWindowsClangX64 [
	| buildEnvironment |
	buildEnvironment := WBTBuildEnvironment forWindowsClangX64.
	self assert: buildEnvironment platform name equals: #windows.
	self assert: buildEnvironment platform architecture name equals: #x64.
	self assert: buildEnvironment platform toolchain isUnixStyle.
	self assert: (buildEnvironment platform toolchain cc includesSubstring: 'clang').
	self assert: (buildEnvironment platform toolchain cxx includesSubstring: 'clang++').
]

{ #category : #tests }
WBTBuildEnvironmentTest >> testForWindowsClangX86 [
	| buildEnvironment |
	buildEnvironment := WBTBuildEnvironment forWindowsClangX86.
	self assert: buildEnvironment platform name equals: #windows.
	self assert: buildEnvironment platform architecture name equals: #x86.
	self assert: buildEnvironment platform toolchain isUnixStyle.
	self assert: (buildEnvironment platform toolchain cc includesSubstring: 'clang').
	self assert: (buildEnvironment platform toolchain cxx includesSubstring: 'clang++').
]

{ #category : #tests }
WBTBuildEnvironmentTest >> testForWindowsX64 [
	| buildEnvironment |
	buildEnvironment := WBTBuildEnvironment forWindowsX64.
	self assert: buildEnvironment platform name equals: #windows.
	self assert: buildEnvironment platform architecture name equals: #x64.
	self assert: buildEnvironment platform toolchain isMSVCStyle.
	self assert: (buildEnvironment platform toolchain cl includesSubstring: 'cl').
]

{ #category : #tests }
WBTBuildEnvironmentTest >> testForWindowsX86 [
	| buildEnvironment |
	buildEnvironment := WBTBuildEnvironment forWindowsX86.
	self assert: buildEnvironment platform name equals: #windows.
	self assert: buildEnvironment platform architecture name equals: #x86.
	self assert: buildEnvironment platform toolchain isMSVCStyle.
	self assert: (buildEnvironment platform toolchain cl includesSubstring: 'cl').
]

{ #category : #tests }
WBTBuildEnvironmentTest >> testNewLibraryPackage [
	| buildEnvironment package |
	buildEnvironment := WBTBuildEnvironment forLinux.
	package := buildEnvironment getOrCreatePackageNamed: #testLibrary.
	self assert: package name equals: #testLibrary.
	package
		inFolder: FileSystem workingDirectory
		evaluateScript: 'self importLibrary: #test fromLibFolder: #TestLib'.
	self
		assert: package exportedLibraries first importLibName
		equals: #test.
	self
		assert:
			(package exportedLibrariesLinkerArguments asArray
				includesAll: #('-ltest'))
]
