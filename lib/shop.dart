import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';


class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Model>(
      builder: (context, value, child) {
        bool isAffordable = (value.bits >= value.batteryCurrentCosts);

        return Container(
          color: Color.fromARGB(255, 41, 48, 76),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                if (value.health == 0) {
                  final messenger = ScaffoldMessenger.of(context);
                  value.playsfx('shopPress');

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
                          'Health is already full!  (´ ˘ `)',
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
                  if (isAffordable) {
                    value.playsfx('shopBuy');
                    value.repairComputer();
                    final messenger = ScaffoldMessenger.of(context);

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
                            'Purchased Computer Repair!! Computer is now back to health! <:',
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
                    value.playsfx('shopPress');
                    final messenger = ScaffoldMessenger.of(context);

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
                            'Not enough bits to repair the computer! >:',
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
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),

                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      172,
                      164,
                      232,
                    ).withOpacity(0.09),
                    borderRadius: BorderRadius.circular(0.5),
                    border: Border.all(
                      width: 4.5,
                      color: const Color.fromARGB(255, 139, 146, 164),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 11,
                      bottom: 10.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            bottom: 6.0,
                          ),
                          child: Image.asset(
                            'assets/heart.png',
                            fit: BoxFit.contain,
                            height: 45,
                          ),
                        ),

                        const Text(
                          "Computer Repair",
                          style: TextStyle(
                            color: Color.fromARGB(255, 244, 246, 253),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${value.batteryCurrentCosts} Bits',
                          style: TextStyle(
                            color: Color.fromARGB(255, 244, 246, 253),
                            fontSize: 23,
                          ),
                        ),
                        SizedBox(height: 10),
                        const Text(
                          "REPAIRS YOUR COMPUTER! BACK AT FULL HEALTH!",
                          style: TextStyle(
                            color: Color.fromARGB(255, 244, 246, 253),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        const Text(
                          "INFO: when your computer is broken, your AUTO will be set back to DEFAULT until fixed >;",
                          style: TextStyle(
                            color: Color.fromARGB(255, 244, 246, 253),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
