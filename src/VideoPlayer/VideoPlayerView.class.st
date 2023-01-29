Class {
	#name : #VideoPlayerView,
	#superclass : #Object,
	#instVars : [
		'announcer'
	],
	#category : #'VideoPlayer-Core'
}

{ #category : #accessing }
VideoPlayerView >> announcer [
	^ announcer
]

{ #category : #'accessing - ui' }
VideoPlayerView >> buttonsContainer [
	^ self displayComponent getElement: #buttonsContainer
]

{ #category : #initialization }
VideoPlayerView >> initContent [
	self displayComponent: (PenContainer new
		key: #viewContainer;
		layout: PenLinearLayout vertical;
		addAllElements: {
			PenContainer new
				key: #topBarContainer;
				size: 1280@45;						"TODO: fix just height (maximized width)"
				layout: PenLinearLayout horizontal;
				addAllElements: {
					"PenImage key: #pharoLogo."
					PenLabel key: #videoNameLabel.
				}.
			PenContainer new
				key: #videoContainer;
				layout: PenPositionLayout new; "TODO: remove it"
				size: 1280@720; 					"TODO: remove it (maximized width and height)"
				addElement: (PenButton new
					key: #openVideoButton; 
					text: 'Open video';
					icon: self openFileIcon;
					position: 560@280;				"TODO: manage centered alignment"
					onActionDo: [ self announcer announce: OpenVideo new ]).
			PenContainer new
				key: #bottomContainer;
				layout: PenLinearLayout vertical;
				addAllElements: { 
					PenContainer new
						key: #sliderContainer;
						layout: PenLinearLayout horizontal;
						addAllElements: { 
							PenLabel key: #timeLabel.
							PenProgressBar new
								key: #videoProgression;
								width: 1140; 		"TODO: it should be maximized"
								interval: (0 to: 1).
							PenLabel	key: #remainingTime.
						}.
					PenContainer new 
						key: #buttonsContainer;
						layout: PenLinearLayout horizontal;
						addAllElements: { 
							self newPlayButton
								disable.
							PenButton new
								key: #stopButton;
								addStyleClass: #circularButton;
								size: 30@30;
								icon: self stopVideoIcon;
								onActionDo: [ self announcer announce: StopVideo new ];
								disable.
						}
				}
		})
]

{ #category : #initialization }
VideoPlayerView >> initStylesheet [

	self displayComponent stylesheet: (PssParser parse: '
		* { 
			color: white;
			font-size: 12;
		}
		
		label { 
			margin: 5px;
		}
		
		button { 
			background-color: rgb(61,166,201);
			border-radius: 3px;
			text-align: center;
			width: 150px;
			height: 35px;
			margin: 10px;
		}
		
		button:active { 
			background-color: white;
			color: rgb(61,166,201);
		}
		
		button:disabled { 
			background-color: #5c6a6d;
		}
		
		.circularButton { 
			border-radius: 50%;
		}
		
		progressBar { 
			margin: 6px;
			background-color: #11323d;
			color: #3da6c9;
			height: 4px;
		 }
	
		#viewContainer { 
			background-image: linear-gradient(
				rgb(28,28,28) 0%,
				rgb(28,28,28) 92%,
				rgb(49,69,72) 100%);
		}
	
	').
]

{ #category : #initialization }
VideoPlayerView >> initialize [ 
	super initialize.
	
	announcer := Announcer new.
	
	self initContent.
	self initStylesheet.
]

{ #category : #factory }
VideoPlayerView >> newPauseButton [
	^ PenButton new 
		key: #pauseButton;
		addStyleClass: #circularButton;
		size: 45@45;
		icon: self pauseVideoIcon;
		onActionDo: [ self announcer announce: PauseVideo new ];
		yourself.
]

{ #category : #factory }
VideoPlayerView >> newPlayButton [
	^ PenButton new 
		key: #playButton;
		addStyleClass: #circularButton;
		size: 45@45;
		icon: self playVideoIcon;
		onActionDo: [ self announcer announce: PlayVideo new ];
		yourself.
]

{ #category : #resources }
VideoPlayerView >> openFileIcon [
^ImageReadWriter formFromStream: 'iVBORw0KGgoAAAANSUhEUgAAABMAAAAPCAYAAAAGRPQsAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAACZSURBVDiNtdExCgIxFEXR+4YBO0VRC9fjglzRrCFYuAbXMI1gJWKhYBGQmWcxWmhnEm8VUhx+8rF98Wd7EquB7utuYnv9o9NKOmL75Pw2ABXQpz7rr8l2C8wLWIcamAHTAlhTMfxbiYJs34BxJnQGVqUm20rqSmEBhm1GYJQB3YGFpFhisp2kyAvKxcL7INs9oEToASwlXQGeX7t931U/cKMAAAAASUVORK5CYII=' base64Decoded asByteArray readStream
]

{ #category : #'accessing - ui' }
VideoPlayerView >> openVideoButton [
	^ self displayComponent getElement: #openVideoButton
]

{ #category : #'accessing - ui' }
VideoPlayerView >> pauseButton [
	^ self displayComponent getElement: #pauseButton
]

{ #category : #resources }
VideoPlayerView >> pauseVideoIcon [
^ImageReadWriter formFromStream: 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAXCAYAAAAC9s/ZAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAApSURBVDiNY/iPHYQyoIH///+HYlPIhK6QVDBqwKgBowaMGjBqABUNAAAnSy6pIqwUhQAAAABJRU5ErkJggg==' base64Decoded asByteArray readStream
]

{ #category : #'accessing - ui' }
VideoPlayerView >> playButton [
	^ self displayComponent getElement: #playButton
]

{ #category : #resources }
VideoPlayerView >> playVideoIcon [
^ImageReadWriter formFromStream: 'iVBORw0KGgoAAAANSUhEUgAAABMAAAAbCAYAAACeA7ShAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAADfSURBVEiJrdQhTgNRFIbRCwhCMGAJpgsggMYU3wUgMKwAWcsWkCQoBKJbaDUbaBMsVKLqmkDSg2heQgNlZjr3W8DJe/O/TGCAw8jIsjdcZGHwhTvsZGClF3SyMJjhKgsrPWE/C4NXnGdh8Gk5znYGVhriKAuDD/SyMFjgAXsZWGmCkywM5riNiNiCWrNX95iFjSLipu015+gr768FNMbpyvk2QBa4x+6vyzaE3tFd++UaQNW/9xrIDNe1Nq2ARjiuBf2DrU7eApvgrBHyB7Z+8obYFJcbIz+wZxy0hiLiGzpozefaBVRbAAAAAElFTkSuQmCC' base64Decoded asByteArray readStream
]

{ #category : #'accessing - ui' }
VideoPlayerView >> remainingTime [
	^ self displayComponent getElement: #remainingTime
]

{ #category : #'accessing - ui' }
VideoPlayerView >> stopButton [
	^ self displayComponent getElement: #stopButton
]

{ #category : #resources }
VideoPlayerView >> stopVideoIcon [
^ImageReadWriter formFromStream: 'iVBORw0KGgoAAAANSUhEUgAAAAsAAAAMCAYAAAC0qUeeAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAAYSURBVCiRY/z///9/BiIBE7EKRxUPB8UAeX4EFKMKlOwAAAAASUVORK5CYII=' base64Decoded asByteArray readStream
]

{ #category : #'accessing - ui' }
VideoPlayerView >> timeLabel [
	^ self displayComponent getElement: #timeLabel
]

{ #category : #'accessing - ui' }
VideoPlayerView >> videoNameLabel [
	^ self displayComponent getElement: #videoNameLabel
]
