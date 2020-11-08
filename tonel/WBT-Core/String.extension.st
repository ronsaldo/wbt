Extension { #name : #String }

{ #category : #'*WBT-Core' }
String >> asWBTEscapedVarSubstitution [
	Smalltalk platform isWindows ifTrue: [ 
		^ (self includes: Character space)
			ifTrue: [ '"' , self , '"' ]
			ifFalse: [ self ]
	].
	(self includesAnyOf: ' "\') ifFalse: [ ^ self ].
	^ ByteString streamContents: [ :out |
		out nextPut: $".
		self do: [ :each |
			('"\' includes: each) ifTrue: [ 
				out nextPut: $\.
			].
		
			out nextPut: each
		].
		out nextPut: $".
	].

]

{ #category : #'*WBT-Core' }
String >> asWBTVarSubstitution [
	^ self
]

{ #category : #'*WBT-Core' }
String >> wbtSubstituteVariablesWith: aSubstitutionBlock [
	| regex shouldContinue result |
	regex := '\$\(\w*\)' asRegex.
	shouldContinue := true.
	result := self.
	[ shouldContinue ] whileTrue: [
		shouldContinue := false.
		result := regex copy: result translatingMatchesUsing: [:varExpression |
			shouldContinue := true.
			aSubstitutionBlock value: (varExpression copyFrom: 3 to: varExpression size - 1)
		]
	].

	^ result  
]

{ #category : #'*WBT-Core' }
String >> withPlatformSpecificLineEndings [
	^ Smalltalk os isWindows
		ifTrue: [ self withInternetLineEndings ]
		ifFalse: [ self withUnixLineEndings ]
]
