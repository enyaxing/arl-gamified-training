# arl-gamified-training

X-Force Summer 2020

# Transitions

## Countdown.swift
The transition between the user starting a training session and when the actual training session begins.

### Fields
- `playing: Bool` - is this transition playing?
- `instructions: Bool` - instructions page

## LottieView.swift
Contains LottieView, which is an iOS library for the animations in this app.

## Neutral.swift
When the user is playing on a neutral focus setting, these are the transitions that will be visible between each question answered in a training session. The total points are broken down into time and accuracy points. 

## Prevention.swift
When the user is playing on a prevention focus setting, these are the transitions that will be visible between each question answered in a training session. The total points are broken down into time and accuracy points.

## Promotion.swift
When the user is playing on a promotion focus setting, these are the transitions that will be visible between each question answered in a training session. The total points are broken down into time and accuracy points.

## StopWatchManager.swift
Records the response time per question when the user is in a training session.
