Class {
	#name : #WBTPlatform,
	#superclass : #WBTObject,
	#instVars : [
		'environment',
		'architecture',
		'name',
		'canonicalName',
		'abiName',
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
		'systemVendor',
		'isEmbeddedPAL',
		'defaultBundleType'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #accessing }
WBTPlatform class >> current [
	^ Smalltalk os current wbtPlatform
]

{ #category : #accessing }
WBTPlatform class >> currentWithClang [
	^ Smalltalk os current wbtPlatformWithClang
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
		setDefaultOperatingSystemConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> linuxGCC [
	^ self new
		name: #linux;
		architecture: WBTArchitecture forCurrentPlatform;
		toolchain: WBTToolChain linuxGCC;
		setDefaultOperatingSystemConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> osx [
	^ self new
		name: #osx;
		architecture: WBTArchitecture forCurrentPlatform;
		toolchain: WBTToolChain osxClang;
		setForOSXConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> uwpClangCLX64 [
	^ self new
		name: #uwp;
		architecture: WBTArchitecture x64;
		toolchain: WBTToolChain windowsClangCL;
		setDefaultOperatingSystemConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> uwpClangCLX86 [
	^ self new
		name: #uwp;
		architecture: WBTArchitecture x86;
		toolchain: WBTToolChain windowsClangCL;
		setDefaultOperatingSystemConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> uwpX64 [
	^ self new
		name: #uwp;
		architecture: WBTArchitecture x64;
		toolchain: WBTToolChain windowsMSVC;
		setDefaultOperatingSystemConventions;
		defaultBundleType: WBTBundleTypeAppx uniqueInstance;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> uwpX86 [
	^ self new
		name: #uwp;
		architecture: WBTArchitecture x86;
		toolchain: WBTToolChain windowsMSVC;
		setDefaultOperatingSystemConventions;
		defaultBundleType: WBTBundleTypeAppx uniqueInstance;
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
		setDefaultOperatingSystemConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> windowsClangCLX86 [
	^ self new
		name: #windows;
		architecture: WBTArchitecture x86;
		toolchain: WBTToolChain windowsClangCL;
		setDefaultOperatingSystemConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> windowsClangX64 [
	^ self new
		name: #windows;
		architecture: WBTArchitecture x64;
		toolchain: WBTToolChain windowsClang;
		setDefaultOperatingSystemConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> windowsClangX86 [
	^ self new
		name: #windows;
		architecture: WBTArchitecture x86;
		toolchain: WBTToolChain windowsClang;
		setDefaultOperatingSystemConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> windowsX64 [
	^ self new
		name: #windows;
		architecture: WBTArchitecture x64;
		toolchain: WBTToolChain windowsMSVC;
		setDefaultOperatingSystemConventions;
		yourself
]

{ #category : #'as yet unclassified' }
WBTPlatform class >> windowsX86 [
	^ self new
		name: #windows;
		architecture: WBTArchitecture x86;
		toolchain: WBTToolChain windowsMSVC;
		setDefaultOperatingSystemConventions;
		yourself
]

{ #category : #accessing }
WBTPlatform >> abiName [
	^ abiName ifNil: [ abiName := self defaultAbiName ]
]

{ #category : #accessing }
WBTPlatform >> abiName: anObject [
	abiName := anObject
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
WBTPlatform >> canonicalName [
	^ canonicalName
]

{ #category : #accessing }
WBTPlatform >> canonicalName: anObject [
	canonicalName := anObject
]

{ #category : #accessing }
WBTPlatform >> cpu [
	^ cpu
]

{ #category : #accessing }
WBTPlatform >> cpu: anObject [
	cpu := anObject
]

{ #category : #'as yet unclassified' }
WBTPlatform >> defaultAbiName [
	(architecture isX86 or: [ architecture isX64 ]) ifTrue: [ 
		self isWindowsFamily ifTrue: [ ^ #msvc ].
		self isAppleFamily ifTrue: [ ^ #macho ].
		self isUnixFamily ifTrue: [ ^ #gnu ].
		^ #elf
	].
	(architecture isARM32 or: [architecture isARM64]) ifTrue: [ 
		self isLinux ifTrue: [ ^ self floatAbiName = #hard ifTrue: [ #gnueabihf ] ifFalse: [ #gnueabi ] ].
		^ #eabi
	].

	^ #''
]

{ #category : #accessing }
WBTPlatform >> defaultBundleType [
	^ defaultBundleType ifNil: [ defaultBundleType := WBTBundleTypeZip uniqueInstance ]
]

{ #category : #accessing }
WBTPlatform >> defaultBundleType: anObject [
	defaultBundleType := anObject
]

{ #category : #accessing }
WBTPlatform >> defaultVendorName [
	(architecture isX86 or: [ architecture isX64 ]) ifTrue: [
		^ #pc
	].

	^ #unknown
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
WBTPlatform >> environment [
	^ environment
]

{ #category : #accessing }
WBTPlatform >> environment: anObject [
	environment := anObject
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

{ #category : #utility }
WBTPlatform >> formatDynamicLibraryFileName: libraryName [
	^ self dynamicLibraryPrefix , libraryName , self dynamicLibrarySuffix
]

{ #category : #utility }
WBTPlatform >> formatDynamicLibraryImportFileName: libraryName [
	^ self dynamicLibraryImportPrefix , libraryName , self dynamicLibraryImportSuffix
]

{ #category : #utility }
WBTPlatform >> formatExecutableFileName: executableFileName [
	^ self executablePrefix , executableFileName , self executableSuffix
]

{ #category : #utility }
WBTPlatform >> formatObjectFileName: objectFileName [
	^ self objectFilePrefix , objectFileName , self objectFileSuffix
]

{ #category : #utility }
WBTPlatform >> formatStaticLibraryFileName: libraryName [
	^ self staticLibraryPrefix , libraryName , self staticLibrarySuffix
]

{ #category : #accessing }
WBTPlatform >> formatTriple [
	^ ByteString streamContents: [ :out |
		out nextPutAll: architecture fullCanonicalName.
		self systemVendor ifNotEmpty: [ 
			out nextPut: $-; nextPutAll: systemVendor
		] ifEmpty: [ 
			out nextPutAll: '-unknown'
		].
	
		canonicalName ifNotEmpty: [ 
			out nextPut: $-; nextPutAll: canonicalName
		] ifEmpty: [ 
			out nextPutAll: '-none'
		].

		self abiName ifNotEmpty: [
			out nextPut: $-; nextPutAll: abiName
		] ifEmpty: [ 
			out nextPutAll: '-unknown'
		].
	]
]

{ #category : #accessing }
WBTPlatform >> fpu [
	^ fpu
]

{ #category : #accessing }
WBTPlatform >> fpu: anObject [
	fpu := anObject
]

{ #category : #testing }
WBTPlatform >> isAndroid [
	^ name = #android
]

{ #category : #testing }
WBTPlatform >> isAppleFamily [
	^ #(osx ios) includes: name
]

{ #category : #testing }
WBTPlatform >> isBSD [
	^ name = #bsd
]

{ #category : #accessing }
WBTPlatform >> isEmbeddedPAL [
	^ isEmbeddedPAL ifNil: [ isEmbeddedPAL := name = #epal ]
]

{ #category : #accessing }
WBTPlatform >> isEmbeddedPAL: anObject [
	isEmbeddedPAL := anObject
]

{ #category : #testing }
WBTPlatform >> isFreeBSD [
	^ name = #freebsd
]

{ #category : #testing }
WBTPlatform >> isIOS [
	^ name = #ios
]

{ #category : #testing }
WBTPlatform >> isLinux [
	^ name = #linux
]

{ #category : #'testing game consoles' }
WBTPlatform >> isMicrosoftXboxOne [
	^ name = #xone
]

{ #category : #'testing game consoles' }
WBTPlatform >> isMicrosoftXboxSeriesOne [
	^ name = #xsone
]

{ #category : #'testing game consoles' }
WBTPlatform >> isNintendo3DS [
	^ name = #n3ds
]

{ #category : #'testing game consoles' }
WBTPlatform >> isNintendoSwitch [
	^ name = #switch
]

{ #category : #testing }
WBTPlatform >> isNoOperatingSystem [
	^ self name = #none
]

{ #category : #testing }
WBTPlatform >> isNullOS [
	^ name = #nullos
]

{ #category : #testing }
WBTPlatform >> isOSX [
	^ name = #osx
]

{ #category : #'testing game consoles' }
WBTPlatform >> isSonyPS4 [
	^ name = #ps4
]

{ #category : #'testing game consoles' }
WBTPlatform >> isSonyPS5 [
	^ name = #ps5
]

{ #category : #testing }
WBTPlatform >> isUniversalWindowsPlatform [
	^ name = #uwp
]

{ #category : #testing }
WBTPlatform >> isUnixFamily [
	^ #(linux bsd) includes: name
]

{ #category : #testing }
WBTPlatform >> isWebAssembly [
	^ name = #wasm
]

{ #category : #testing }
WBTPlatform >> isWindows [
	^ name = #windows
]

{ #category : #testing }
WBTPlatform >> isWindowsFamily [
	^ #(windows uwp) includes: name
]

{ #category : #testing }
WBTPlatform >> isWindowsStore [
	^ name = #uwp
]

{ #category : #accessing }
WBTPlatform >> name [
	^ name
]

{ #category : #accessing }
WBTPlatform >> name: anObject [
	name := anObject.
	canonicalName := anObject.
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

{ #category : #accessing }
WBTPlatform >> pluginPrefix [
	^ pluginPrefix
]

{ #category : #initialization }
WBTPlatform >> setDefaultOperatingSystemConventions [
	self isWindowsFamily ifTrue: [ ^ self setForWindowsConventions ].
	self isAppleFamily ifTrue: [ ^ self setForOSXConventions ].
	^ self setForUnixConventions
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

{ #category : #'substitution variables' }
WBTPlatform >> substitutionVariables [
	^ self toolchain substitutionVariablesForPlatform: self
]

{ #category : #accessing }
WBTPlatform >> systemVendor [
	^ systemVendor ifNil: [ systemVendor := self defaultVendorName ]
]

{ #category : #accessing }
WBTPlatform >> systemVendor: anObject [
	systemVendor := anObject
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
	^ triple ifNil: [ triple := self formatTriple ]
]

{ #category : #accessing }
WBTPlatform >> triple: anObject [
	triple := anObject
]

{ #category : #'substitution variables' }
WBTPlatform >> variableEnvironment [
	^ WBTVariableSubstitutionEnvironment empty
		setVariables: self substitutionVariables;
		yourself
]
