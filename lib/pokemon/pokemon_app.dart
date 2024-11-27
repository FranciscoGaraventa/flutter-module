import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/entry_point_placeholder.dart';

const methodChannel = MethodChannel("com.globant.flutter.Pokemon");

void pokemonApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EPokemon',
      color: Colors.white,
      home: EServicesBridge(),
    ),
  );
}

class EServicesBridge extends StatefulWidget {
  const EServicesBridge({super.key});

  @override
  State<EServicesBridge> createState() => _EServicesBridgeState();
}

class _EServicesBridgeState extends State<EServicesBridge> {
  StreamController<_PokemonFeatures> controller = StreamController<_PokemonFeatures>.broadcast();

  @override
  void initState() {
    super.initState();
    methodChannel.setMethodCallHandler(
          (call) async {
        var feature = _PokemonFeatures.values.firstWhere((st) => st.name == call.method);
        switch (feature) {
          case _PokemonFeatures.pokemonDetails:
            controller.sink.add(_PokemonFeatures.pokemonDetails);
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
      child: StreamBuilder<_PokemonFeatures>(
        stream: controller.stream,
        builder: (
            BuildContext context,
            AsyncSnapshot<_PokemonFeatures> snapshot,
            ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const EntryPointPlaceholder();
          }

          if (snapshot.hasData) {
            switch (snapshot.data) {
              case _PokemonFeatures.pokemonDetails:
                return const SizedBox.shrink();
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

enum _PokemonFeatures {
  pokemonDetails,
}
