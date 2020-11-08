Class {
	#name : #WBTProgramBuildingScriptEvaluationTest,
	#superclass : #WBTBuildingScriptEvaluationTest,
	#category : #'WBT-Core-Tests'
}

{ #category : #tests }
WBTProgramBuildingScriptEvaluationTest >> testHelloWorldC [
	| programModule rootPackage sortedDependencies |
	self
		writeSourceFileNamed: 'hello.c' text: '
#include <stdio.h>

int main(int argc, const char *argv[])
{
	printf("Hello World\n");
	return 0;
}
'.
	rootPackage := self wbtScriptWith: [:script |
		programModule := script
			program: 'hello' with: [ :prog |
				prog
					source: 'hello.c'
			].
			
		self assert: programModule sources size equals: 1.
		self assert: programModule sources first relativeFileReference equals: 'hello.c' asFileReference.

		self assert: programModule intermediateObjectFiles size equals: 1.
		self assert: programModule intermediateObjectFiles first fileReference basename equals: (buildEnvironment platform formatObjectFileName: 'hello.c')
	].

	self assert: rootPackage mainElements size equals: 1.
	sortedDependencies := rootPackage withTopologicalSortedDependencies.
	self assert: (sortedDependencies collect: [ :each | each name ] as: Array) equals:
	{ 'hello.c' .
		(buildEnvironment platform formatObjectFileName: 'hello.c') . 'hello' .
		#Root
	}.
	self assert: rootPackage runBuildActions.
	self assert: programModule executeAndReadStdout equals: ('Hello World' , String lf).
	
]

{ #category : #tests }
WBTProgramBuildingScriptEvaluationTest >> testHelloWorldCPP [
	| programModule rootPackage sortedDependencies |
	self
		writeSourceFileNamed: 'hello.cpp' text: '
#include <iostream>

int main(int argc, const char *argv[])
{
	std::cout << "Hello World" << std::endl;
	return 0;
}
'.
	rootPackage := self wbtScriptWith: [:script |
		programModule := script
			program: 'hello' with: [ :prog |
				prog
					source: 'hello.cpp'
			].
			
		self assert: programModule sources size equals: 1.
		self assert: programModule sources first relativeFileReference equals: 'hello.cpp' asFileReference.

		self assert: programModule intermediateObjectFiles size equals: 1.
		self assert: programModule intermediateObjectFiles first fileReference basename equals: (buildEnvironment platform formatObjectFileName: 'hello.cpp')
	].

	self assert: rootPackage mainElements size equals: 1.
	sortedDependencies := rootPackage withTopologicalSortedDependencies.
	self assert: (sortedDependencies collect: [ :each | each name ] as: Array) equals:
	{ 'hello.cpp' .
		(buildEnvironment platform formatObjectFileName: 'hello.cpp') . 'hello' .
		#Root
	}.
	self assert: rootPackage runBuildActions.
	self assert: programModule executeAndReadStdout equals: ('Hello World' , String lf).
]
