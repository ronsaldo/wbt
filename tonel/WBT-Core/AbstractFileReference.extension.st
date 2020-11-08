Extension { #name : #AbstractFileReference }

{ #category : #'*WBT-Core' }
AbstractFileReference >> asWBTVarSubstitution [
	^ self fullName asWBTEscapedVarSubstitution
]
