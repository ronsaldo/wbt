Extension { #name : #Collection }

{ #category : #'*WBT-Core' }
Collection >> asWBTVarSubstitution [
	self ifEmpty: [ ^ '' ].
	
	^ ByteString streamContents: [ :out |
		self doWithIndex: [ :each :index |
			index > 1 ifTrue: [ out space ].
			out nextPutAll: each asWBTVarSubstitution
		]
	]
]
