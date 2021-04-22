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
	cc := self class clangProgram.
	cxx := self class clangppProgram.
	ld := self class lldProgram.
]

{ #category : #initialization }
WBTUnixStyleCommandLineToolChain >> setForEmscripten [
	super setForEmscripten.
	ar := 'emar'.
	cc := 'emcc'.
	cxx := 'em++'.
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
		#WBT_C_FLAGS . '-Wall -Wextra -fdata-sections -ffunction-sections'.
		#WBT_CXX_FLAGS . '-Wall -Wextra -fdata-sections -ffunction-sections'.
		#WBT_CXX_STANDARD_FLAGS . '-std=c++17'.

		#WBT_C_DEBUG_FLAGS . '-g'.
		#WBT_CXX_DEBUG_FLAGS . '-g'.
		#WBT_C_ASSERT_FLAGS . '-g -O2'.
		#WBT_CXX_ASSERT_FLAGS . '-g -O2'.
		#WBT_C_MINSIZE_FLAGS . '-Os'.
		#WBT_CXX_MINSIZE_FLAGS . '-Os'.
		#WBT_C_RELWITHDEBINFO_FLAGS . '-g -O2'.
		#WBT_CXX_RELWITHDEBINFO_FLAGS . '-g -O2'.
		#WBT_C_RELEASE_FLAGS . '-O2'.
		#WBT_CXX_RELEASE_FLAGS . '-O2'.

		#WBT_C_PIC_YES_FLAG . '-fPIC'.
		#WBT_CXX_PIC_YES_FLAG . '-fPIC'.

		#WBT_C_TARGET_PIC_FLAG . '$(WBT_C_PIC_$(WBT_POSITION_INDEPENDENT_CODE_ENABLED)_FLAG)'.
		#WBT_CXX_TARGET_PIC_FLAG . '$(WBT_CXX_PIC_$(WBT_POSITION_INDEPENDENT_CODE_ENABLED)_FLAG)'.

		#WBT_C_ACTIVE_FLAGS . '$(WBT_C_FLAGS) $(WBT_C_$(WBT_BUILD_MODE)_FLAGS) $(WBT_C_TARGET_PIC_FLAG)  $(WBT_C_INCLUDE_DIRECTORIES_FLAGS)'.
		#WBT_CXX_ACTIVE_FLAGS . '$(WBT_CXX_STANDARD_FLAGS) $(WBT_CXX_FLAGS) $(WBT_CXX_$(WBT_BUILD_MODE)_FLAGS) $(WBT_CXX_TARGET_PIC_FLAG) $(WBT_CXX_INCLUDE_DIRECTORIES_FLAGS)'.
	
		#WBT_C_COMPILER . [self cc].
		#WBT_CXX_COMPILER . [self cxx].

		#WBT_C_COMPILE_OBJECT . '$(WBT_C_COMPILER) $(WBT_C_ACTIVE_FLAGS) -c -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES)'.
		#WBT_CXX_COMPILE_OBJECT . '$(WBT_CXX_COMPILER) $(WBT_CXX_ACTIVE_FLAGS) -c -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES)'.

		#WBT_C_LINKER . [self ld].
		#WBT_CXX_LINKER . [self ld].

		#WBT_EXECUTABLE_LINKER_FLAGS . Smalltalk platform isMacOSX
			ifTrue: ['-Wl,-dead_strip']
			ifFalse: ['-Wl,--gc-sections'].

		#WBT_C_LINK_EXECUTABLE . '$(WBT_C_COMPILER) $(WBT_EXECUTABLE_LINKER_FLAGS) -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) $(WBT_LINK_LIBRARIES)'.
		#WBT_CXX_LINK_EXECUTABLE . '$(WBT_CXX_COMPILER) $(WBT_EXECUTABLE_LINKER_FLAGS) -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) $(WBT_LINK_LIBRARIES)'.

		#WBT_STATIC_LINKER . [self ar].

		#WBT_LINK_STATIC_LIBRARY . '$(WBT_STATIC_LINKER) cr $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES)'.
		#WBT_C_LINK_STATIC_LIBRARY . '$(WBT_LINK_STATIC_LIBRARY)'.
		#WBT_CXX_LINK_STATIC_LIBRARY . '$(WBT_LINK_STATIC_LIBRARY)'.

		#WBT_LINK_DYNAMIC_LIBRARY . '$(WBT_C_COMPILER) $(WBT_DYNAMIC_LIBRARY_LINKER_FLAGS) -shared -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) $(WBT_LINK_LIBRARIES)'.
		#WBT_C_LINK_DYNAMIC_LIBRARY . '$(WBT_LINK_DYNAMIC_LIBRARY)'.
		#WBT_CXX_LINK_DYNAMIC_LIBRARY . '$(WBT_CXX_COMPILER) $(WBT_DYNAMIC_LIBRARY_LINKER_FLAGS) -shared -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) $(WBT_LINK_LIBRARIES)'.
	 }
]
