Class {
	#name : #WBTUnixStyleCommandLineToolChain,
	#superclass : #WBTCommandLineToolChain,
	#instVars : [
		'cc',
		'cxx',
		'ld',
		'ar',
		'objcopy',
		'rpathLocalLinkerArgument'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> ar [
	^ ar
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> ar: anObject [
	ar := anObject
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> cc [
	^ cc
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> cc: anObject [
	cc := anObject
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> cxx [
	^ cxx
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> cxx: anObject [
	cxx := anObject
]

{ #category : #initialization }
WBTUnixStyleCommandLineToolChain >> initialize [
	super initialize.
	importLibraryFolderArgumentPrefix := '-L'.
	importLibraryArgumentPrefix := '-l'.
	importLibraryArgumentSuffix := ''.
	includeDirectoryArgumentPrefix := '-I'.
]

{ #category : #testing }
WBTUnixStyleCommandLineToolChain >> isUnixStyle [
	^ true
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> ld [
	^ ld
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> ld: anObject [
	ld := anObject
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> objcopy [
	^ objcopy
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> objcopy: anObject [
	objcopy := anObject
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> rpathLocalLinkerArgument [
	^ rpathLocalLinkerArgument
]

{ #category : #accessing }
WBTUnixStyleCommandLineToolChain >> rpathLocalLinkerArgument: anObject [
	rpathLocalLinkerArgument := anObject
]

{ #category : #initialization }
WBTUnixStyleCommandLineToolChain >> setForClang [
	self setForUnixCommon.
	cc := 'clang'.
	cxx := 'clang++'
]

{ #category : #initialization }
WBTUnixStyleCommandLineToolChain >> setForGCC [
	self setForUnixCommon.
	cc := 'gcc'.
	cxx := 'g++'
]

{ #category : #initialization }
WBTUnixStyleCommandLineToolChain >> setForUnixCommon [
	ld := 'ld'.
	ar := 'ar'.
	objcopy := 'objcopy'.
]

{ #category : #initialization }
WBTUnixStyleCommandLineToolChain >> setForWindowsClang [
	cc := 'clang.exe'.
	cxx := 'clang++.exe'.
]

{ #category : #'as yet unclassified' }
WBTUnixStyleCommandLineToolChain >> substitutionVariables [
	^ super substitutionVariables , {
		#WBT_C_DEBUG_FLAGS . '-g'.
		#WBT_C_MINSIZE_FLAGS . '-Os'.
		#WBT_C_RELWITHDEBINFO_FLAGS . '-g -O2'.
		#WBT_C_RELEASE_FLAGS . '-O2'.
	
		#WBT_C_COMPILER . [self cc].
		#WBT_C_COMPILE_OBJECT . '$(WBT_C_COMPILER) $(WBT_C_FLAGS) $(WBT_C_$(WBT_BUILD_TYPE)_FLAGS) $(WBT_C_INCLUDE_DIRECTORIES_FLAGS) -c -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES)'.

		#WBT_C_LINKER . [self ld].
		#WBT_C_LINK_EXECUTABLE . '$(WBT_C_COMPILER) $(WBT_EXECUTABLE_LINKER_FLAGS) -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) $(WBT_LINK_LIBRARIES)'.

		#WBT_CXX_DEBUG_FLAGS . '-g'.
		#WBT_CXX_MINSIZE_FLAGS . '-Os'.
		#WBT_CXX_RELWITHDEBINFO_FLAGS . '-g -O2'.
		#WBT_CXX_RELEASE_FLAGS . '-O2'.

		#WBT_CXX_COMPILER . [self cxx].
		#WBT_CXX_COMPILE_OBJECT . '$(WBT_CXX_COMPILER) $(WBT_CXX_FLAGS) $(WBT_CXX_$(WBT_BUILD_TYPE)_FLAGS) $(WBT_CXX_INCLUDE_DIRECTORIES_FLAGS) -c -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES)'.

		#WBT_CXX_LINKER . [self ld].
		#WBT_CXX_LINK_EXECUTABLE . '$(WBT_CXX_COMPILER) $(WBT_EXECUTABLE_LINKER_FLAGS) -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) $(WBT_LINK_LIBRARIES)'.

		#WBT_STATIC_LINKER . [self ar].

		#WBT_LINK_STATIC_LIBRARY . '$(WBT_STATIC_LINKER) cr $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES)'.
		#WBT_C_LINK_STATIC_LIBRARY . '$(WBT_LINK_STATIC_LIBRARY)'.
		#WBT_CXX_LINK_STATIC_LIBRARY . '$(WBT_LINK_STATIC_LIBRARY)'.

		#WBT_LINK_DYNAMIC_LIBRARY . '$(WBT_C_COMPILER) $(WBT_DYNAMIC_LIBRARY_LINKER_FLAGS) -shared -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) $(WBT_LINK_LIBRARIES)'.
		#WBT_C_LINK_DYNAMIC_LIBRARY . '$(WBT_LINK_STATIC_LIBRARY)'.
		#WBT_CXX_LINK_DYNAMIC_LIBRARY . '$(WBT_CXX_COMPILER) $(WBT_DYNAMIC_LIBRARY_LINKER_FLAGS) -shared -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) $(WBT_LINK_LIBRARIES)'.
	 }
]
