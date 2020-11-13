Class {
	#name : #WBTCHeaderLanguage,
	#superclass : #WBTBatchCompilationBasedLanguage,
	#category : #'WBT-Core-Language'
}

{ #category : #testing }
WBTCHeaderLanguage class >> isSupported [
	^ true
]

{ #category : #'as yet unclassified' }
WBTCHeaderLanguage >> handlesFileExtension: extension [
	^ #(h hh hpp) includes: extension
]
