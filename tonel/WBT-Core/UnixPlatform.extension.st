Extension { #name : #UnixPlatform }

{ #category : #'*WBT-Core' }
UnixPlatform >> wbtPlatform [
	^ WBTPlatform linux
]

{ #category : #'*WBT-Core' }
UnixPlatform >> wbtPlatformWithClang [
	^ WBTPlatform linuxClang
]

{ #category : #'*WBT-Core' }
UnixPlatform >> wbtPlatformWithLLD [
	"HACK: we require linking with clang to avoid having to support -fPIE."
	^ WBTPlatform linuxClang
]
