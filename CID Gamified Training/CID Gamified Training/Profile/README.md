# arl-gamified-training

X-Force Summer 2020

## Profile

### `Profile.swift`

View for the profile page of a user. This allows for display of user name, email, statistics, and past sessions after fetching from Firebase. This can also be accessed by instructors intending to view individual student profiles.

### `StatDetail.swift`

Contains detailed statistics of user performance. If viewing by vehicle, it can provide the average response time and average accuracy for each specific vehicle. If viewing by tags, it can provide a view of accuracy and time by tag. For example, a user could have an average accuracy of 78.0% correct for thermal images and an average response time of 1.5s.

### `StatView.swift`

Serves as a subcomponent of StatDetail view. Each row in a StatDetail is a StatView. The StatView contains the name, number, and type of statistic to display.
