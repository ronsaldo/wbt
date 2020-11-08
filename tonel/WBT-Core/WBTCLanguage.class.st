Class {
	#name : #WBTCLanguage,
	#superclass : #WBTBatchCompilationBasedLanguage,
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

{ #category : #'as yet unclassified' }
WBTCLanguage >> linkPriority [
	^ 2
]