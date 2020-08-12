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

## File Structure 
To access the bulk of the files, under the project root directory, go to the directory `CID Gamified Training`. There are individual readmes inside of each subdirectory. Here's an explanation of all subfolder purposes in this directory: 
- /Assets.xcassets - folder containing all images and other assets used in this project
- /Assignments - deals with setting the vehicles to appear as friendly or enemy during the practice sessinos as well as creating assignments on the instructor side that can be practiced by the students
- /Base.lproj - automatically generated folder that contains LaunchScreen.storyboard, helps app run
- /CID Images - contains image library of all vehicles. Add more vehicles here through creating a new folder with vehicle type as the folder name, and include all relevant vehicle images inside the new folder. 
- /Components - reusable components used throughout the app
- /Games - deals with the functioning of the game itself
- /Home Page - contains sign-in, sign-up, and app home screen views
- /Instructor - contains files pertaining to the instructor side of the app
- /Objects - contains self-defined objects used throughout the app
- /Profile - contains files relevant to student user profile
 - /Questionnaire - contains files that make up the quesitonnaire 
 - /Styles - contains custom styles used in the app
 - /Summary - deals with files pertaining to the summary view, specifically shown at the end of training and view of past sessions
 - /Transitions - contains transition wrappers for animations. /Transitions/TestAnimations stores json files for Lottie animations.


## Firebase
https://console.firebase.google.com/u/0/project/arl-gamified-training-2767b/overview  
Firebase was used as a backend for signin/signup authentication and as a database to store user information.  Currently privacy rules/regulations are set to expire on 09/17/2020.  Please update these rules through Firebase for future use of the app.

### Firestore Structure
Firestore is the subset of Firebase that deals with user data storage within a database.  It is structured using collections which resemble directories and within collections there are documents that contain the actual fields of data.  Documents may also contain collections which leads to a hierarchical database structure.  Below describes how our Firestore database is structured:

 - users - Collection of users where the document id is the uid of the user.  There are two types of users: students and instructors
   - Student user
     - accuracy - Number representing overall question accuracy
     - avgResponseRate - Number representing average response time per question
     - class - Reference to class collection to which this student belongs
     - enemy - Array representing a list of enemy vehicles
     - friendly - Array representing a list of friendly vehicles
     - focus - String representing regulatory focus type
     - name - String representing student name
     - pass - String representing password
     - totalSessions - Number representing total sessions played
     - totalTime - Number representing total time played
     - uid - String representing the uid of the student
     - user - String representing username/email of student
     - userType - String representing whether this is a student or instructor
     - sessions - Collection of all sessions played where the document id is a timestamp of when the session ended.
       - points - Number representing total points earned during the session
       - time - Number representing the timestamp of when the session ended
       - type - String representing the type of training (ie Forced Choice, Go/No-Go, Tutorial)
       - answers - Collection of answers for this session where the document id is the question number 01-20
         - expected - String representing expected answer
         - received - String representing received answer
         - id - Number representing the question id
         - time - Number representing the response time
         - image - String representing the path to the image shown
         - vehicleName - String representign the vehicle name
   - Instructor user
     - enemy - Array representing a list of enemy vehicles
     - friendly - Array representing a list of friendly vehicles
     - focus - String representing regulatory focus type
     - name - String representing student name
     - pass - String representing password
     - uid - String representing the uid of the student
     - user - String representing username/email of student
     - userType - String representing whether this is a student or instructor
     - classes - Collection of all classes where the document id is the name of the class
       - students - Map from student uid to student name in this class
       - assignments - Collection of all assignments for this class where the document id is the name of the assignment
         - description - String representing the description for the assignment
         - enemy - Array representing a list of enemy vehicles
         - friendly - Array representing a list of friendly vehicles
         - enemyAccuracy - Number representing the enemy accuracy requirement to complete assignment
         - friendlyAccuracy - Number representing the friendly accuracy requirement to complete assignment
         - time - Number representing the time requirement to complete assignment
         - name - String representing the name of the assignment

## App Flow Chart
![FlowChart](https://github.com/enyaxing/arl-gamified-training/blob/master/Flow%20Chart.png)

## Miscellaneous Files
Some miscellaneous files found in the project that don't contain actual Swift code.
 - Flow Chart.png - Image of a flowchart of the app
 - Podfile - Contains cocoapods installed into the app
 - .swiftlint.yml - Style guidelines enforced by swiftlint
 - calculation.py - Python file for calculating regulatory focus heuristic using promotion and prevention scores from questionairre
 - tags.json - Json file that contains tags for images
 - CID Images - A directory containing images used during training sessions.  Images are categarorized by type of vehicle.

## Notes
The master branch contains all features except AR and 3D view.  To view these features, please switch to the ar branch.  The reason for this separation is for simulation purposes.  All features can be simulated on a Mac without an iPhone except for the AR and 3D views which require a physical iPhone.  
There are more in depth README files as you navigate further into the project.  They list fields, functions, dependencies, and purpose of each file.
