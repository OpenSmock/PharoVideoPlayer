Class {
	#name : #BaselineOfVideoPlayer,
	#superclass : #BaselineOf,
	#category : #BaselineOfVideoPlayer
}

{ #category : #baselines }
BaselineOfVideoPlayer >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			"Video"
			spec
				baseline: 'Video'
				with: [ spec repository: 'github://OpenSmock/Video/src' ].
				
			"Penfeld"
			spec
				baseline: 'Penfeld'
				with: [ spec repository: 'github://plantec/penfeld/src' ].

			"VideoPlayer"
			spec package: 'VideoPlayer' with: [ spec requires: #('Video' 'Penfeld') ] ]
]
