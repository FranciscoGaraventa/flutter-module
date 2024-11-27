# flutter-module

## Table of Contents
- [About](#about)
- [Dependencies](#dependencies)
- [Requirements](#requirements)
- [Installation](#installation)
- [Code Contribution](#code-contribution)
- [Usage](#usage)

## About

**flutter-module** is a library that contains the configuration to managed flutter components on native libraries

## Dependencies

## Requirements

- Fvm
- Visual Studio Code or Android Studio

## Installation

In order to compile the component move to the ```flutter-module``` folder then run ```fvm flutter pub get``` once the compilation process 
finished you can run the example app. To address that you just need to move to the example_app folder then run ```fvm flutter pub get``` and run the app with fvm flutter run

## Code Contribution

- Define the entry-point

On ```main.dart``` file every you should have to define the entry-point that is going to manage the specific widget/screen to the specific 
library

```
@pragma("vm:entry-point")
void libraryName() {
  libraryApp();
}
```
- Define the libraryApp

The ```libraryApp``` managed all the logic to show the specific widget/screen. To communicate between native side and flutter component you need to define a ```methodChannel```

```
const methodChannel = MethodChannel("com.globant.flutter.librayName");
```

Then, a libraryApp should be created

```
void libraryApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library Name',
      color: Colors.white,
      home: LibraryBridge(),
    ),
  );
}

class LibraryBridge extends StatefulWidget {
  const LibraryBridge({Key? key}) : super(key: key);

  @override
  State<LibraryBridge> createState() => _LibraryBridgeState();
}
```

On LibraryAppState we should managed the events received from the methodChannel defined previously

```
class _LibraryBridgeState extends State<LibraryBridge> {
  StreamController<_LibrayFeature> controller = StreamController<_LibrayFeature>.broadcast();

  @override
  void initState() {
    super.initState();
    methodChannel.setMethodCallHandler(
      (call) async {
        var feature = _LibrayFeature.values.firstWhere((st) => st.name == call.method);
        switch (feature) {
          case _LibrayFeature.feature1:
            controller.sink.add(_LibrayFeature.feature1);
            break;
          case _LibrayFeature.feature2:
            controller.sink.add(_LibrayFeature.feature2);
            break;
          // ADD ANY OTHER FEATURE/SCREEN HERE
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: StreamBuilder<_LibrayFeature>(
        stream: controller.stream,
        builder: (
          BuildContext context,
          AsyncSnapshot<_LibrayFeature> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const EntryPointPlaceholder();
          }

          if (snapshot.hasData) {
            switch (snapshot.data) {
              case _LibrayFeature.feature1:
                // WIDGET/SCREEN ASSOCIATED WITH FEATURE
                return const EntryPointPlaceholder();
              default:
                //BY DEFAULT WE HAVE A WIDGET PLACEHOLDER
                return const EntryPointPlaceholder();
            }
          }
          return const EntryPointPlaceholder();
        },
      ),
    );
  }
}

enum _LibrayFeature {
  feature1,
  feature2,
  ...
}

```

## Usage

In order to use the components on your library you need to:

- Android

Depend on the Android Archive (AAR)
This option packages your Flutter Library as a generic local Maven repository composed of AARs and POMs artifacts. This option allows 
your team to build the host app without installing the Flutter SDK. You can then distribute the artifacts from a local or remote repository.

To generate you need to run:
```
  fvm flutter build aar
```

Then, follow the on-screen instructions to integrate

![Instructions](https://docs.flutter.dev/assets/images/docs/development/add-to-app/android/project-setup/build-aar-instructions.png)

- iOS

Flutter UI components can be incrementally added into your existing iOS application as embedded frameworks. To embed Flutter in your 
existing application, consider on of the following three methods

| Embedding Method                                                                                                                               | Methodology                                                                                                                      | Benefit                                                                                           |
|------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| Use CocoaPods (Recommended)                                                                                                                    | Install and use the Flutter SDK and CocoaPods Flutter compiles the flutter_module from source each time Xcode builds the iOS app | Least complicated method to embed Flutter into your app.                                          |
| Use [iOS frameworks](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/WhatAreFrameworks.html) | Create iOS frameworks for Flutter components, embed them into your iOS, and update your existing app's build settings            | Doesn't require every developer to install the Flutter SDK and CocoaPods on their local machines. |
| Use iOS frameworks and CocoaPods                                                                                                               | Embed the frameworks for your iOS app and the plugins in Xcode, but distribute the Flutter engine as a CocoaPods podspec.        | Provides and alternative to distributing the large Flutter engine (Flutter.xcframework) library.  |

When you add Flutter to your existing iOS app, it increases the size of your iOS app. To get more information about iOS project-setup to 
flutter module you can tap [here](https://docs.flutter.dev/add-to-app/ios/project-setup)

