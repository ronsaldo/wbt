"
A WBTScriptEnvironmentTest is a test class for testing the behavior of WBTScriptEnvironment
"
Class {
	#name : #WBTScriptEnvironmentTest,
	#superclass : #TestCase,
	#category : #'WBT-Core-Tests'
}

{ #category : #tests }
WBTScriptEnvironmentTest >> testSelectCase [
	self assert: (#hello selectCase: {
		1 -> 1.
		-1 -> 2.
		#hello -> 42.
	}) equals: 42.
	self assert: (#hello selectCase: {
		1 -> 1.
		-1 -> 2.
		[true] -> 42.
	}) equals: 42.
	self assert: (#hello selectCase: {
		1 -> 1.
		-1 -> 2.
		[true] -> [:x | x].
	}) equals: #hello.
	self should: [#hello selectCase: {}] raise: Error.
]
