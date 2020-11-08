Class {
	#name : #WBTObjectFileLanguage,
	#superclass : #WBTLanguage,
	#category : #'WBT-Core-Language'
}

{ #category : #'as yet unclassified' }
WBTObjectFileLanguage >> handlesFileExtension: extension [
	^ #(o obj) includes: extension
]

{ #category : #testing }
WBTObjectFileLanguage >> isObjectFile [
	^ true
]

{ #category : #'as yet unclassified' }
WBTObjectFileLanguage >> linkPriority [
	^ 1
]
