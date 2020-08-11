# arl-gamified-training

X-Force Summer 2020

# Transitions

## Countdown.swift
The transition between the user starting a training session and when the actual training session begins.

### Fields
- `playing: Bool` - current state of transition
- `instructions: Bool` - instructions page

## LottieView.swift
Contains LottieView, which is an iOS library for the animations in this app.

### Fields
- `fileName:String` - name of file
- `playing:Bool` - current state of transition
- `isLoop:Bool` - loop state of transition

### Functions
- `makeUIView(context:   UIViewRepresentableContext<LottieView>)` - makes the animation
- `updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>)` - updates the animation

## Neutral.swift
When the user is playing on a neutral focus setting, these are the transitions that will be visible between each question answered in a training session. The total points are broken down into time and accuracy points. 

### Fields
- `secondsElapsed:Double` - time taken to respond
- `type:String` - is the response correct or incorrect?
- `playing: Bool` - current state of transition

## Prevention.swift
When the user is playing on a prevention focus setting, these are the transitions that will be visible between each question answered in a training session. The total points are broken down into time and accuracy points.

### Fields
- `secondsElapsed:Double` - time taken to respond
- `points:Int` - points earned for this question
- `type:String` - is the response correct or incorrect?
- `multiply:Bool` - should we multiply the score by 4?
- `playing: Bool` - current state of transition

## Promotion.swift
When the user is playing on a promotion focus setting, these are the transitions that will be visible between each question answered in a training session. The total points are broken down into time and accuracy points.

### Fields
- `secondsElapsed:Double` - time taken to respond
- `points:Int` - points earned for this question
- `type:String` - is the response correct or incorrect?
- `multiply:Bool` - should we multiply the score by 4?
- `playing: Bool` - current state of transition

## StopWatchManager.swift
Records the response time per question when the user is in a training session.

### Fields
- `secondsElapsed:Double` - seconds elapsed since the timer has started
- `timer:Timer` - the timer

### Functions
- `start()` - start the timer
- `stop()` - stop the timer

