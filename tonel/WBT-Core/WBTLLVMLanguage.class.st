Class {
	#name : #WBTLLVMLanguage,
	#superclass : #WBTBatchCompilationBasedLanguage,
	#category : #'WBT-Core-Language'
}

{ #category : #testing }
WBTLLVMLanguage class >> isSupported [
	^ true
]

{ #category : #'as yet unclassified' }
WBTLLVMLanguage >> buildActionCommand [
	^ '$(WBT_LLVM_COMPILE_OBJECT)'
]

{ #category : #'as yet unclassified' }
WBTLLVMLanguage >> handlesFileExtension: aFileExtension [
	^ #(ll bc) includes: aFileExtension
]
