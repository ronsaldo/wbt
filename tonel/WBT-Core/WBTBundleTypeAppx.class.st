Class {
	#name : #WBTBundleTypeAppx,
	#superclass : #WBTBundleType,
	#category : #'WBT-Core-Bundles'
}

{ #category : #'as yet unclassified' }
WBTBundleTypeAppx >> appxmanifestTemplate [
	^ '<?xml version="1.0" encoding="utf-8"?>

<Package
  xmlns="http://schemas.microsoft.com/appx/manifest/foundation/windows10"
  xmlns:mp="http://schemas.microsoft.com/appx/2014/phone/manifest"
  xmlns:uap="http://schemas.microsoft.com/appx/manifest/uap/windows10"
  IgnorableNamespaces="uap mp">

  <Identity
    Name="$(APP_NAME)"
    Publisher="$(APP_PUBLISHER)"
    Version="$(APP_VERSION)"
	ProcessorArchitecture="x64" />

  <mp:PhoneIdentity PhoneProductId="$(APP_UUID)" PhonePublisherId="$(APP_PUBLISHER_ID)"/>

  <Properties>
    <DisplayName>$(APP_DISPLAY_NAME)</DisplayName>
    <PublisherDisplayName>$(APP_PUBLISHER_DISPLAY_NAME)</PublisherDisplayName>
    <Logo>Assets\StoreLogo.png</Logo>
  </Properties>

  <Dependencies>
    <TargetDeviceFamily Name="Windows.Universal" MinVersion="10.0.0.0" MaxVersionTested="10.0.0.0" />
    <PackageDependency Name="Microsoft.VCLibs.140.00" MinVersion="14.0.27810.0" Publisher="CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US" />
  </Dependencies>

  <Resources>
    <Resource Language="en-US"/>
  </Resources>

  <Applications>
    <Application Id="App"
      Executable="$(APP_EXECUTABLE)"
      EntryPoint="$(APP_ENTRY_POINT)">
      <uap:VisualElements
        DisplayName="$(APP_DISPLAY_NAME)"
        Square150x150Logo="Assets\Square150x150Logo.png"
        Square44x44Logo="Assets\Square44x44Logo.png"
        Description="$(APP_PUBLISHER_DISPLAY_NAME)"
        BackgroundColor="transparent">
        <uap:DefaultTile Wide310x150Logo="Assets\Wide310x150Logo.png"/>
        <uap:SplashScreen Image="Assets\SplashScreen.png" />
      </uap:VisualElements>
    </Application>
  </Applications>

  <Capabilities>
    <Capability Name="internetClient" />
  </Capabilities>
</Package>
'
]

{ #category : #'as yet unclassified' }
WBTBundleTypeAppx >> baseLogo [
	| logo font |
	logo := Form extent: 32@32 depth: 32.
	font := LogicalFont familyName: 'DaejaVu' pointSize: 12.
	logo getCanvas drawString: 'WBT' at: 5@8 font: font color: Color orange.
	^ logo
]

{ #category : #'as yet unclassified' }
WBTBundleTypeAppx >> copiedResourcesDestinationFor: bundleTarget [
	^ bundleTarget buildEnvironment validBuildBundleTempDirectory / bundleTarget name / 'Assets'
]

{ #category : #'as yet unclassified' }
WBTBundleTypeAppx >> copyUsedResourcesFor: bundleTarget [
	| resourcesDestination copiedProgram copiedProgramFiles bundleProgramDirectory |
	resourcesDestination := self copiedResourcesDestinationFor: bundleTarget.

	"Make sure the dependencies are already solved"
	bundleTarget program withSortedDependencies.

	copiedProgramFiles := OrderedCollection new.
	bundleProgramDirectory := bundleTarget buildEnvironment validBuildBundleTempDirectory / bundleTarget program name.
	copiedProgram := bundleTarget program makeInstallIntoTarget: bundleProgramDirectory / (bundleTarget program name , '.exe').
	copiedProgramFiles add: copiedProgram.
	
	bundleTarget program allLinkLibrariesRecursively do: [ :each |
		each isDynamicLibrary ifTrue: [
			self halt
		].
	
		each isImportedLibrary ifTrue: [
			each binaryInstallTargets do: [ :binaryInstallTarget |
				| copiedLibrary |
				copiedLibrary := binaryInstallTarget makeInstallIntoTarget: (bundleProgramDirectory resolve: binaryInstallTarget relativeFileReference).
				copiedProgramFiles add: copiedLibrary.
			]
		]
	].
	
	bundleTarget buildEnvironment hasBuildModeWithDebugInformation ifTrue: [ 
		| targetPDB targetPDBFileReference |
		targetPDBFileReference := bundleTarget buildEnvironment validBuildBundleTempDirectory / bundleTarget program name / (bundleTarget program name , '.pdb').

		targetPDB := WBTFileTarget for: targetPDBFileReference.
		bundleTarget package addElement: targetPDB.
		targetPDB addDependency: bundleTarget program.
		copiedProgramFiles add: targetPDB.

		targetPDB addBuildAction: (WBTInstallFileBuildAction new
			sourceFileReference: (bundleTarget program asFileReference parent / (bundleTarget program name , '.pdb'));
			destFileReference: targetPDBFileReference;
			optional: true;
			yourself).
	].

	^ copiedProgramFiles , (bundleTarget program allResourcesRecursively collect: [ :each |
		| resourcesRelativePath |
		resourcesRelativePath := each fileReference relativeTo: bundleTarget buildEnvironment validBuildResourcesDirectory.
		each makeInstallIntoTarget: (resourcesDestination resolve: resourcesRelativePath).
	]).
]

{ #category : #'as yet unclassified' }
WBTBundleTypeAppx >> generateAppxFor: bundleTarget pri: pri appxManifest: packageManifest mappingsFile: mappingsFile signCertificate: signCertificate [
	| appxTarget |
	appxTarget := WBTFileTarget for: bundleTarget buildEnvironment validBuildBundleDirectory / (bundleTarget name , '.appx').
	appxTarget
		addDependency: pri;
		addDependency: packageManifest.
	bundleTarget package addElement: appxTarget.

	appxTarget
		addDependency: pri;
		addCommandLineCommandBuildAction: '$(WBT_MAKE_APPX_PACKAGE)' inputFiles: { packageManifest } variables: {
			#WBT_MAPPINGS_FILE . mappingsFile
		};
		addCommandLineCommandBuildAction: '$(WBT_SIGN_APPX)' inputFiles: { signCertificate } variables: {
			#WBT_CERT_PASSWORD . bundleTarget uwpCertificatePassword
		}.
	bundleTarget addDependency: appxTarget.

]

{ #category : #'as yet unclassified' }
WBTBundleTypeAppx >> generateLogoFor: bundleTarget name: name extent: extent [
	| destination scaledLogo |
	destination := (self copiedResourcesDestinationFor: bundleTarget) / name.
	destination exists ifFalse: [ 
		destination parent ensureCreateDirectory.
		scaledLogo := self baseLogo scaledToSize: extent.
		PNGReadWriter putForm: scaledLogo onFileNamed: destination.
	].
	^ WBTFileTarget for: destination
]

{ #category : #'as yet unclassified' }
WBTBundleTypeAppx >> generateLogosFor: bundleTarget [
	^ #(
		('Square150x150Logo.png' (150 150))
		('Square44x44Logo.png' (44 44))
		('SplashScreen.png' (200 200))
		('StoreLogo.png' (50 50))
		('Wide310x150Logo.png' (315 150))
	) collect: [ :each |
		self generateLogoFor: bundleTarget name: each first extent: each second first @ each second second
	]
	
]

{ #category : #'as yet unclassified' }
WBTBundleTypeAppx >> generateMappingsFileFor: bundleTarget assets: assets [
	| assetsBaseDirectory mappingsFileContent mappingsFileReference mappingsFile |
	assetsBaseDirectory := bundleTarget buildEnvironment validBuildBundleTempDirectory / bundleTarget name.
	mappingsFileContent := (ByteString streamContents: [:out |
		out nextPutAll:
'
[ResourceMetadata]
"ResourceDimensions"                    "language-en-us"
"ResourceId"                            "English"

[Files]
'.
		assets do: [ :each |
			out nextPut: $"; nextPutAll: each asFileReference asWBTVarSubstitution; nextPut: $";
				tab; nextPut: $"; nextPutAll: (each asFileReference relativeTo: assetsBaseDirectory) fullName; nextPut: $"; cr
		]
	]) withInternetLineEndings.

	mappingsFileReference := bundleTarget buildEnvironment validBuildBundleTempDirectory / (bundleTarget name , '-Mappings.txt').
	mappingsFile := bundleTarget buildEnvironment configurationFileTargetFor: mappingsFileReference withContent: mappingsFileContent.
	bundleTarget addDependency: mappingsFile.
	^ mappingsFile
]

{ #category : #'as yet unclassified' }
WBTBundleTypeAppx >> generatePRIFor: bundleTarget withDependencies: dependencies [
	| priConfigTarget resourcesPriTarget packagingRoot |
	packagingRoot := bundleTarget buildEnvironment validBuildBundleTempDirectory / bundleTarget name.
	priConfigTarget := WBTFileTarget for: (packagingRoot / 'priconfig.xml').
	bundleTarget package addElement: priConfigTarget.
	priConfigTarget
		addDependencies: dependencies;
		addCommandLineCommandBuildAction: '$(WBT_MAKE_PRI_CONFIG)' workingDirectory: packagingRoot.

	resourcesPriTarget := WBTFileTarget for: (bundleTarget buildEnvironment validBuildBundleTempDirectory / bundleTarget name / 'resources.pri').
	bundleTarget package addElement: resourcesPriTarget.
	resourcesPriTarget
		addDependency: priConfigTarget;
		addCommandLineCommandBuildAction: '$(WBT_MAKE_RESOURCES_PRI)' inputFiles: {priConfigTarget} variables: {
			#WBT_PACKAGE_FOLDER . packagingRoot
		} workingDirectory: packagingRoot.
	bundleTarget addDependency: resourcesPriTarget.
	^ resourcesPriTarget
]

{ #category : #'as yet unclassified' }
WBTBundleTypeAppx >> generatePackageManifestContentFor: bundleTarget [
	| copiedResourcesDestination appxmanifestTemplate |
	copiedResourcesDestination := self copiedResourcesDestinationFor: bundleTarget.
	copiedResourcesDestination ensureCreateDirectory.
	appxmanifestTemplate := self appxmanifestTemplate.
		
	^ appxmanifestTemplate wbtSubstituteVariables: (Dictionary newFromPairs: {
		#APP_NAME . bundleTarget uwpApplicationName.
		#APP_UUID . bundleTarget uwpApplicationUUID.
		#APP_PUBLISHER . bundleTarget uwpPublisher.
		#APP_VERSION . bundleTarget uwpVersion.
		#APP_PUBLISHER_ID . bundleTarget uwpPublisherID.
		#APP_DISPLAY_NAME . bundleTarget uwpApplicationDisplayName.
		#APP_PUBLISHER_DISPLAY_NAME . bundleTarget uwpPublisherDisplayName.
		#APP_EXECUTABLE . bundleTarget program name , '.exe'.
		#APP_ENTRY_POINT . bundleTarget uwpEntryPoint.
	})
]

{ #category : #'as yet unclassified' }
WBTBundleTypeAppx >> generatePackageManifestFor: bundleTarget [
	| manifestFileReference manifestFile |
	manifestFileReference := bundleTarget buildEnvironment validBuildBundleTempDirectory / bundleTarget name / 'AppxManifest.xml'.
	manifestFile := bundleTarget buildEnvironment configurationFileTargetFor: manifestFileReference withContent: (self generatePackageManifestContentFor: bundleTarget) withInternetLineEndings.
	bundleTarget addDependency: manifestFile.
	^ manifestFile
]

{ #category : #'as yet unclassified' }
WBTBundleTypeAppx >> generateSelfSignedCertificateFor: bundleTarget [
	| signingCertificateFileReference certificateTarget |
	signingCertificateFileReference := bundleTarget buildEnvironment validBuildBundleDirectory / (bundleTarget name , '.pfx').
	certificateTarget := (WBTFileTarget for: signingCertificateFileReference)
		addBuildAction: (WBTNewWindowsSelfSignedCertificateBuildAction new
			fileReference: signingCertificateFileReference;
			subject: bundleTarget uwpPublisher;
			friendlyName: bundleTarget uwpCertificateFriendlyName;
			password: bundleTarget uwpCertificatePassword;
			yourself).
	bundleTarget package addElement: certificateTarget.
	bundleTarget addDependency: certificateTarget.
	^ certificateTarget
]

{ #category : #'as yet unclassified' }
WBTBundleTypeAppx >> selectBuildActionsFor: bundleTarget [
	| packageManifest logos copiedResources pri mappingsFile signCertificate |
	logos := self generateLogosFor: bundleTarget.
	copiedResources := self copyUsedResourcesFor: bundleTarget.
	packageManifest := self generatePackageManifestFor: bundleTarget.
	pri := self generatePRIFor: bundleTarget withDependencies: logos , copiedResources , { packageManifest }.
	mappingsFile := self generateMappingsFileFor: bundleTarget assets: logos , copiedResources , { pri }.
	signCertificate := self generateSelfSignedCertificateFor: bundleTarget.
	self generateAppxFor: bundleTarget pri: pri appxManifest: packageManifest mappingsFile: mappingsFile signCertificate: signCertificate

]
