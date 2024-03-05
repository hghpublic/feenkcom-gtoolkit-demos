Class {
	#name : #FCALepiterContextExamples,
	#superclass : #Object,
	#category : #'GToolkit-Demo-FCA-Examples'
}

{ #category : #example }
FCALepiterContextExamples >> gtBook [
	"The entire book with all tags as properties."

	<gtExample>
	<noTest>
	^ (FCAContext
		elements: LeDatabase gtBook pages
		properties: (LeDatabase gtBook pages flatCollect: #tags) asSet
		propertyMap: #tags)
		printMessage: #title;
		yourself
]

{ #category : #example }
FCALepiterContextExamples >> gtBookTaggedPagesOnly [
	"We take only pages with tags, and consider only the top 10 tags as properties."

	<gtExample>
	<noTest>
	| gtBook pages tags toc |
	gtBook := LeDatabase gtBook.
	toc := gtBook pageNamed: 'Glamorous Toolkit Book'.
	pages := (gtBook pages reject: [ :each | each tags isEmpty ]) copyWithout: toc.
	tags := ((pages flatCollect: #tags) asBag sortedCounts copyFrom: 1 to: 10)
			collect: #value.

	^ (FCAContext
		elements: pages
		properties: tags
		propertyMap: [ :page | page tags intersection: tags ])
		printMessage: #title;
		yourself
]