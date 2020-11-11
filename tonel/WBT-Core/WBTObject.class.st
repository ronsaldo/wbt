Class {
	#name : #WBTObject,
	#superclass : #Object,
	#instVars : [
		'properties'
	],
	#category : #'WBT-Core-Common'
}

{ #category : #accessing }
WBTObject >> properties [
	^ properties ifNil: [ properties := Dictionary new ]
]

{ #category : #accessing }
WBTObject >> propertyAt: name [
	^ self properties at: name
]

{ #category : #accessing }
WBTObject >> propertyAt: name ifAbsent: absentBlock [
	^ self properties at: name ifAbsent: absentBlock
]

{ #category : #accessing }
WBTObject >> propertyAt: name ifAbsentPut: absentBlock [
	^ self properties at: name ifAbsentPut: absentBlock
]

{ #category : #accessing }
WBTObject >> propertyAt: name put: value [
	^ self properties at: name put: value
]
