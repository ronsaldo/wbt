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
	sortedDependencies := rootPackage withSortedDependencies.
	self assert: (sortedDependencies collect: [ :each | each name ] as: Array) equals:
	{ 'hello.c' .
		(buildEnvironment platform formatObjectFileName: 'hello.c') . 'hello' .
		#Root
	}.
	self assert: rootPackage runBuildActions.
	self assert: programModule executeAndReadStdout equals: ('Hello World' , String lf).
	
]

{ #category : #tests }
WBTProgramBuildingScriptEvaluationTest >> testHelloWorldCDynamicLib [
	| libraryModule programModule rootPackage sortedDependencies |
	self
		writeIncludeFileNamed: 'hello.h' text: '
#ifdef _WIN32
#	ifdef BUILD_HELLO_DLL
#		define DLL_EXPORT __declspec(dllexport)
#	else
#		define DLL_EXPORT __declspec(dllimport)
#	endif
#else
#	define DLL_EXPORT
#endif

DLL_EXPORT void doHello(void);

';
	writeSourceFileNamed: 'helloLib.c' text: '
#define BUILD_HELLO_DLL
#include "hello.h"
#include <stdio.h>

void doHello(void)
{
	printf("Hello World\n");
}
'; writeSourceFileNamed: 'hello.c' text: '
#include "hello.h"

int main(int argc, const char *argv[])
{
	doHello();
	return 0;
}
'.
	rootPackage := self wbtScriptWith: [:script |
		script includeDirectory: self wbtIncludeDirectory.
		libraryModule := script dynamicLibrary: 'helloLib' with: [ :lib |
			lib
				source: 'helloLib.c'
		].

		self assert: libraryModule sources size equals: 1.
		self assert: libraryModule sources first relativeFileReference equals: 'helloLib.c' asFileReference.

		self assert: libraryModule intermediateObjectFiles size equals: 1.
		self assert: libraryModule intermediateObjectFiles first fileReference basename equals: (buildEnvironment platform formatObjectFileName: 'helloLib.c').

		programModule := script program: 'hello' with: [ :prog |
			prog
				source: 'hello.c';
				linkLibrary: #helloLib.
		].
			
		self assert: programModule sources size equals: 1.
		self assert: programModule sources first relativeFileReference equals: 'hello.c' asFileReference.

		self assert: programModule intermediateObjectFiles size equals: 1.
		self assert: programModule intermediateObjectFiles first fileReference basename equals: (buildEnvironment platform formatObjectFileName: 'hello.c')
	].

	self assert: rootPackage mainElements size equals: 2.
	sortedDependencies := rootPackage withSortedDependencies.
	self assert: (sortedDependencies collect: [ :each | each name ] as: Array) equals:
	{ 
		'helloLib.c' .
		(buildEnvironment platform formatObjectFileName: 'helloLib.c') .
		'helloLib' .
		'hello.c' .
		(buildEnvironment platform formatObjectFileName: 'hello.c') .
		'hello' .
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
	sortedDependencies := rootPackage withSortedDependencies.
	self assert: (sortedDependencies collect: [ :each | each name ] as: Array) equals:
	{ 'hello.cpp' .
		(buildEnvironment platform formatObjectFileName: 'hello.cpp') . 'hello' .
		#Root
	}.
	self assert: rootPackage runBuildActions.
	self assert: programModule executeAndReadStdout equals: ('Hello World' , String lf).
]

{ #category : #tests }
WBTProgramBuildingScriptEvaluationTest >> testHelloWorldCPPDynamicLib [
	| libraryModule programModule rootPackage sortedDependencies |
	self
		writeIncludeFileNamed: 'hello.h' text: '
#ifdef _WIN32
#	ifdef BUILD_HELLO_DLL
#		define DLL_EXPORT __declspec(dllexport)
#	else
#		define DLL_EXPORT __declspec(dllimport)
#	endif
#else
#	define DLL_EXPORT
#endif

DLL_EXPORT void doHello(void);

';
	writeSourceFileNamed: 'helloLib.cpp' text: '
#define BUILD_HELLO_DLL
#include "hello.h"
#include <iostream>

void doHello(void)
{
	std::cout << "Hello World" << std::endl;
}
'; writeSourceFileNamed: 'hello.cpp' text: '
#include "hello.h"

int main(int argc, const char *argv[])
{
	doHello();
	return 0;
}
'.
	rootPackage := self wbtScriptWith: [:script |
		script includeDirectory: self wbtIncludeDirectory.
		libraryModule := script dynamicLibrary: 'helloLib' with: [ :lib |
			lib
				source: 'helloLib.cpp'
		].

		self assert: libraryModule sources size equals: 1.
		self assert: libraryModule sources first relativeFileReference equals: 'helloLib.cpp' asFileReference.

		self assert: libraryModule intermediateObjectFiles size equals: 1.
		self assert: libraryModule intermediateObjectFiles first fileReference basename equals: (buildEnvironment platform formatObjectFileName: 'helloLib.cpp').

		programModule := script program: 'hello' with: [ :prog |
			prog
				source: 'hello.cpp';
				linkLibrary: #helloLib.
		].
			
		self assert: programModule sources size equals: 1.
		self assert: programModule sources first relativeFileReference equals: 'hello.cpp' asFileReference.

		self assert: programModule intermediateObjectFiles size equals: 1.
		self assert: programModule intermediateObjectFiles first fileReference basename equals: (buildEnvironment platform formatObjectFileName: 'hello.cpp')
	].

	self assert: rootPackage mainElements size equals: 2.
	sortedDependencies := rootPackage withSortedDependencies.
	self assert: (sortedDependencies collect: [ :each | each name ] as: Array) equals:
	{ 
		'helloLib.cpp' .
		(buildEnvironment platform formatObjectFileName: 'helloLib.cpp') .
		'helloLib' .
		'hello.cpp' .
		(buildEnvironment platform formatObjectFileName: 'hello.cpp') .
		'hello' .
		#Root
	}.
	self assert: rootPackage runBuildActions.
	self assert: programModule executeAndReadStdout equals: ('Hello World' , String lf).
	
]

{ #category : #tests }
WBTProgramBuildingScriptEvaluationTest >> testHelloWorldCPPStaticLib [
	| libraryModule programModule rootPackage sortedDependencies |
	self
		writeIncludeFileNamed: 'hello.h' text: '
void doHello(void);

';
	writeSourceFileNamed: 'helloLib.cpp' text: '
#include "hello.h"
#include <iostream>

void doHello(void)
{
	std::cout << "Hello World" << std::endl;
}
'; writeSourceFileNamed: 'hello.cpp' text: '
#include "hello.h"

int main(int argc, const char *argv[])
{
	doHello();
	return 0;
}
'.
	rootPackage := self wbtScriptWith: [:script |
		script includeDirectory: self wbtIncludeDirectory.
		libraryModule := script staticLibrary: 'helloLib' with: [ :lib |
			lib
				source: 'helloLib.cpp'
		].

		self assert: libraryModule sources size equals: 1.
		self assert: libraryModule sources first relativeFileReference equals: 'helloLib.cpp' asFileReference.

		self assert: libraryModule intermediateObjectFiles size equals: 1.
		self assert: libraryModule intermediateObjectFiles first fileReference basename equals: (buildEnvironment platform formatObjectFileName: 'helloLib.cpp').

		programModule := script program: 'hello' with: [ :prog |
			prog
				source: 'hello.cpp';
				linkLibrary: #helloLib.
		].
			
		self assert: programModule sources size equals: 1.
		self assert: programModule sources first relativeFileReference equals: 'hello.cpp' asFileReference.

		self assert: programModule intermediateObjectFiles size equals: 1.
		self assert: programModule intermediateObjectFiles first fileReference basename equals: (buildEnvironment platform formatObjectFileName: 'hello.cpp')
	].

	self assert: rootPackage mainElements size equals: 2.
	sortedDependencies := rootPackage withSortedDependencies.
	self assert: (sortedDependencies collect: [ :each | each name ] as: Array) equals:
	{ 
		'helloLib.cpp' .
		(buildEnvironment platform formatObjectFileName: 'helloLib.cpp') .
		'helloLib' .
		'hello.cpp' .
		(buildEnvironment platform formatObjectFileName: 'hello.cpp') .
		'hello' .
		#Root
	}.
	self assert: rootPackage runBuildActions.
	self assert: programModule executeAndReadStdout equals: ('Hello World' , String lf).
	
]

{ #category : #tests }
WBTProgramBuildingScriptEvaluationTest >> testHelloWorldCStaticLib [
	| libraryModule programModule rootPackage sortedDependencies |
	self
		writeIncludeFileNamed: 'hello.h' text: '
void doHello(void);

';
	writeSourceFileNamed: 'helloLib.c' text: '
#include "hello.h"
#include <stdio.h>

void doHello(void)
{
	printf("Hello World\n");
}
'; writeSourceFileNamed: 'hello.c' text: '
#include "hello.h"

int main(int argc, const char *argv[])
{
	doHello();
	return 0;
}
'.
	rootPackage := self wbtScriptWith: [:script |
		script includeDirectory: self wbtIncludeDirectory.
		libraryModule := script staticLibrary: 'helloLib' with: [ :lib |
			lib
				source: 'helloLib.c'
		].

		self assert: libraryModule sources size equals: 1.
		self assert: libraryModule sources first relativeFileReference equals: 'helloLib.c' asFileReference.

		self assert: libraryModule intermediateObjectFiles size equals: 1.
		self assert: libraryModule intermediateObjectFiles first fileReference basename equals: (buildEnvironment platform formatObjectFileName: 'helloLib.c').

		programModule := script program: 'hello' with: [ :prog |
			prog
				source: 'hello.c';
				linkLibrary: #helloLib.
		].
			
		self assert: programModule sources size equals: 1.
		self assert: programModule sources first relativeFileReference equals: 'hello.c' asFileReference.

		self assert: programModule intermediateObjectFiles size equals: 1.
		self assert: programModule intermediateObjectFiles first fileReference basename equals: (buildEnvironment platform formatObjectFileName: 'hello.c')
	].

	self assert: rootPackage mainElements size equals: 2.
	sortedDependencies := rootPackage withSortedDependencies.
	self assert: (sortedDependencies collect: [ :each | each name ] as: Array) equals:
	{ 
		'helloLib.c' .
		(buildEnvironment platform formatObjectFileName: 'helloLib.c') .
		'helloLib' .
		'hello.c' .
		(buildEnvironment platform formatObjectFileName: 'hello.c') .
		'hello' .
		#Root
	}.
	self assert: rootPackage runBuildActions.
	self assert: programModule executeAndReadStdout equals: ('Hello World' , String lf).
	
]

{ #category : #tests }
WBTProgramBuildingScriptEvaluationTest >> testHelloWorldCWithHeader [
	| programModule rootPackage sortedDependencies |
	self
		writeSourceFileNamed: 'hello.h' text: '
#include <stdio.h>

void doHello(void)
{
	printf("Hello World\n");
}

';	writeSourceFileNamed: 'hello.c' text: '
#include "hello.h"

int main(int argc, const char *argv[])
{
	doHello();
	return 0;
}
'.
	rootPackage := self wbtScriptWith: [:script |
		programModule := script
			program: 'hello' with: [ :prog |
				prog
					sources: #('hello.h' 'hello.c')
			].
			
		self assert: programModule sources size equals: 2.
		self assert: programModule sources first relativeFileReference equals: 'hello.h' asFileReference.
		self assert: programModule sources second relativeFileReference equals: 'hello.c' asFileReference.

		self assert: programModule intermediateObjectFiles size equals: 1.
		self assert: programModule intermediateObjectFiles first fileReference basename equals: (buildEnvironment platform formatObjectFileName: 'hello.c')
	].

	self assert: rootPackage mainElements size equals: 1.
	sortedDependencies := rootPackage withSortedDependencies.
	self assert: (sortedDependencies collect: [ :each | each name ] as: Array) equals:
	{ 
		'hello.h' .
		'hello.c' .
		(buildEnvironment platform formatObjectFileName: 'hello.c') . 'hello' .
		#Root
	}.
	self assert: rootPackage runBuildActions.
	self assert: programModule executeAndReadStdout equals: ('Hello World' , String lf).
	
]

{ #category : #tests }
WBTProgramBuildingScriptEvaluationTest >> testHelloWorldCWithIncludeHeader [
	| programModule rootPackage sortedDependencies |
	self
		writeIncludeFileNamed: 'hello.h' text: '
#include <stdio.h>

void doHello(void)
{
	printf("Hello World\n");
}

';	writeSourceFileNamed: 'hello.c' text: '
#include "hello.h"

int main(int argc, const char *argv[])
{
	doHello();
	return 0;
}
'.
	rootPackage := self wbtScriptWith: [:script |
		script includeDirectory: self wbtIncludeDirectory.
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
	sortedDependencies := rootPackage withSortedDependencies.
	self assert: (sortedDependencies collect: [ :each | each name ] as: Array) equals:
	{ 
		'hello.c' .
		(buildEnvironment platform formatObjectFileName: 'hello.c') . 'hello' .
		#Root
	}.
	self assert: rootPackage runBuildActions.
	self assert: programModule executeAndReadStdout equals: ('Hello World' , String lf).
	
]

{ #category : #tests }
WBTProgramBuildingScriptEvaluationTest >> testHelloWorldCppWithHeader [
	| programModule rootPackage sortedDependencies |
	self
		writeSourceFileNamed: 'hello.h' text: '
#include <iostream>

void doHello(void)
{
	std::cout << "Hello World" << std::endl;
}

';	writeSourceFileNamed: 'hello.cpp' text: '
#include "hello.h"

int main(int argc, const char *argv[])
{
	doHello();
	return 0;
}
'.
	rootPackage := self wbtScriptWith: [:script |
		programModule := script
			program: 'hello' with: [ :prog |
				prog
					sources: #('hello.h' 'hello.cpp')
			].
			
		self assert: programModule sources size equals: 2.
		self assert: programModule sources first relativeFileReference equals: 'hello.h' asFileReference.
		self assert: programModule sources second relativeFileReference equals: 'hello.cpp' asFileReference.

		self assert: programModule intermediateObjectFiles size equals: 1.
		self assert: programModule intermediateObjectFiles first fileReference basename equals: (buildEnvironment platform formatObjectFileName: 'hello.cpp')
	].

	self assert: rootPackage mainElements size equals: 1.
	sortedDependencies := rootPackage withSortedDependencies.
	self assert: (sortedDependencies collect: [ :each | each name ] as: Array) equals:
	{ 
		'hello.h' .
		'hello.cpp' .
		(buildEnvironment platform formatObjectFileName: 'hello.cpp') . 'hello' .
		#Root
	}.
	self assert: rootPackage runBuildActions.
	self assert: programModule executeAndReadStdout equals: ('Hello World' , String lf).
	
]

{ #category : #tests }
WBTProgramBuildingScriptEvaluationTest >> testHelloWorldCppWithIncludeHeader [
	| programModule rootPackage sortedDependencies |
	self
		writeIncludeFileNamed: 'hello.h' text: '
#include <iostream>

void doHello(void)
{
	std::cout << "Hello World" << std::endl;
}

';	writeSourceFileNamed: 'hello.cpp' text: '
#include "hello.h"

int main(int argc, const char *argv[])
{
	doHello();
	return 0;
}
'.
	rootPackage := self wbtScriptWith: [:script |
		script includeDirectory: self wbtIncludeDirectory.
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
	sortedDependencies := rootPackage withSortedDependencies.
	self assert: (sortedDependencies collect: [ :each | each name ] as: Array) equals:
	{ 
		'hello.cpp' .
		(buildEnvironment platform formatObjectFileName: 'hello.cpp') . 'hello' .
		#Root
	}.
	self assert: rootPackage runBuildActions.
	self assert: programModule executeAndReadStdout equals: ('Hello World' , String lf).
	
]

{ #category : #tests }
WBTProgramBuildingScriptEvaluationTest >> testLLVMAssembly [
	| programModule rootPackage sortedDependencies |
	self
		writeSourceFileNamed: 'hello.ll' text: '
define i32 @main() {
  ret i32 42
}
'.
	rootPackage := self wbtScriptWith: [:script |
		programModule := script
			program: 'hello' with: [ :prog |
				prog
					source: 'hello.ll'
			].
			
		self assert: programModule sources size equals: 1.
		self assert: programModule sources first relativeFileReference equals: 'hello.ll' asFileReference.

		self assert: programModule intermediateObjectFiles size equals: 1.
		self assert: programModule intermediateObjectFiles first fileReference basename equals: (buildEnvironment platform formatObjectFileName: 'hello.ll')
	].

	self assert: rootPackage mainElements size equals: 1.
	sortedDependencies := rootPackage withSortedDependencies.
	self assert: (sortedDependencies collect: [ :each | each name ] as: Array) equals:
	{ 'hello.ll' .
		(buildEnvironment platform formatObjectFileName: 'hello.ll') . 'hello' .
		#Root
	}.
	self assert: rootPackage runBuildActions.
	self assert: programModule executeSilently equals: 42.
	
]
