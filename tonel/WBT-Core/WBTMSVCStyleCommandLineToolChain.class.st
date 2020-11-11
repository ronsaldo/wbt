Class {
	#name : #WBTMSVCStyleCommandLineToolChain,
	#superclass : #WBTCommandLineToolChain,
	#instVars : [
		'cl',
		'link',
		'lib',
		'visualStudioInstallationPath',
		'vcvarsall',
		'vcBuildEnvironmentSetupPrefix',
		'compilerArch',
		'targetArch'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> cl [
	^ cl
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> cl: anObject [
	cl := anObject
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> findVCVarsAllPath [
	| path |
	path := self visualStudioInstallationPath asFileReference / 'VC' / 'Auxiliary' / 'Build' / 'vcvarsall.bat'.
	path exists ifFalse: [ self error: 'Failed to find vcvarsall.bat' ].
	^ path fullName
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> findVisualStudioInstallationPath [
	| result |
	result := (LibC resultOfCommand: '""%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"" -latest -requires Microsoft.VisualStudio.Workload.NativeDesktop -property installationPath') trimBoth asFileReference.
	result exists ifFalse: [ self error: 'Failed to find the visual studio installation path.' ].
	^ result fullName
]

{ #category : #initialization }
WBTMSVCStyleCommandLineToolChain >> initialize [
	super initialize.
	importLibraryFolderArgumentPrefix := '/LIBPATH:'.
	importLibraryArgumentPrefix := ''.
	importLibraryArgumentSuffix := '.lib'.
	includeDirectoryArgumentPrefix := '/I'.
	compilerArch := Smalltalk wordSize = 8
		ifTrue: [ 'x64' ]
		ifFalse: [ 'x86' ].
]

{ #category : #testing }
WBTMSVCStyleCommandLineToolChain >> isMSVCStyle [
	^ true
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> lib [
	^ lib
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> lib: anObject [
	lib := anObject
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> link [
	^ link
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> link: anObject [
	link := anObject
]

{ #category : #initialization }
WBTMSVCStyleCommandLineToolChain >> setForClangCL [
	self setForWindowsCommon.
	cl := 'clang-cl.exe'.
	link := 'link.exe'.
]

{ #category : #initialization }
WBTMSVCStyleCommandLineToolChain >> setForMSVC [
	self setForWindowsCommon.
	cl := 'cl.exe /nologo'.
	link := 'link.exe /nologo'.
]

{ #category : #initialization }
WBTMSVCStyleCommandLineToolChain >> setForWindowsCommon [
	lib := 'lib.exe /nologo'.
]

{ #category : #'as yet unclassified' }
WBTMSVCStyleCommandLineToolChain >> substitutionVariables [
	^ super substitutionVariables , { 
		#WBT_C_DEBUG_FLAGS . '/Zi'.
		#WBT_C_MINSIZE_FLAGS . '/O1'.
		#WBT_C_RELWITHDEBINFO_FLAGS . '/Zi /O2'.
		#WBT_C_RELEASE_FLAGS . '/O2'.
		
		#WBT_C_COMPILER . [ self vcBuildEnvironmentSetupPrefix , self cl].
		#WBT_C_COMPILE_OBJECT . '$(WBT_C_COMPILER) $(WBT_C_FLAGS) $(WBT_C_$(WBT_BUILD_TYPE)_FLAGS) $(WBT_C_INCLUDE_DIRECTORIES_FLAGS) /Fo$(WBT_OUTPUT_FILE) /c $(WBT_INPUT_FILES) $(WBT_C_FLAGS)'.

		#WBT_C_LINKER . [self vcBuildEnvironmentSetupPrefix , self link].
		#WBT_C_LINK_EXECUTABLE . '$(WBT_C_COMPILER) /Fe$(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) /link $(WBT_EXECUTABLE_LINKER_FLAGS) $(WBT_LINK_LIBRARIES)'.

		#WBT_CXX_FLAGS . '/EHsc'.

		#WBT_CXX_DEBUG_FLAGS . '/Zi'.
		#WBT_CXX_MINSIZE_FLAGS . '/O1'.
		#WBT_CXX_RELWITHDEBINFO_FLAGS . '/Zi /O2'.
		#WBT_CXX_RELEASE_FLAGS . '/O2'.

		#WBT_CXX_COMPILER . [self vcBuildEnvironmentSetupPrefix , self cl].
		#WBT_CXX_COMPILE_OBJECT . '$(WBT_CXX_COMPILER) $(WBT_CXX_FLAGS) $(WBT_CXX_$(WBT_BUILD_TYPE)_FLAGS) $(WBT_C_INCLUDE_DIRECTORIES_FLAGS) /Fo$(WBT_OUTPUT_FILE) /c $(WBT_INPUT_FILES) $(WBT_CXX_FLAGS)'.

		#WBT_STATIC_LINKER . [self vcBuildEnvironmentSetupPrefix , self lib ].

		#WBT_LINK_STATIC_LIBRARY . '$(WBT_STATIC_LINKER) /OUT:$(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES)'.
		#WBT_C_LINK_STATIC_LIBRARY . '$(WBT_LINK_STATIC_LIBRARY)'.
		#WBT_CXX_LINK_STATIC_LIBRARY . '$(WBT_LINK_STATIC_LIBRARY)'.

		#WBT_CXX_LINKER . [self vcBuildEnvironmentSetupPrefix , self link].
		#WBT_CXX_LINK_EXECUTABLE . '$(WBT_CXX_COMPILER) /Fe$(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) /link $(WBT_EXECUTABLE_LINKER_FLAGS) $(WBT_LINK_LIBRARIES)'.
		
		#WBT_LINK_DYNAMIC_LIBRARY . '$(WBT_C_LINKER) /DLL /OUT:$(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) $(WBT_DYNAMIC_LIBRARY_LINKER_FLAGS) $(WBT_LINK_LIBRARIES)'.
		#WBT_C_LINK_DYNAMIC_LIBRARY . '$(WBT_LINK_DYNAMIC_LIBRARY)'.
		#WBT_CXX_LINK_DYNAMIC_LIBRARY . '$(WBT_CXX_LINKER) /DLL /OUT:$(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) $(WBT_DYNAMIC_LIBRARY_LINKER_FLAGS) $(WBT_LINK_LIBRARIES)'.
	 }
]

{ #category : #'as yet unclassified' }
WBTMSVCStyleCommandLineToolChain >> substitutionVariablesForPlatform: aPlatform [
	targetArch := aPlatform architecture name.
	^ super substitutionVariablesForPlatform: aPlatform
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> vcBuildEnvironmentSetupPrefix [
	^ vcBuildEnvironmentSetupPrefix ifNil: [vcBuildEnvironmentSetupPrefix
		:= 'call "{1}" {2} > NUL &&' format:  {self vcvarsall . self vcvarsallArch }
	]
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> vcvarsall [
	^ vcvarsall ifNil: [ vcvarsall := self findVCVarsAllPath ]
]

{ #category : #'as yet unclassified' }
WBTMSVCStyleCommandLineToolChain >> vcvarsallArch [
	^ compilerArch = targetArch
		ifTrue: [ compilerArch ]
		ifFalse: [ compilerArch , '_' , targetArch ]
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> visualStudioInstallationPath [
	^ visualStudioInstallationPath ifNil: [visualStudioInstallationPath := self findVisualStudioInstallationPath]
]
