import 'package:flutter/material.dart';

class EntryPointPlaceholder extends StatelessWidget {
  const EntryPointPlaceholder({super.key});

  static const containerHeight = 150.0;
  static const textFontSize = 15.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: containerHeight,
        width: double.infinity,
        color: Colors.white,
        child: const Center(
          child: Text(
            'Entry Point Undefined',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black38,
              fontSize: textFontSize,
            ),
          ),
        ),
      ),
    );
  }
}
