Class {
	#name : #VideoPlayerController,
	#superclass : #Object,
	#instVars : [
		'window',
		'view',
		'announcer',
		'video',
		'timeProcess'
	],
	#category : #'VideoPlayer-Core'
}

{ #category : #'instance creation' }
VideoPlayerController class >> open [ 

	self deprecated: 'Old way to use the player'.
	self new window open
]

{ #category : #ui }
VideoPlayerController >> chooseVideoFileDialog [

	self deprecated:'the video player should not to have UI stuff'.
	^ UIManager default chooseFullFileNameMatching: nil.
]

{ #category : #factory }
VideoPlayerController >> createWindow [
	
	self deprecated: 'Old way to use the player'.
	
	^ PenWindow new 
		title: self defaultTitle;
		position: 10@50;
		size: 1280@850;
		resizable: false;
		addDock: (PenViewDock new 
			size: 1280@870;
			key: #view;
			view: view);
		addDock: (PenExternalDock new 
			position: 0@45;
			size: 1280@720;
			key: #video)
]

{ #category : #defaults }
VideoPlayerController >> defaultName [

	self deprecated:'the video player should not to have UI stuff'.
	^ 'Waiting for a video ...'
]

{ #category : #defaults }
VideoPlayerController >> defaultTime [

	self deprecated:'the video player should not to have UI stuff'.
	^ '00:00:00'
]

{ #category : #defaults }
VideoPlayerController >> defaultTitle [

	self deprecated:'the video player should not to have UI stuff'.
	^ 'Video Player for Pharo'
]

{ #category : #ui }
VideoPlayerController >> displayError: aString [

	self deprecated:'the video player should not to have UI stuff'.
	self inform: aString.
	self flag: 'to include in gui'.
]

{ #category : #errors }
VideoPlayerController >> gstInitError [
	self displayError: 'Gst init failed.'
]

{ #category : #errors }
VideoPlayerController >> gstNotFoundError [
	self displayError: 'Gstreamer library not found.'
]

{ #category : #initialization }
VideoPlayerController >> initialize [

	super initialize
]

{ #category : #initialization }
VideoPlayerController >> initializeOld [

	self deprecated:'Concerv this method for refactoring'.
  
	super initialize.
	
	view := PenfeldVideoPlayerView new.
	self view videoNameLabel text: self defaultName.
	self view timeLabel text: self defaultTime.
	self view remainingTime text: self defaultTime.
	
	announcer := Announcer new.
	window := self createWindow.
	
	self view announcer when: OpenVideo do: [ self openVideo ].
	self view announcer when: PlayVideo do: [ self playVideo ].
	self view announcer when: PauseVideo do: [ self pauseVideo ].
	self view announcer when: StopVideo do: [ self stopVideo ].
	
]

{ #category : #errors }
VideoPlayerController >> nullWindowIdError [

	self deprecated:'the video player should not to have UI stuff'.

	self displayError: 'Can not find window id. Please use OS window.'
]

{ #category : #actions }
VideoPlayerController >> openVideo [
	| filename id dock rectangle |
	
	"Open dialog to choose a video file"
	filename := self chooseVideoFileDialog.
	filename ifNil: [ ^ self ].
	
	"Launch video"
	video := Video fromFile: filename.
	video launch.
	
	
	"Open video in SDL window"
	id := self window id.
	(id isNil or: [ id = 0 ]) ifTrue: [ self nullWindowIdError. ^ self ].
	video setWindow: id.
	
	"Resize video"
	dock := self window getDock: #video.
	rectangle := dock position extent: (dock width pref @ dock height pref).
	video resize: rectangle.
	
	"Update view"
	self view videoNameLabel text: filename printString. 
	"self view remainingTime text: (self timeString: video pipeline durationInSeconds)."
	self view openVideoButton disable.
	self view stopButton enable.
	
	"Run video"
	self playVideo.
]

{ #category : #actions }
VideoPlayerController >> pauseVideo [
	video pause.
	"timeProcess terminate."

	self view buttonsContainer removeElement: self view pauseButton.
	self view buttonsContainer addElement: self view newPlayButton afterIndex: 0.
]

{ #category : #actions }
VideoPlayerController >> playVideo [
	video play.
	
	"Update view"
	"timeProcess := video runningTimeInSeconds 
		to: video pipeline durationInSeconds 
		do: [ :s |
			self view timeLabel text: (self timeString: s).
			1 second wait.
		] fork."
	

	self view buttonsContainer removeElement: self view playButton.
	self view buttonsContainer addElement: self view newPauseButton afterIndex: 0.
]

{ #category : #actions }
VideoPlayerController >> stopVideo [
	video stop.
	video := nil.
	
	"View update"
	self view videoNameLabel text: self defaultName. 
	self view openVideoButton enable.
	
	"timeProcess terminate.
	timeProcess := nil."
	self view timeLabel text: self defaultTime.
	self view remainingTime text: self defaultTime.
	
	self view playButton ifNil: [ 
		self view buttonsContainer removeElement: self view pauseButton.
		self view buttonsContainer addElement: self view newPlayButton afterIndex: 0. ].
	self view playButton disable.
	
	self view stopButton disable.
]

{ #category : #ui }
VideoPlayerController >> timeString: aDurationInSeconds [
	| t stream |
	t := aDurationInSeconds seconds.
	stream := WriteStream on: String new.
	t hours printOn: stream base: 10 length: 2 padded: true.
	stream << $:.
	t minutes printOn: stream base: 10 length: 2 padded: true.
	stream << $:.
	t seconds printOn: stream base: 10 length: 2 padded: true.
	^ stream contents
]

{ #category : #errors }
VideoPlayerController >> videoNotFoundError [
	self displayError: 'Can not find any video at this path.'
]

{ #category : #accessing }
VideoPlayerController >> view [
	self deprecated:'the video player should not to have UI stuff'.
	
	^ view
]

{ #category : #accessing }
VideoPlayerController >> window [
	self deprecated:'the video player should not to have UI stuff'.

	^ window
]
