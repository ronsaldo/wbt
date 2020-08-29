Class {
	#name : #BaselineOfWBT,
	#superclass : #BaselineOf,
	#category : #BaselineOfWBT
}

{ #category : #baselines }
BaselineOfWBT >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec
			package: #'WBT-Core'.
		spec
			package: #'WBT-Core-Tests' with: [
				spec requires: #(#'WBT-Core')
			].
	].
]
