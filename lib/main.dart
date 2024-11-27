import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movies/movies.dart';

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
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ModularApp(
      module: MoviesModule(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          scrollbarTheme: ScrollbarThemeData(
            thumbVisibility: WidgetStateProperty.all<bool>(true),
          ),
        ),
        routerConfig: Modular.routerConfig,
      ),
    ),
  );
}
