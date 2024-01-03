"
Illustrates the use of an anonymous class to change the behavior of a single instance.
"
Class {
	#name : #AnonymousClassExample,
	#superclass : #TestCase,
	#category : #'GToolkit-Demo-Reflection-Examples'
}

{ #category : #accessing }
AnonymousClassExample >> anonymousClassInstance [
	"We create an anonymous subclass of Set with a logging #add: method. We dynamically change the class of an instance of Set to be of the new anonymous class and back again."

	<gtExample>
	| anonClass set |
	anonClass := Set newAnonymousSubclass.

	anonClass
		compile: 'add: anObject
			Transcript show: ''adding '', anObject printString; cr.
			^ super add: anObject'.

	set := Set new.
	set add: 1.
	self assert: set size equals: 1.

	set primitiveChangeClassTo: anonClass basicNew.
	set add: 2.
	self assert: set size equals: 2.

	^ set
]