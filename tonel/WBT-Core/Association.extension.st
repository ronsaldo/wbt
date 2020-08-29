Extension { #name : #Association }

{ #category : #'*WBT-Core' }
Association >> evaluateMatchedSelectCaseWith: matchedElement [
	^ value evaluateMatchedPatternElement: matchedElement
]

{ #category : #'*WBT-Core' }
Association >> matchesSelectCaseFor: matchedElement [
	^ key matchesPatternElement: matchedElement
]
