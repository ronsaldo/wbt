Class {
	#name : #WBTPlatform,
	#superclass : #Object,
	#instVars : [
		'name',
		'architecture',
		'triple',
		'cpu',
		'fpu',
		'floatAbiName',
		'floatingPointModel',
		'toolchain',
		'objectFilePrefix',
		'objectFileSuffix',
		'executablePrefix',
		'executableSuffix',
		'staticLibraryPrefix',
		'staticLibrarySuffix',
		'dynamicLibraryPrefix',
		'dynamicLibrarySuffix',
		'dynamicLibraryImportPrefix',
		'dynamicLibraryImportSuffix',
		'pluginPrefix',
		'pluginSuffix',
		'properties'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #accessing }
WBTPlatform class >> current [
	^ Smalltalk os current wbtPlatform
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> linux [
	^ self linuxGCC
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> linuxClang [
	^ self new
		name: #linux;
		architecture: WBTArchitecture forCurrentPlatform;
		toolchain: WBTToolChain linuxClang;
		setForUnixConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> linuxGCC [
	^ self new
		name: #linux;
		architecture: WBTArchitecture forCurrentPlatform;
		toolchain: WBTToolChain linuxGCC;
		setForUnixConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> osx [
	^ self new
		name: #osx;
		toolchain: WBTToolChain osxClang;
		setForOSXConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> win32 [
	^ self windowsX86
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> win64 [
	^ self windowsX64
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> windowsClangCLX64 [
	^ self new
		name: #windows;
		architecture: WBTArchitecture x64;
		toolchain: WBTToolChain windowsClangCL;
		setForWindowsConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> windowsClangCLX86 [
	^ self new
		name: #windows;
		architecture: WBTArchitecture x86;
		toolchain: WBTToolChain windowsClangCL;
		setForWindowsConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> windowsClangX64 [
	^ self new
		name: #windows;
		architecture: WBTArchitecture x64;
		toolchain: WBTToolChain windowsClang;
		setForWindowsConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> windowsClangX86 [
	^ self new
		name: #windows;
		architecture: WBTArchitecture x86;
		toolchain: WBTToolChain windowsClang;
		setForWindowsConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> windowsX64 [
	^ self new
		name: #windows;
		architecture: WBTArchitecture x64;
		toolchain: WBTToolChain windowsMSVC;
		setForWindowsConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> windowsX86 [
	^ self new
		name: #windows;
		architecture: WBTArchitecture x86;
		toolchain: WBTToolChain windowsMSVC;
		setForWindowsConventions;
		yourself
]

{ #category : #accessing }
WBTPlatform >> architecture [
	^ architecture
]

{ #category : #accessing }
WBTPlatform >> architecture: anObject [
	architecture := anObject
]

{ #category : #accessing }
WBTPlatform >> cpu [
	^ cpu
]

{ #category : #accessing }
WBTPlatform >> cpu: anObject [
	cpu := anObject
]

{ #category : #accessing }
WBTPlatform >> dynamicLibraryImportPrefix [
	^ dynamicLibraryImportPrefix
]

{ #category : #accessing }
WBTPlatform >> dynamicLibraryImportPrefix: anObject [
	dynamicLibraryImportPrefix := anObject
]

{ #category : #accessing }
WBTPlatform >> dynamicLibraryImportSuffix [
	^ dynamicLibraryImportSuffix
]

{ #category : #accessing }
WBTPlatform >> dynamicLibraryImportSuffix: anObject [
	dynamicLibraryImportSuffix := anObject
]

{ #category : #accessing }
WBTPlatform >> dynamicLibraryPrefix [
	^ dynamicLibraryPrefix
]

{ #category : #accessing }
WBTPlatform >> dynamicLibraryPrefix: anObject [
	dynamicLibraryPrefix := anObject
]

{ #category : #accessing }
WBTPlatform >> dynamicLibrarySuffix [
	^ dynamicLibrarySuffix
]

{ #category : #accessing }
WBTPlatform >> dynamicLibrarySuffix: anObject [
	dynamicLibrarySuffix := anObject
]

{ #category : #accessing }
WBTPlatform >> executablePrefix [
	^ executablePrefix
]

{ #category : #accessing }
WBTPlatform >> executablePrefix: anObject [
	executablePrefix := anObject
]

{ #category : #accessing }
WBTPlatform >> executableSuffix [
	^ executableSuffix
]

{ #category : #accessing }
WBTPlatform >> executableSuffix: anObject [
	executableSuffix := anObject
]

{ #category : #accessing }
WBTPlatform >> floatAbiName [
	^ floatAbiName
]

{ #category : #accessing }
WBTPlatform >> floatAbiName: anObject [
	floatAbiName := anObject
]

{ #category : #accessing }
WBTPlatform >> floatingPointModel [
	^ floatingPointModel
]

{ #category : #accessing }
WBTPlatform >> floatingPointModel: anObject [
	floatingPointModel := anObject
]

{ #category : #'as yet unclassified' }
WBTPlatform >> formatDynamicLibraryFileName: libraryName [
	^ self dynamicLibraryPrefix , libraryName , self dynamicLibrarySuffix
]

{ #category : #'as yet unclassified' }
WBTPlatform >> formatDynamicLibraryImportFileName: libraryName [
	^ self dynamicLibraryImportPrefix , libraryName , self dynamicLibraryImportSuffix
]

{ #category : #'as yet unclassified' }
WBTPlatform >> formatExecutableFileName: executableFileName [
	^ self executablePrefix , executableFileName , self executableSuffix
]

{ #category : #'as yet unclassified' }
WBTPlatform >> formatObjectFileName: objectFileName [
	^ self objectFilePrefix , objectFileName , self objectFileSuffix
]

{ #category : #'as yet unclassified' }
WBTPlatform >> formatStaticLibraryFileName: libraryName [
	^ self staticLibraryPrefix , libraryName , self staticLibrarySuffix
]

{ #category : #accessing }
WBTPlatform >> fpu [
	^ fpu
]

{ #category : #accessing }
WBTPlatform >> fpu: anObject [
	fpu := anObject
]

{ #category : #initialization }
WBTPlatform >> initialize [
	super initialize.
	properties := Dictionary new.
]

{ #category : #testing }
WBTPlatform >> isLinux [
	^ name = #linux
]

{ #category : #testing }
WBTPlatform >> isOSX [
	^ name = #osx
]

{ #category : #testing }
WBTPlatform >> isWindows [
	^ name = #windows
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
WBTPlatform >> objectFilePrefix [
	^ objectFilePrefix
]

{ #category : #accessing }
WBTPlatform >> objectFilePrefix: anObject [
	objectFilePrefix := anObject
]

{ #category : #accessing }
WBTPlatform >> objectFileSuffix [
	^ objectFileSuffix
]

{ #category : #accessing }
WBTPlatform >> objectFileSuffix: anObject [
	objectFileSuffix := anObject
]

{ #category : #initialization }
WBTPlatform >> setForOSXConventions [
	objectFilePrefix := ''.
	objectFileSuffix := '.o'.
	executablePrefix := ''.
	executableSuffix := ''.
	staticLibraryPrefix := 'lib'.
	staticLibrarySuffix := '.a'.	
	dynamicLibraryPrefix := 'lib'.
	dynamicLibrarySuffix := '.dylib'.
	dynamicLibraryImportPrefix := 'lib'.
	dynamicLibraryImportSuffix := '.dylib'.
	pluginPrefix := 'lib'.
	pluginSuffix := '.so'.
]

{ #category : #initialization }
WBTPlatform >> setForUnixConventions [
	objectFilePrefix := ''.
	objectFileSuffix := '.o'.
	executablePrefix := ''.
	executableSuffix := ''.
	staticLibraryPrefix := 'lib'.
	staticLibrarySuffix := '.a'.	
	dynamicLibraryPrefix := 'lib'.
	dynamicLibrarySuffix := '.so'.
	dynamicLibraryImportPrefix := 'lib'.
	dynamicLibraryImportSuffix := '.so'.
	pluginPrefix := 'lib'.
	pluginSuffix := '.so'.
]

{ #category : #initialization }
WBTPlatform >> setForWindowsConventions [
	objectFilePrefix := ''.
	objectFileSuffix := '.obj'.
	executablePrefix := ''.
	executableSuffix := '.exe'.
	staticLibraryPrefix := ''.
	staticLibrarySuffix := '.lib'.	
	dynamicLibraryPrefix := ''.
	dynamicLibrarySuffix := '.dll'.
	dynamicLibraryImportPrefix := ''.
	dynamicLibraryImportSuffix := '.lib'.
	pluginPrefix := ''.
	pluginSuffix := '.dll'.
]

{ #category : #accessing }
WBTPlatform >> staticLibraryPrefix [
	^ staticLibraryPrefix
]

{ #category : #accessing }
WBTPlatform >> staticLibraryPrefix: anObject [
	staticLibraryPrefix := anObject
]

{ #category : #accessing }
WBTPlatform >> staticLibrarySuffix [
	^ staticLibrarySuffix
]

{ #category : #accessing }
WBTPlatform >> staticLibrarySuffix: anObject [
	staticLibrarySuffix := anObject
]

{ #category : #'as yet unclassified' }
WBTPlatform >> substitutionVariables [
	^ self toolchain substitutionVariablesForPlatform: self
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

{ #category : #'as yet unclassified' }
WBTPlatform >> variableEnvironment [
	^ WBTVariableSubstitutionEnvironment empty
		setVariables: self substitutionVariables;
		yourself
]
