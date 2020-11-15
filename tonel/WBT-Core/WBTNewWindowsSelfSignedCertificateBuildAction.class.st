Class {
	#name : #WBTNewWindowsSelfSignedCertificateBuildAction,
	#superclass : #WBTBuildAction,
	#instVars : [
		'fileReference',
		'subject',
		'password',
		'friendlyName'
	],
	#category : #'WBT-Core-Actions'
}

{ #category : #execution }
WBTNewWindowsSelfSignedCertificateBuildAction >> execute [
	| script powershellScriptReference command |
	script := ('
$ErrorActionPreference = "Stop"

$cert = New-SelfSignedCertificate -Type Custom -Subject "$(SUBJECT)" -KeyUsage DigitalSignature -FriendlyName "$(FRIENDLY_NAME)" -CertStoreLocation "Cert:\CurrentUser\My" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")

$password = ConvertTo-SecureString -String "$(PASSWORD)" -Force -AsPlainText
Export-PfxCertificate -Cert $cert -FilePath $(DEST) -Password $password
Export-Certificate -Cert $cert -FilePath $(EXPORTED)
' wbtSubstituteVariables: (Dictionary newFromPairs: {
	#SUBJECT . subject.
	#PASSWORD . password.
	#FRIENDLY_NAME . friendlyName.
	#DEST . fileReference .
	#EXPORTED . fileReference parent / (fileReference basenameWithoutExtension , '.cer')
})) withInternetLineEndings.
	powershellScriptReference := fileReference parent / (fileReference basename , '.ps1').
	powershellScriptReference writeStreamDo: [ :out |
		out truncate; nextPutAll: script
	].

	command := 'PowerShell.exe -ExecutionPolicy Bypass -File "' , powershellScriptReference asWBTVarSubstitution, '"'.
	powershellScriptReference ensureDelete.
	^ (self buildEnvironment executeCommandLineCommand: command) = 0
]

{ #category : #accessing }
WBTNewWindowsSelfSignedCertificateBuildAction >> fileReference [
	^ fileReference
]

{ #category : #accessing }
WBTNewWindowsSelfSignedCertificateBuildAction >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #accessing }
WBTNewWindowsSelfSignedCertificateBuildAction >> friendlyName [
	^ friendlyName
]

{ #category : #accessing }
WBTNewWindowsSelfSignedCertificateBuildAction >> friendlyName: anObject [
	friendlyName := anObject
]

{ #category : #accessing }
WBTNewWindowsSelfSignedCertificateBuildAction >> password [
	^ password
]

{ #category : #accessing }
WBTNewWindowsSelfSignedCertificateBuildAction >> password: anObject [
	password := anObject
]

{ #category : #accessing }
WBTNewWindowsSelfSignedCertificateBuildAction >> subject [
	^ subject
]

{ #category : #accessing }
WBTNewWindowsSelfSignedCertificateBuildAction >> subject: anObject [
	subject := anObject
]
