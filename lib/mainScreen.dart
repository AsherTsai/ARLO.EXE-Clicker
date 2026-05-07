import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _scanlineController;

  @override
  void initState() {
    super.initState();

    _scanlineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Speed of the crawl
    )..repeat();
  }

  @override
  void dispose() {
    _scanlineController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Model>(
      builder: (context, value, child) {
        return Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/${value.quokka}${value.image}.png',
                fit: BoxFit.cover,
                height: 330,
                width: 230,
              ),
            ),
            Positioned.fill(
              child: ClipRect(
                child: AnimatedBuilder(
                  animation: _scanlineController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ScanlinePainter(_scanlineController.value),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ScanlinePainter extends CustomPainter {
  final double animationValue;
  ScanlinePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 172, 164, 232).withOpacity(0.09)
      ..strokeWidth = 20.0;

    double gap = 40.0;

    double steps = 10.0;
    double steppedValue = (animationValue * steps).floor() / steps;
    double offset = steppedValue * gap;

    for (double y = -gap; y < size.height; y += gap) {
      double currentY = y + offset;
      canvas.drawLine(Offset(0, currentY), Offset(size.width, currentY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ScanlinePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
