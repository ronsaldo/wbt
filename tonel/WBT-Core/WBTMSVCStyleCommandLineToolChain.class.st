Class {
	#name : #WBTMSVCStyleCommandLineToolChain,
	#superclass : #WBTCommandLineToolChain,
	#instVars : [
		'vcvarsallPath',
		'cl',
		'link'
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

{ #category : #initialization }
WBTMSVCStyleCommandLineToolChain >> initialize [
	super initialize.
	importLibraryFolderArgumentPrefix := '/LIBPATH:'.
	importLibraryArgumentPrefix := ''.
	importLibraryArgumentSuffix := '.lib'.
]

{ #category : #testing }
WBTMSVCStyleCommandLineToolChain >> isMSVCStyle [
	^ true
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
	cl := 'cl.exe'.
	link := 'link.exe'.
]

{ #category : #initialization }
WBTMSVCStyleCommandLineToolChain >> setForWindowsCommon [
]

{ #category : #'as yet unclassified' }
WBTMSVCStyleCommandLineToolChain >> substitutionVariables [
	^ super substitutionVariables , { 
		#WBT_C_COMPILER . [self cl].
		#WBT_C_COMPILE_OBJECT . '$(WBT_C_COMPILER) /Fo$(WBT_OUTPUT_FILE) /c $(WBT_INPUT_FILES) $(WBT_C_FLAGS)'.

		#WBT_C_LINKER . [self link].
		#WBT_C_LINK_EXECUTABLE . '$(WBT_C_COMPILER) /Fe$(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) /link $(WBT_EXECUTABLE_LINKER_FLAGS)'.

		#WBT_CXX_COMPILER . [self cl].
		#WBT_CXX_COMPILE_OBJECT . '$(WBT_CXX_COMPILER) /Fo$(WBT_OUTPUT_FILE) /c $(WBT_INPUT_FILES) $(WBT_CXX_FLAGS)'.

		#WBT_CXX_LINKER . [self link].
		#WBT_CXX_LINK_EXECUTABLE . '$(WBT_CXX_COMPILER) /Fe$(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) /link $(WBT_EXECUTABLE_LINKER_FLAGS)'.
	 }
]

{ #category : #accessing }
WBTMSVCStyleCommandLineToolChain >> vcvarsallPath [
	^ vcvarsallPath ifNil: [ vcvarsallPath := LibC resultOfCommand: '"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"' ]
]
