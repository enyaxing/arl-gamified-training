# ARL Gamified Training

## About
 - **Who**
   - **Primary Contributors** - Christine Lou (UC Berkeley), Kyle Lui (UC Berkeley), Enya Xing (UC Berkeley)
   - **Sponsor** - Dr. Benjamin Files (Army Research Lab West)
   - **Target Audience** - Soldiers who need to practice distinguishing between friendly and enemy combat vehicles
   - **Support** - National Security Innovation Network, XForce Fellowship Program, Army Research Lab West
 - **What** - Our purpose is to design, develop, and test a multi-platform application that facilitates practicing making vehicle identification judgments quickly and accurately. The application uses a personalized gamification approach based on the user’s regulatory focus to make training fun and engaging.  The app includes formative and summative assessments of combat identification skills, an in game reward system, and an instructor interface that can be used to monitor student progress.
 - **Where** - Remote collaboration
 - **When** - Summer 2020
 - **Why** - According to prior research, there are measurable benefits to practice and training when a gamified approach is implemented.  The amount of benefit is directly related to the person’s personality, psychology, and regulatory focus, as well as the feedback framework.  Our app aims to provide a convenient means of practicing distinguishing between friendly and enemy vehicles while incorporating specifically tailored feedback frameworks for optimal performance.
 - **How** - The project was coded using the XCode IDE and SwiftUI.  Github was used for version control.  Asana was used for task management.  Slack, Google Meet, and Microsoft Teams were used for communication.  Google Drive was used for documentation.

## Installation Instructions

1. Download XCode on your Mac https://developer.apple.com/xcode/
2. Open terminal and navigate to where you wish to save your app.
3. Run “git clone https://github.com/enyaxing/arl-gamified-training” in terminal (without the quotations).
4. Navigate to CID Gamified Training by running the following commands. (Note the single quotes around CID Gamified Training)
  - “cd arl-gamified-training”
  - “cd ‘CID Gamified Training’”
5. Run “sudo gem install cocoapods” (May require admin password)
6. Run “pod install”
7. You should now have a file called ‘CID Gamified Training.xcworkspace’ in the CID Gamified Training directory.  Open this file with XCode.  Make sure you’re not opening ‘CID Gamified Training.xcodeproj.’
8. Connect your iPhone to your Mac.
9. In XCode, towards the top left, change your build location to your device.  (The default is probably iPhone SE or Generic iOS Device).
10. Press the play button to build the app.  You will most likely be prompted to create some developer team.  Do so.  You also may be asked to provide a computer password and/or unlock your iphone.
11. Your app should now be installed on your iphone.  You will be prompted to trust the app.  Go to Settings -> General -> Profiles or Profiles & Device Management and select the app and click trust.
12. Your app should now be working and you should now be able to run it like a normal app.

## Firebase
https://console.firebase.google.com/u/0/project/arl-gamified-training-2767b/overview  
Firebase was used as a backend for signin/signup authentication and as a database to store user information.  Currently privacy rules/regulations are set to expire on 09/17/2020.  Please update these rules through Firebase for future use of the app.

## App Flow Chart
![FlowChart](https://github.com/enyaxing/arl-gamified-training/blob/master/Flow%20Chart.png)

## Miscellaneous Files
Some miscellaneous files found in the project that don't contain actual Swift code.
 - Flow Chart.png - Image of a flowchart of the app
 - Podfile - Contains cocoapods installed into the app
 - .swiftlint.yml - Style guidelines enforced by swiftlint
 - calculation.py - Python file for calculating regulatory focus heuristic using promotion and prevention scores from questionairre
 - tags.json - Json file that contains tags for images

## Notes
The master branch contains all features except AR and 3D view.  To view these features, please switch to the ar branch.  The reason for this separation is for simulation purposes.  All features can be simulated on a Mac without an iPhone except for the AR and 3D views which require a physical iPhone.  
There are more in depth README files as you navigate further into the project.  They list fields, functions, dependencies, and purpose of each file.
