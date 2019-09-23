# Memories_Demo
This app was a pilot version for showcasing an app as a gift on any occasions. I personally used the app as a birthday gift to someone.

The project uses MVVM architecture, and Firebase at its core to store the memory cards in Firebase DB. 

Its a very small app, with just a single screen, but a little more stuff going on in the background. The app basically displays Photos and a personalized message associated with each photo. The data is configurable from the firebase database.

The app pulls memory cards from a Firebase DB Collection. The current config set for the db, has a Demo Collection with 2 documents that will be fetched on app launch.

The data is fetched from firebase initially, and saved locally in Realm DB, and thereafter pulled from local storage.

On app launch, the first card is displayed, with a animated cardview for a personalized title and message.

Thereafter, a local notification is triggered every 1 min (This is the current config. This is configurable from firebase db). The notification comes up every minute untill there are no moe cards left.

I have been planning to add more features to the app. This is just a pilot version.
