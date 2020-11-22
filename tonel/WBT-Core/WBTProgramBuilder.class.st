Class {
	#name : #WBTProgramBuilder,
	#superclass : #WBTModuleBuilder,
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTProgramBuilder >> createTargetNamed: moduleName [
	^ WBTExecutableProgramTarget new
		name: moduleName;
		yourself
]

{ #category : #initialization }
WBTProgramBuilder >> setForConsole [
	self setWin32ConsoleSubsystem
]

{ #category : #initialization }
WBTProgramBuilder >> setForGUI [
	self setWin32WindowsSubsystem
]

{ #category : #initialization }
WBTProgramBuilder >> setWin32ConsoleSubsystem [
	target win32Subsystem: #CONSOLE
]

{ #category : #initialization }
WBTProgramBuilder >> setWin32WindowsSubsystem [
	target win32Subsystem: #WINDOWS
]
