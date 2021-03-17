
# FirebaseFlutterStarter

  

This is a starter Flutter project that is ready to be configured with Firebase. To configure Firebase, follow the steps outlined below: 

 1. Create a Firebase project in your [Firebase Console](https://console.firebase.google.com/).
 2. [Enable Firestore](https://firebase.google.com/docs/firestore/quickstart) in your Firebase project.
 3. Update your Firestore Security Rules (be sure to follow [this link](https://firebase.google.com/docs/firestore/security/get-started) to understand how these rules work) to the following:
```
rules_version = '2';
service cloud.firestore {
    match /databases/{database}/documents {
        match /{document=**} {
            allow read, write: if request.auth != null;
        }
    }
}
```
 4. [Enable Firebase Authentication](https://firebase.google.com/docs/auth) in your Firebase project.
 5. Enable the Email/Password sign-in method in Firebase Authentication.
 ![Enabling Email/Password sign-in](https://raw.githubusercontent.com/ChopinDavid/FirebaseFlutterStarter/master/readmeImage1.png)
 6. Follow these articles to drop the [GoogleService-Info.plist](https://firebase.google.com/docs/ios/setup) and [GoogleService-Info.json](https://firebase.google.com/docs/android/setup) into the iOS and Android projects, respectively.
