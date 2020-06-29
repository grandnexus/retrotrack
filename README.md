# Retrotrack: A retro ML-powered mass facial tracking app to record temperatures within seconds by capturing a welfie photo and thermometer screen result.
<a href="https://youtu.be/42XTS2c7Grw" target="_blank"><img src='/screenshots/thumbnail.jpg' width='700' alt="Retrotrack Demo Video"/></a>
<a href="https://youtu.be/42XTS2c7Grw" target="_blank">Retrotrack Demo Video</a>

### Co-developed by Jason Choo (@grandnexus) and Philip Ch'ng (@pczn0327).

Retrotrack is a [Flutter](https://flutter.dev) retro facial temperature tracking app built in futuristic fashion powered by [Firebase Machine Learning](https://firebase.google.com/docs/ml).

The app is developed to empower mass temperature tracking within minutes. All you have to do is take a selfie or welfie photo and capture the snapshot of each person's temperature result from a thermometer screen.

Since we have to take our temperatures everyday and during my visits to different location, Retrotrack makes temperature taking fun and easy. This app can be used in both private and public spaces such as shopping malls, workplaces, schools and even private events.

The design of the app is inspired by the popular video game called [Fallout](https://fallout.bethesda.net/en/) which depicts the life after post-apocalyptic world in a wasteland.

It is created for the [#Hack20 International Flutter Hackathon](https://flutterhackathon.com) in 2020.

The user interface design of the Retrotrack consists of:
- [AuthScreen](https://github.com/grandnexus/retrotrack/blob/master/lib/ui/screens/auth_screen.dart): The auth login screen of the app.
- [CameraScreen](https://github.com/grandnexus/retrotrack/blob/master/lib/ui/screens/camera_screen.dart): The camera screen with interactive preview widgets.
- [FeedScreen](hhttps://github.com/grandnexus/retrotrack/blob/master/lib/ui/screens/feed_screen.dart): The feed screen to show the list of log entry with detected faces and temperatures.

The model classes of the Retrotrack consists of:
- [LogEntry](https://github.com/grandnexus/retrotrack/blob/master/lib/core/models/log_entry.dart): The model class to represent a log entry.
- [Person](https://github.com/grandnexus/retrotrack/blob/master/lib/core/models/person.dart): The model class to represent a person.
- [Temperature](https://github.com/grandnexus/retrotrack/blob/master/lib/core/models/temperature.dart): The model class to represent a temperature record.

The provider classes of the Retrotrack consists of:
- [CameraProvider](https://github.com/grandnexus/retrotrack/blob/master/lib/core/providers/camera_provider.dart): The provider class to control the device camera logic.
- [FeedProvider](https://github.com/grandnexus/retrotrack/blob/master/lib/core/providers/feed_provider.dart): The provider class to control the feed list logic.
- [SessionProvider](https://github.com/grandnexus/retrotrack/blob/master/lib/core/providers/session_provider.dart): The provider class to control the login auth logic.

The utility classes of the Retrotrack consists of:
- [Paints](https://github.com/grandnexus/retrotrack/blob/master/lib/core/paints.dart): The utility class to draw face detected bounding box on the images.
- [Utils](https://github.com/grandnexus/retrotrack/blob/master/lib/core/utils.dart): The utility class to process images using Firebase Machine Learning and Image packages.

## Project Dependencies
The Retrotrack app uses the following technology stack with various Flutter packages:
- [Firebase Machine Learning](https://firebase.google.com/docs/ml)
- [Provider](https://pub.dev/packages/provider)
- [Hive](https://pub.dev/packages/hive)
- [Flare by Rive](https://pub.dev/packages/flare_flutter)
- [Camera](https://pub.dev/packages/camera)
- [Google Fonts](https://pub.dev/packages/google_fonts)
- [Snappable](https://pub.dev/packages/snappable)
- [Image](https://pub.dev/packages/image)

## How To Use

Go to root project folder, type in the Terminal:

```bash
flutter create . && flutter pub get && flutter run
```
