Class {
	#name : #WBTBuildingScriptEvaluationTest,
	#superclass : #TestCase,
	#instVars : [
		'buildEnvironment'
	],
	#classVars : [
		'CleanUpTestingArtifacts'
	],
	#category : #'WBT-Core-Tests'
}

{ #category : #'as yet unclassified' }
WBTBuildingScriptEvaluationTest class >> cleanUpTestingArtifacts [
	^ CleanUpTestingArtifacts ifNil: [ CleanUpTestingArtifacts := true ]
]

{ #category : #'as yet unclassified' }
WBTBuildingScriptEvaluationTest class >> cleanUpTestingArtifacts: aBoolean [
	CleanUpTestingArtifacts := aBoolean
]

{ #category : #'as yet unclassified' }
WBTBuildingScriptEvaluationTest class >> disableTestingArtifactCleanUp [
	<script>
	self cleanUpTestingArtifacts: false
]

{ #category : #'as yet unclassified' }
WBTBuildingScriptEvaluationTest class >> enableTestingArtifactCleanUp [
	<script>
	self cleanUpTestingArtifacts: true
]

{ #category : #testing }
WBTBuildingScriptEvaluationTest class >> isAbstract [
	^ self == WBTBuildingScriptEvaluationTest
]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> setUp [
	"We must alawys clean the test directory at the beginning."
	self wbtTestDirectory ensureDeleteAll.

	self wbtSourceDirectory ensureCreateDirectory.
	buildEnvironment := WBTBuildEnvironment forCurrentPlatform.
	buildEnvironment
		buildObjectDirectory: self wbtBuildObjectDirectory;
		buildOutputDirectory: self wbtBuildOutputDirectory.

]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> tearDown [
	self class cleanUpTestingArtifacts ifTrue: [ 
		self wbtTestParentDirectory ensureDeleteAll
	].

]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> wbtBuildObjectDirectory [
	^ self wbtTestDirectory / 'obj'
]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> wbtBuildOutputDirectory [
	^ self wbtTestDirectory / 'out'
]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> wbtIncludeDirectory [
	^ self wbtTestDirectory / 'include'
]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> wbtObjectBuildDirectory [
	^ self wbtTestDirectory / 'obj'
]

{ #category : #'as yet unclassified' }
WBTBuildingScriptEvaluationTest >> wbtScriptWith: aBlock [
	^ buildEnvironment buildPackageNamed: #Root inFolder: self wbtSourceDirectory withBlock: aBlock
]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> wbtSourceDirectory [
	^ self wbtTestDirectory / 'source'
]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> wbtTestClassDirectory [
	^ self wbtTestParentDirectory / self class name
]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> wbtTestDirectory [
	^ self wbtTestClassDirectory / self wbtTestName
]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> wbtTestName [
	^ testSelector
]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> wbtTestParentDirectory [
	^ FileSystem workingDirectory / 'wbt-test'
]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> writeIncludeFileNamed: fileName text: sourceText [
	| sourceFileReference |
	sourceFileReference := (self wbtIncludeDirectory resolve: fileName asFileReference) asAbsolute.
	sourceFileReference parent ensureCreateDirectory.
	sourceFileReference writeStreamDo: [ :out |
		out truncate.
		out nextPutAll: sourceText withPlatformSpecificLineEndings
	]
]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> writeSourceFileNamed: fileName text: sourceText [
	| sourceFileReference |
	sourceFileReference := (self wbtSourceDirectory resolve: fileName asFileReference) asAbsolute.
	sourceFileReference parent ensureCreateDirectory.
	sourceFileReference writeStreamDo: [ :out |
		out truncate.
		out nextPutAll: sourceText withPlatformSpecificLineEndings
	]
]
