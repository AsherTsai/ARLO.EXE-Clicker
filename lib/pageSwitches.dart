import 'package:flutter/material.dart';

class SwitchPage extends StatelessWidget {
  final Widget child;

  const SwitchPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(255, 11, 11, 13),
            width: 4.5,
          ),
          borderRadius: BorderRadius.circular(1.5),
        ),
        child: child,
      ),
    );
  }
}
