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
				with: [ spec repository: 'github://OpenSmock/PharoVideo:main' ].

			"VideoPlayer"
			spec package: 'VideoPlayer' with: [ spec requires: #('Video') ] ]
]
