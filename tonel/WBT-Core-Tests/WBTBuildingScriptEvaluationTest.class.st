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

{ #category : #accessing }
WBTBuildingScriptEvaluationTest class >> defaultTimeLimit [
	^ 2 minutes
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
		buildDirectory: self wbtBuildDirectory

]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> tearDown [
	self class cleanUpTestingArtifacts ifTrue: [ 
		self wbtTestParentDirectory ensureDeleteAll
	].

]

{ #category : #running }
WBTBuildingScriptEvaluationTest >> wbtBuildDirectory [
	^ self wbtTestDirectory
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
	^ buildEnvironment addPackageNamed: #Root inFolder: self wbtSourceDirectory with: aBlock
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
