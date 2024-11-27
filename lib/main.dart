import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/movies/movies_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
        (_) {
      runApp(const Placeholder());
    },
  );
}

@pragma("vm:entry-point")
void moviesView() {
  moviesApp();
}
