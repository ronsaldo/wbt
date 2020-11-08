Extension { #name : #Object }

{ #category : #'*WBT-Core' }
Object >> asWBTVarSubstitution [
	^ self asString asWBTVarSubstitution
]

{ #category : #'*WBT-Core' }
Object >> evaluateMatchedPatternElement: matchedElement [
	^ self
]

{ #category : #'*WBT-Core' }
Object >> matchesPatternElement: matchedElement [
	^ matchedElement = self
]

{ #category : #'*WBT-Core' }
Object >> selectCase: cases [
	cases do: [ :each |
		(each matchesSelectCaseFor: self) ifTrue: [
			^ each evaluateMatchedSelectCaseWith: self
		]
	].

	self error: 'Pattern not found.'
]
