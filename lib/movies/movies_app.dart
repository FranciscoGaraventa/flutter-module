import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/movies.dart';

import '../widget/entry_point_placeholder.dart';

const methodChannel = MethodChannel("com.globant.movies.channel");

void moviesApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EMovies',
      color: Colors.white,
      home: Bridge(),
    ),
  );
}

class Bridge extends StatefulWidget {
  const Bridge({super.key});

  @override
  State<Bridge> createState() => _BridgeState();
}

class _BridgeState extends State<Bridge> {
  StreamController<_MoviesFeatures> controller = StreamController<_MoviesFeatures>.broadcast();

  @override
  void initState() {
    super.initState();
    methodChannel.setMethodCallHandler(
          (call) async {
        var feature = _MoviesFeatures.values.firstWhere((st) => st.name == call.method);
        switch (feature) {
          case _MoviesFeatures.movieDetails:
            controller.sink.add(_MoviesFeatures.movieDetails);
            break;
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
      child: StreamBuilder<_MoviesFeatures>(
        stream: controller.stream,
        builder: (
            BuildContext context,
            AsyncSnapshot<_MoviesFeatures> snapshot,
            ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const EntryPointPlaceholder();
          }

          if (snapshot.hasData) {
            switch (snapshot.data) {
              case _MoviesFeatures.movieDetails:
                return const MovieDetails();
              default:
                return const EntryPointPlaceholder();
            }
          }
          return const EntryPointPlaceholder();
        },
      ),
    );
  }
}

enum _MoviesFeatures {
  movieDetails,
}
