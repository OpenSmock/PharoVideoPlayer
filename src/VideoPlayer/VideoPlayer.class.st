Class {
	#name : #VideoPlayer,
	#superclass : #Object,
	#instVars : [
		'window',
		'view',
		'announcer',
		'video',
		'timeProcess'
	],
	#category : #VideoPlayer
}

{ #category : #'instance creation' }
VideoPlayer class >> open [ 
	self new window open
]

{ #category : #ui }
VideoPlayer >> chooseVideoFileDialog [
	^ UIManager default chooseFullFileNameMatching: nil.
]

{ #category : #factory }
VideoPlayer >> createWindow [
	
	^ PenWindow new 
		size: 1280@870;
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
VideoPlayer >> defaultTime [
	^ '00:00:00'
]

{ #category : #defaults }
VideoPlayer >> defaultTitle [
	^ 'Video Player for Pharo'
]

{ #category : #ui }
VideoPlayer >> displayError: aString [
	self inform: aString.
	self flag: 'to include in gui'.
]

{ #category : #errors }
VideoPlayer >> gstInitError [
	self displayError: 'Gst init failed.'
]

{ #category : #errors }
VideoPlayer >> gstNotFoundError [
	self displayError: 'Gstreamer library not found.'
]

{ #category : #initialization }
VideoPlayer >> initialize [ 
	super initialize.
	
	view := VideoPlayerView new.
	self view videoNameLabel text: self defaultTitle.
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
VideoPlayer >> nullWindowIdError [
	self displayError: 'Can not find window id. Please use OS window.'
]

{ #category : #actions }
VideoPlayer >> openVideo [
	| filename id dock rectangle |
	
	filename := self chooseVideoFileDialog.
	filename ifNil: [ ^ self ].
	
	[ Gst init ]
		on: Error
		do: [ self gstNotFoundError. ^ self ].
		
	Gst isInit ifFalse: [ 
		self gstInitError.
		^ self ].
	
	video := GstVideo fromQTMp4Filename: filename.
	video ifNil: [
		self videoNotFoundError.
		^ self ].
	
	id := self window id.
	id ifNil: [ 
		self nullWindowIdError.
		^ self ].
	video videoBox overlaySetWindowHandle: (ExternalAddress fromAddress: id).
	
	dock := self window getDock: #video.
	rectangle := dock position extent: (dock width pref @ dock height pref).
	video videoBox overlaySetRenderRectangle: rectangle.
	
	self view videoNameLabel text: filename printString. 
	self view remainingTime text: (self timeString: video pipeline durationInSeconds).
	self view openVideoButton disable.
	self view stopButton enable.
	
	self view playVideo.
]

{ #category : #actions }
VideoPlayer >> pauseVideo [
	video pause.
	timeProcess terminate.

	self view buttonsContainer removeElement: self view pauseButton.
	self view buttonsContainer addElement: self view newPlayButton afterIndex: 0.
]

{ #category : #actions }
VideoPlayer >> playVideo [
	video play.
	
	"Update view"
	timeProcess := video runningTimeInSeconds 
		to: video pipeline durationInSeconds 
		do: [ :s |
			self view timeLabel text: (self timeString: s).
			1 second wait.
		] fork.
	

	self view buttonsContainer removeElement: self view playButton.
	self view buttonsContainer addElement: self view newPauseButton afterIndex: 0.
]

{ #category : #actions }
VideoPlayer >> stopVideo [
	video stop.
	video := nil.
	
	"View update"
	self view videoNameLabel text: self defaultTitle. 
	self view openVideoButton enable.
	
	timeProcess terminate.
	timeProcess := nil.
	self view timeLabel text: self defaultTime.
	self view remainingTime text: self defaultTime.
	
	self view playButton ifNil: [ 
		self view buttonsContainer removeElement: self view pauseButton.
		self view buttonsContainer addElement: self view newPlayButton afterIndex: 0. ].
	self view playButton disable.
	
	self view stopButton disable.
]

{ #category : #ui }
VideoPlayer >> timeString: aDurationInSeconds [
	self halt.
]

{ #category : #errors }
VideoPlayer >> videoNotFoundError [
	self displayError: 'Can not find any video at this path.'
]

{ #category : #accessing }
VideoPlayer >> view [
	^ view
]

{ #category : #accessing }
VideoPlayer >> window [
	^ window
]
