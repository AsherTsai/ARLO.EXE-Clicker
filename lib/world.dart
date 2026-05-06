import 'package:computer_clicker_game/spaceBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'package:audioplayers/audioplayers.dart';

class WorldPage extends StatefulWidget {
  const WorldPage({super.key});

  @override
  State<WorldPage> createState() => _WorldPageState();
}

class _WorldPageState extends State<WorldPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _scanlineController;

  final AudioPlayer sfxPlayer = AudioPlayer();

  bool itemAvailability(int bits, int itemPrice) {
    return bits >= itemPrice;
  }

  void playSound(String sound) async {
    await sfxPlayer.resume();
  }

  @override
  void initState() {
    super.initState();

    sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
    sfxPlayer.setSource(AssetSource('SFX/click.mp3'));

    _scanlineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Speed of the crawl
    )..repeat();
  }

  @override
  void dispose() {
    _scanlineController.dispose();
    _scrollController.dispose();

    sfxPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = context.watch<Model>();
    return Container(
      child: Stack(
        children: [
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

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      value.incrementBits();
                      playSound('click');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                        width: 380,
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 118, 129, 165),
                          border: Border.all(
                            color: const Color.fromARGB(255, 118, 129, 165),
                            width: 4.5,
                          ),
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                        child: SwitchImage(),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(108, 98, 104, 113),
                        borderRadius: BorderRadius.circular(0.5),
                        border: Border.all(
                          width: 4.5,
                          color: Color.fromARGB(255, 172, 180, 206),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),

                        child: Text(
                          '${value.type} S H O P',
                          style: TextStyle(
                            color: Color.fromARGB(255, 230, 235, 248),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // SCROLL
                  SizedBox(
                    height: 400,
                    child: RawScrollbar(
                      thickness: 9.0,
                      padding: EdgeInsets.only(right: 10, left: 13),
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                          right: 15,
                          left: 5,
                        ),
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,

                          itemCount: value.currentNames.length,

                          itemBuilder: (context, index) {
                            final String itemName = value.currentNames[index];
                            final int itemCost = value.currentCosts[index];
                            final int itemValue = value.currentValues[index];
                            final int itemHitValue =
                                value.currentHitValues[index];

                            bool isAffordable = (value.bits >= itemCost);

                            final Color itembaseColor = isAffordable
                                ? const Color.fromARGB(109, 215, 226, 245)
                                : const Color.fromARGB(108, 134, 136, 152);

                            final Color itemborderColor = isAffordable
                                ? const Color.fromARGB(255, 172, 179, 202)
                                : const Color.fromARGB(255, 139, 146, 164);

                            return Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                onTap: () {
                                  if (isAffordable) {
                                    playSound('shopBuy');
                                    // Passes the current item's stats to the shop function
                                    value.shopPlus(itemValue, itemCost);
                                    value.shopHitPlus(itemHitValue, itemCost);

                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );

                                    messenger.removeCurrentSnackBar();

                                    // 2. Trigger the new one
                                    messenger.showSnackBar(
                                      SnackBar(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          51,
                                          48,
                                          71,
                                        ).withOpacity(.93),
                                        content: Center(
                                          child: Text(
                                            'PURCHASED!!! <:',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        duration: Duration(
                                          milliseconds: 2000,
                                        ), // Shorter duration for spammy actions
                                      ),
                                    );
                                  } else {
                                    playSound('shopPress');
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );

                                    messenger.removeCurrentSnackBar();

                                    // 2. Trigger the new one
                                    messenger.showSnackBar(
                                      SnackBar(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          51,
                                          48,
                                          71,
                                        ).withOpacity(.93),
                                        content: Center(
                                          child: Text(
                                            'Not enough bits! >:',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        duration: Duration(
                                          milliseconds: 2000,
                                        ), // Shorter duration for spammy actions
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  width: 160,

                                  alignment: Alignment.bottomLeft,
                                  decoration: BoxDecoration(
                                    color: itembaseColor,
                                    borderRadius: BorderRadius.circular(0.5),
                                    border: Border.all(
                                      width: 4.5,
                                      color: itemborderColor,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 11.0,
                                      bottom: 4.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 6.0,
                                          ),

                                          child: Image.asset(
                                            'assets/${value.type.toLowerCase() + "Items"}/${value.type.toLowerCase()}_${index + 1}.png',
                                            fit: BoxFit.contain,
                                            height: 45,
                                          ),
                                        ),

                                        Text(
                                          itemName,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              244,
                                              246,
                                              253,
                                            ),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "AUTO: $itemValue  BITS: $itemHitValue",
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              244,
                                              246,
                                              253,
                                            ),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "$itemCost BITS",
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              244,
                                              246,
                                              253,
                                            ),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// LINES
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
