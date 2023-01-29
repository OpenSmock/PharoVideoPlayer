Class {
	#name : #SpVideoPlayer,
	#superclass : #SpPresenter,
	#instVars : [
		'videoPlayerController'
	],
	#category : #'VideoPlayer-Spec2'
}

{ #category : #accessing }
SpVideoPlayer class >> defaultLayout [ 

	^ SpBoxLayout new
]

{ #category : #accessing }
SpVideoPlayer class >> open [
	<script>
	^self new open
]

{ #category : #accessing }
SpVideoPlayer class >> title [
	
	^ 'Spec Video Player'
]

{ #category : #errors }
SpVideoPlayer >> displayError: aString [

	self inform: aString.
	
]

{ #category : #errors }
SpVideoPlayer >> displayNullWindowIdError [

	self displayError: 'Can not find window id. Please use OS window.'
]

{ #category : #initialization }
SpVideoPlayer >> initUI [

	| openVideoButton |
	openVideoButton := self newButton.
	openVideoButton 
		label: 'Open Video';
		icon: self openFileIcon;
		action:[self openVideoAction].
	self layout add: openVideoButton.

	self flag:'Fix actions and view updates'.

	"self view videoNameLabel text: videoPlayer defaultName.
	self view timeLabel text: videoPlayer defaultTime.
	self view remainingTime text: videoPlayer defaultTime."
	
	"self view announcer when: OpenVideo do: [ videoPlayer openVideo ].
	self view announcer when: PlayVideo do: [ videoPlayer playVideo ].
	self view announcer when: PauseVideo do: [ videoPlayer pauseVideo ].
	self view announcer when: StopVideo do: [ videoPlayer stopVideo ]."
]

{ #category : #initialization }
SpVideoPlayer >> initVideoPlayerController [

	videoPlayerController := VideoPlayerController new. 
]

{ #category : #initialization }
SpVideoPlayer >> initialize [ 

	super initialize.
	self initVideoPlayerController.
	self initUI.
]

{ #category : #initialization }
SpVideoPlayer >> initializeWindow: aWindowPresenter [ 

	aWindowPresenter 
		initialExtent: 640@480;
		title: self class title;
		centered
]

{ #category : #actions }
SpVideoPlayer >> openChooseVideoFileDialog [

	^ UIManager default chooseFullFileNameMatching: nil.
]

{ #category : #icons }
SpVideoPlayer >> openFileIcon [

	^ ImageReadWriter formFromStream:
		  'iVBORw0KGgoAAAANSUhEUgAAABMAAAAPCAYAAAAGRPQsAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAACZSURBVDiNtdExCgIxFEXR+4YBO0VRC9fjglzRrCFYuAbXMI1gJWKhYBGQmWcxWmhnEm8VUhx+8rF98Wd7EquB7utuYnv9o9NKOmL75Pw2ABXQpz7rr8l2C8wLWIcamAHTAlhTMfxbiYJs34BxJnQGVqUm20rqSmEBhm1GYJQB3YGFpFhisp2kyAvKxcL7INs9oEToASwlXQGeX7t931U/cKMAAAAASUVORK5CYII='
			  base64Decoded asByteArray readStream
]

{ #category : #actions }
SpVideoPlayer >> openVideoAction [
	| filename video windowId videoZoneBounds rectangle |

	filename := self openChooseVideoFileDialog.
	filename ifNil: [ ^ self ].
	
	"Launch video" 
	video := Video fromFile: filename.
	video launch.
	
	"Open video in SDL window"
	windowId := self windowId.
	(windowId isNil or: [ windowId = 0 ]) ifTrue:[ self displayNullWindowIdError. ^ self ].
	video setWindow: windowId.
	
	"Resize video"
	videoZoneBounds := self window window bounds.
	self flag:'implement video position:'.
	video resize: videoZoneBounds extent.
	
	video play.
	
]

{ #category : #accessing }
SpVideoPlayer >> videoPlayerController [

	^ videoPlayerController
]

{ #category : #accessing }
SpVideoPlayer >> windowId [
	"hard coding of the window id, change that in case of opening in external window"

	^ World worldState worldRenderer window windowId
]
