# 0xchat App

0xchat App for iOS & Android

## Getting Started

Follow the steps below to run the project:

1. Ensure you're using Flutter version `3.13.7`. Switch to this version before proceeding.
2.
First, you'll need to run the provided shell script in the main project directory:

```
sh ox_pub_get.sh
```

3. If you build this App on iOS platform, need go to the `ios` directory and install the required dependencies using CocoaPods:

   ```
   cd ios & pod install
   ```

4. Finally, Execute build command

   ```
   flutter build apk  //Android apk
   flutter build ios  //iOS app
   ```