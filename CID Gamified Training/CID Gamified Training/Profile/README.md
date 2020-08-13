# arl-gamified-training

X-Force Summer 2020

# Profile

## Profile.swift

View for the profile page of a user. This allows for display of user name, email, statistics, and past sessions after fetching from Firebase. This can also be accessed by instructors intending to view individual student profiles.

### Fields

- `user: GlobalUser` - Reference to global user variable.
- `prevSessionIds: [String]` - List of session ids to be sorted.
- `prevSessions: [String: Session]` - Mapping from session ids to session object.
- `answers: [Answer]` - List of all answers
- `name: String` - Name of the user
- `email: String` - Email of the user.

### Functions

- `getSessions(db: CollectionReference)` - Gets list of sessions for this user from firebase.
  - Parameters: `db: CollectionReference` - Session's reference in Firebase.
- `setHeader(doc: DocumentReference)` - Obtain user name and email from Firebase.
  - Parameters: `doc:DocumentReference` - Reference to class document
- `format_time_interval(second: TimeInterval) -> String` - Formats timestamp.
  - Parameters: `second: TimeInterval` - Time interval to be formatted

### Dependencies

StatBox.swift, Summary.Swift, StatDetail.swift, StatView.swift

## StatDetail.swift

Contains detailed statistics of user performance. If viewing by vehicle, it can provide the average response time and average accuracy for each specific vehicle. If viewing by tags, it can provide a view of accuracy and time by tag. For example, a user could have an average accuracy of 78.0% correct for thermal images and an average response time of 1.5s.

### Fields

- `prevSessions: [String]` - List of previous sessions identified by their id in Firebase.
- `vehicleTime: [String: Double]` - Mapping from vehicle name to total response time.
- `tagTime: [String: Double]` - Mapping from tag to total response time.
- `vehicleAccuracy: [String: Double]` - Mapping from vehicle name to total number correct.
- `tagTime: [String: Double]` - Mapping from tag to total response time.
- `vehicleAccuracy: [String: Double]` - Mapping from vehicle name to total number correct.
- `tagAccuracy: [String: Double]` - Mapping from tag to total number correct.
- `vehicleCount: [String: Double]` - Mapping from vehicle name to total number of questions.
- `tagCount: [String: Double]` - Mapping from tag to total number of questions.
- `vehiclePercent: [String: Double]` - Mapping from vehicle name to percentage correct.
- `tagPercent: [String: Double]` - Mapping from tag to percentage correct.
- `vehicleSecond: [String: Double]` - Mapping from vehicle name to average response time in seconds.
- `tagSecond: [String: Double]` - Mapping from tag to average response time in seconds.

- `selectedTab: Int` - Selected tab: 0 == vehicles, 1 == tag.

### Functions

- `getStats(sessions: [String])` - Get stats by counting number of responses, number of correct responses, and summing response time for each vehicle and tag.
  - Parameters: `sessions` - List of session ids to loop through.

### Dependencies

StatView.swift

## StatView.swift

Serves as a subcomponent of StatDetail view. Each row in a StatDetail is a StatView. The StatView contains the name, number, and type of statistic to display.

### Fields

- `name: String` - Name of vehicle or tag
- `num: Double` - Number to be displayed. Can be accuracy percentage or time in seconds.
- `type: Int` - Type of statistic. 0 is accuracy, 1 is time.
