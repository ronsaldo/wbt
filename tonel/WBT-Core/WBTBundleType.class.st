Class {
	#name : #WBTBundleType,
	#superclass : #WBTObject,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WBT-Core-Bundles'
}

{ #category : #accessing }
WBTBundleType class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'as yet unclassified' }
WBTBundleType >> selectBuildActionsFor: bundleTarget [
	"This takes care of selecting the bundle build actions."
]
