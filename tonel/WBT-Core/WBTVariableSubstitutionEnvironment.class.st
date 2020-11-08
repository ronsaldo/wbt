Class {
	#name : #WBTVariableSubstitutionEnvironment,
	#superclass : #Object,
	#instVars : [
		'variables',
		'parent'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #requirements }
WBTVariableSubstitutionEnvironment class >> empty [
	^ self new
]

{ #category : #accessing }
WBTVariableSubstitutionEnvironment class >> parent: parent [
	^ self new parent: parent; yourself
]

{ #category : #accessing }
WBTVariableSubstitutionEnvironment class >> parent: parent withVariables: variables [
	^ self new
		parent: parent;
		setVariables: variables;
		yourself
]

{ #category : #'as yet unclassified' }
WBTVariableSubstitutionEnvironment >> evaluateVariableValue: aVariable ifAbsent: absentBlock [
	^ ((self lookVariableValueRecursively: aVariable asUppercase ifAbsent: absentBlock) 		wbtEvaluateSubstitutionVariableInEnvironment: self)
]

{ #category : #initialization }
WBTVariableSubstitutionEnvironment >> initialize [
	super initialize.
	variables := Dictionary new.
]

{ #category : #'as yet unclassified' }
WBTVariableSubstitutionEnvironment >> lookVariableValueRecursively: variableName [
	^ self lookVariableValueRecursively: variableName ifAbsent: [nil]
]

{ #category : #'as yet unclassified' }
WBTVariableSubstitutionEnvironment >> lookVariableValueRecursively: variableName ifAbsent: absentBlock [
	^ variables at: variableName ifAbsent: [
			parent ifNotNil: [ parent lookVariableValueRecursively: variableName ifAbsent: absentBlock ]
				ifNil: [ absentBlock value ]
	]
]

{ #category : #accessing }
WBTVariableSubstitutionEnvironment >> parent [
	^ parent
]

{ #category : #accessing }
WBTVariableSubstitutionEnvironment >> parent: anObject [
	parent := anObject
]

{ #category : #initialization }
WBTVariableSubstitutionEnvironment >> setVariable: name value: value [
	variables at: name asUppercase asSymbol put: value
]

{ #category : #initialization }
WBTVariableSubstitutionEnvironment >> setVariables: newVariables [
	newVariables pairsDo: [ :key :value |
		self setVariable: key value: value
	]
]

{ #category : #'as yet unclassified' }
WBTVariableSubstitutionEnvironment >> substitutionForVariable: aVariable [
	^ (self evaluateVariableValue: aVariable ifAbsent: [nil]) asWBTVarSubstitution
]

{ #category : #accessing }
WBTVariableSubstitutionEnvironment >> variables [
	^ variables
]
