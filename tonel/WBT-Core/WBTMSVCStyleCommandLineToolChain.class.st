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
		'targetArch',
		'vcvarsallPlatform',
		'makepri',
		'makeappx',
		'signTool'
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

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> makeappx [
	^ makeappx
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> makeappx: anObject [
	makeappx := anObject
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> makepri [
	^ makepri
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> makepri: anObject [
	makepri := anObject
]

{ #category : #initialization }
WBTMSVCStyleCommandLineToolChain >> setForClangCL [
	self setForWindowsCommon.
	cl := self class clangCLProgram.
	link := self class lldLinkProgram.
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
	makepri := 'makepri.exe'.
	makeappx := 'makeappx.exe'.
	signTool := 'signtool.exe'.
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> signTool [
	^ signTool
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> signTool: anObject [
	signTool := anObject
]

{ #category : #'as yet unclassified' }
WBTMSVCStyleCommandLineToolChain >> substitutionVariables [
	^ super substitutionVariables , { 
		#WBT_EXECUTABLE_LINKER_FLAGS . '/opt:ref'.
		#WBT_DYNAMIC_LIBRARY_LINKER_FLAGS . '/opt:ref'.

		#WBT_LINK_RUNTIME_LIBRARIES . '$(WBT_APP_CONTAINER_FLAG) $(WBT_C_RUNTIME_LIBRARY)'.

		#WBT_C_FLAGS . ''.
		#WBT_CXX_FLAGS . '/EHsc'.

		#WBT_C_DEBUG_FLAGS . '/Zi'.
		#WBT_CXX_DEBUG_FLAGS . '/Zi'.
		#WBT_C_MINSIZE_FLAGS . '/O1'.
		#WBT_CXX_MINSIZE_FLAGS . '/O1'.
		#WBT_C_RELWITHDEBINFO_FLAGS . '/Zi /O2'.
		#WBT_CXX_RELWITHDEBINFO_FLAGS . '/Zi /O2'.
		#WBT_C_RELEASE_FLAGS . '/O2'.
		#WBT_CXX_RELEASE_FLAGS . '/O2'.

		#WBT_C_ACTIVE_FLAGS . '$(WBT_C_FLAGS) $(WBT_C_$(WBT_BUILD_MODE)_FLAGS) $(WBT_C_RUNTIME_FLAGS)'.
		#WBT_CXX_ACTIVE_FLAGS . '$(WBT_CXX_FLAGS) $(WBT_CXX_$(WBT_BUILD_MODE)_FLAGS) $(WBT_C_RUNTIME_FLAGS)'.

		#WBT_C_COMPILER . [ self vcBuildEnvironmentSetupPrefix , self cl].
		#WBT_CXX_COMPILER . [self vcBuildEnvironmentSetupPrefix , self cl].

		#WBT_C_COMPILE_OBJECT . '$(WBT_C_COMPILER) $(WBT_C_ACTIVE_FLAGS)  $(WBT_C_INCLUDE_DIRECTORIES_FLAGS) /Fo$(WBT_OUTPUT_FILE) /c $(WBT_INPUT_FILES) $(WBT_C_FLAGS)'.
		#WBT_CXX_COMPILE_OBJECT . '$(WBT_CXX_COMPILER) $(WBT_CXX_ACTIVE_FLAGS) $(WBT_C_INCLUDE_DIRECTORIES_FLAGS) /Fo$(WBT_OUTPUT_FILE) /c $(WBT_INPUT_FILES) $(WBT_CXX_FLAGS)'.

		#WBT_STATIC_LINKER . [self vcBuildEnvironmentSetupPrefix , self lib ].

		#WBT_LINKER . [self vcBuildEnvironmentSetupPrefix , self link].

		#WBT_LINK_EXECUTABLE . '$(WBT_LINKER) /OUT:$(WBT_OUTPUT_FILE) /DEBUG  $(WBT_EXECUTABLE_LINKER_FLAGS) $(WBT_INPUT_FILES) $(WBT_LINK_LIBRARIES) $(WBT_LINK_RUNTIME_LIBRARIES)'.
		#WBT_C_LINK_EXECUTABLE . '$(WBT_LINK_EXECUTABLE)'.
		#WBT_CXX_LINK_EXECUTABLE . '$(WBT_LINK_EXECUTABLE)'.

		#WBT_LINK_STATIC_LIBRARY . '$(WBT_STATIC_LINKER) /OUT:$(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES)'.
		#WBT_C_LINK_STATIC_LIBRARY . '$(WBT_LINK_STATIC_LIBRARY)'.
		#WBT_CXX_LINK_STATIC_LIBRARY . '$(WBT_LINK_STATIC_LIBRARY)'.

		#WBT_LINK_DYNAMIC_LIBRARY . '$(WBT_LINKER) /DLL /OUT:$(WBT_OUTPUT_FILE) /DEBUG $(WBT_DYNAMIC_LIBRARY_LINKER_FLAGS) $(WBT_INPUT_FILES) $(WBT_LINK_LIBRARIES) $(WBT_LINK_RUNTIME_LIBRARIES)'.
		#WBT_C_LINK_DYNAMIC_LIBRARY . '$(WBT_LINK_DYNAMIC_LIBRARY)'.
		#WBT_CXX_LINK_DYNAMIC_LIBRARY . '$(WBT_LINK_DYNAMIC_LIBRARY)'.
		
		#WBT_MAKE_PRI . [self vcBuildEnvironmentSetupPrefix , self makepri].
		#WBT_MAKE_PRI_CONFIG . '$(WBT_MAKE_PRI) createconfig /o /cf priconfig.xml /dq en-US'.
		#WBT_MAKE_RESOURCES_PRI . '$(WBT_MAKE_PRI) new /o /pr $(WBT_PACKAGE_FOLDER) /cf $(WBT_INPUT_FILES)' .
		
		#WBT_MAKE_APPX . [self vcBuildEnvironmentSetupPrefix , self makeappx].
		#WBT_MAKE_APPX_PACKAGE . '$(WBT_MAKE_APPX) pack /m $(WBT_INPUT_FILES) /f $(WBT_MAPPINGS_FILE) /p $(WBT_OUTPUT_FILE)'.
		
		#WBT_SIGN_TOOL . [ self vcBuildEnvironmentSetupPrefix , self signTool ].
		#WBT_SIGN_APPX . '$(WBT_SIGN_TOOL) sign /Fd SHA256 /a /f $(WBT_INPUT_FILES) /p "$(WBT_CERT_PASSWORD)" $(WBT_OUTPUT_FILE)'
	 }
]

{ #category : #'as yet unclassified' }
WBTMSVCStyleCommandLineToolChain >> substitutionVariablesForPlatform: aPlatform [
	| runtimeLibs |
	targetArch := aPlatform architecture name.
	runtimeLibs := { 
		#WBT_C_RUNTIME_FLAGS . '/MD'.
		#WBT_C_RUNTIME_LIBRARY . 'msvcrt.lib'.
	}.
	aPlatform name = #uwp ifTrue: [
		runtimeLibs := { 
			#WBT_C_RUNTIME_FLAGS . '/MD'.
			#WBT_C_RUNTIME_LIBRARY . 'WindowsApp.lib'.
			#WBT_APP_CONTAINER_FLAG . '/APPCONTAINER'.
			#WBT_CXX_FLAGS . '/EHsc /ZW'.
		}.

		vcvarsallPlatform := 'uwp'.
	].
	^ (super substitutionVariablesForPlatform: aPlatform) , runtimeLibs
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> vcBuildEnvironmentSetupPrefix [
	^ vcBuildEnvironmentSetupPrefix ifNil: [vcBuildEnvironmentSetupPrefix
		:= 'call "{1}" {2} {3} > NUL && ' format:  {self vcvarsall . self vcvarsallArch . self vcvarsallPlatform }
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
WBTMSVCStyleCommandLineToolChain >> vcvarsallPlatform [
	^ vcvarsallPlatform ifNil: [ vcvarsallPlatform := '' ]
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> vcvarsallPlatform: aPlatform [
	vcvarsallPlatform := aPlatform
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> visualStudioInstallationPath [
	^ visualStudioInstallationPath ifNil: [visualStudioInstallationPath := self findVisualStudioInstallationPath]
]
