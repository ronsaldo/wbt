Class {
	#name : #WBTAssemblyLanguage,
	#superclass : #WBTBatchCompilationBasedSourceLanguage,
	#category : #'WBT-Core-Language'
}

{ #category : #testing }
WBTAssemblyLanguage class >> isSupported [
	^ true
]

{ #category : #'as yet unclassified' }
WBTAssemblyLanguage >> buildActionCommand [
	^ '$(WBT_ASM_COMPILE_OBJECT)'
]

{ #category : #'as yet unclassified' }
WBTAssemblyLanguage >> handlesFileExtension: extension [
	^ #(s asm) includes: extension
]
