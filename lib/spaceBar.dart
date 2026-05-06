import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';

class SwitchImage extends StatefulWidget {
  const SwitchImage({super.key});

  @override
  State<SwitchImage> createState() => _SwitchImageState();
}

class _SwitchImageState extends State<SwitchImage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Model>(
      builder: (context, value, child) {
        return Image.asset("assets/images/spaceKey/space${value.image}.png");
      },
    );
  }
}
