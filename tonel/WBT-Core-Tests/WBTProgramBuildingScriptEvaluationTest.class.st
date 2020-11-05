Class {
	#name : #WBTProgramBuildingScriptEvaluationTest,
	#superclass : #WBTBuildingScriptEvaluationTest,
	#category : #'WBT-Core-Tests'
}

{ #category : #tests }
WBTProgramBuildingScriptEvaluationTest >> testHelloWorld [
	self
		writeSourceFileNamed: 'hello.c' text: '
#include <stdio.h>

int main(int argc, const char *argv[])
{
	printf("Hello World\n");
	return 0;
}
';
		wbtScriptWith: [:script |
			script
				program: 'hello' with: [ :prog |
					prog
						source: 'hello.c'
				]
	]
]
