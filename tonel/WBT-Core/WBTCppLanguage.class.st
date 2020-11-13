Class {
	#name : #WBTCppLanguage,
	#superclass : #WBTBatchCompilationBasedSourceLanguage,
	#category : #'WBT-Core-Language'
}

{ #category : #testing }
WBTCppLanguage class >> isSupported [
	^ true
]

{ #category : #'as yet unclassified' }
WBTCppLanguage >> buildActionCommand [
	^ '$(WBT_CXX_COMPILE_OBJECT)'
]

{ #category : #'as yet unclassified' }
WBTCppLanguage >> handlesFileExtension: extension [
	^ #(cc cpp c++) includes: extension
]

{ #category : #'as yet unclassified' }
WBTCppLanguage >> linkDynamicLibraryCommand [
	^ '$(WBT_CXX_LINK_DYNAMIC_LIBRARY)'
]

{ #category : #'as yet unclassified' }
WBTCppLanguage >> linkExecutableCommand [
	^ '$(WBT_CXX_LINK_EXECUTABLE)'
]

{ #category : #'as yet unclassified' }
WBTCppLanguage >> linkPriority [
	^ 3
]

{ #category : #'as yet unclassified' }
WBTCppLanguage >> linkStaticLibraryCommand [
	^ '$(WBT_CXX_LINK_STATIC_LIBRARY)'
]
