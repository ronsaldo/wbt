Class {
	#name : #WBTCLanguage,
	#superclass : #WBTBatchCompilationBasedSourceLanguage,
	#category : #'WBT-Core-Language'
}

{ #category : #testing }
WBTCLanguage class >> isSupported [
	^ true
]

{ #category : #'as yet unclassified' }
WBTCLanguage >> buildActionCommand [
	^ '$(WBT_C_COMPILE_OBJECT)'
]

{ #category : #'as yet unclassified' }
WBTCLanguage >> handlesFileExtension: aFileExtension [
	^ aFileExtension = 'c'
]
