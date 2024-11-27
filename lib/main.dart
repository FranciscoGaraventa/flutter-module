import 'package:flutter/material.dart';
import 'package:flutter_module/pokemon/pokemon_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Placeholder());
}

@pragma("vm:entry-point")
void pokemonEP() {
  pokemonApp();
}
