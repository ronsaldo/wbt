Extension { #name : #UUID }

{ #category : #'*WBT-Core' }
UUID >> asWBTVarSubstitution [
	^ self asString
]

{ #category : #'*WBT-Core' }
UUID class >> forNamespace: uuidNamespace name: uuidName [
	| hash result |
	hash := SHA1 hashMessage: (uuidNamespace as: ByteArray) , uuidName utf8Encoded.
	result := self new.
	1 to: 16 do: [ :i | result at: i put: (hash at: i) ].
	"Version 5. SHA1 name based."
	result at: 7 put: ((result at: 7) & 2r1111 | (5 << 4)).

	"Variant 10"
	result at: 9 put: ((result at: 9) & 2r111111 | 2r10000000).
	
	^ result
]

{ #category : #'*WBT-Core' }
UUID class >> forWbtName: uuidName [
	^ self forNamespace: (self fromString: '7a6049b5-8870-0d00-aebb-345f05f0abb3') name: uuidName
]
