Class {
	#name : #WBTBundleTarget,
	#superclass : #WBTMainElementTarget,
	#instVars : [
		'program',
		'buildTargetDependencies',
		'bundleType',
		'outputFileReferences'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #adding }
WBTBundleTarget >> addDependency: dependency [
	buildTargetDependencies add: dependency
]

{ #category : #adding }
WBTBundleTarget >> addOutputFileReference: aFileReference [
	outputFileReferences add: aFileReference
]

{ #category : #'as yet unclassified' }
WBTBundleTarget >> buildTargetDependencies [
	^ buildTargetDependencies
]

{ #category : #'as yet unclassified' }
WBTBundleTarget >> bundleType [
	^ bundleType ifNil: [ bundleType := self platform defaultBundleType ]
]

{ #category : #accessing }
WBTBundleTarget >> bundleType: anObject [
	bundleType := anObject
]

{ #category : #initialization }
WBTBundleTarget >> initialize [
	super initialize.
	buildTargetDependencies := OrderedCollection new.
	outputFileReferences := OrderedCollection new.
]

{ #category : #accessing }
WBTBundleTarget >> outputFileReferences [
	^ outputFileReferences
]

{ #category : #accessing }
WBTBundleTarget >> program [
	^ program
]

{ #category : #accessing }
WBTBundleTarget >> program: anObject [
	program := anObject.
]

{ #category : #'as yet unclassified' }
WBTBundleTarget >> selectBuildAction [
	program ifNotNil: [
		self addDependency: (program wbtSolveMainElementInPackage: package)
	].
	self bundleType selectBuildActionsFor: self
]

{ #category : #adding }
WBTBundleTarget >> targetOutputFileReferences [
	^ outputFileReferences
]

{ #category : #uwp }
WBTBundleTarget >> uwpApplicationDisplayName [
	^ self propertyAt: #uwpApplicationDisplayName ifAbsentPut: [ name ]
]

{ #category : #uwp }
WBTBundleTarget >> uwpApplicationName [
	^ self propertyAt: #uwpApplicationName ifAbsentPut: [ 'WBT.' , name ]
]

{ #category : #uwp }
WBTBundleTarget >> uwpApplicationUUID [
	^ self propertyAt: #uwpApplicationUUID ifAbsentPut: [ UUID forWbtName: name ]
]

{ #category : #uwp }
WBTBundleTarget >> uwpCertificateFriendlyName [
	^ self propertyAt: #uwpCertificateFriendlyName ifAbsentPut: [ 'W Build Tool Testing Self Signed Certificate' ]
]

{ #category : #uwp }
WBTBundleTarget >> uwpCertificatePassword [
	^ self propertyAt: #uwpCertificatePassword ifAbsentPut: [ 'wbt-wbt' ]
]

{ #category : #uwp }
WBTBundleTarget >> uwpEntryPoint [
	^ self propertyAt: #uwpEntryPoint ifAbsentPut: [ name , '.App' ]
]

{ #category : #uwp }
WBTBundleTarget >> uwpPublisher [
	^ self propertyAt: #uwpPublisher ifAbsentPut: [ 'CN=WBT' ]
]

{ #category : #uwp }
WBTBundleTarget >> uwpPublisherDisplayName [
	^ self propertyAt: #uwpPublisherDisplayName ifAbsentPut: [ 'W Build Tool' ]
]

{ #category : #uwp }
WBTBundleTarget >> uwpPublisherID [
	^ self propertyAt: #uwpPublisherID ifAbsentPut: [ UUID nilUUID ]
]

{ #category : #uwp }
WBTBundleTarget >> uwpVersion [
	^ self propertyAt: #uwpVersion ifAbsentPut: [ '1.0.0.0' ]
]
