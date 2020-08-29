Extension { #name : #BlockClosure }

{ #category : #'*WBT-Core' }
BlockClosure >> evaluateMatchedPatternElement: matchedElement [
	^ self cull: matchedElement
]

{ #category : #'*WBT-Core' }
BlockClosure >> matchesPatternElement: matchedElement [
	^ self cull: matchedElement
]
