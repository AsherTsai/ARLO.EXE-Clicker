import 'package:computer_clicker_game/mainScreen.dart';
import 'package:computer_clicker_game/pageSwitches.dart';
import 'package:computer_clicker_game/shop.dart';
import 'package:computer_clicker_game/world.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //page variables and functions
  Widget currentPage = WorldPage();

  void switchPage(int pageNumber) {
    final myModel = Provider.of<Model>(context, listen: false);
    if (pageNumber == 1) {
      setState(() {
        myModel.clickColor(pageNumber);
        currentPage = WorldPage();
      });
    } else {
      setState(() {
        currentPage = ShopPage();
        myModel.clickColor(pageNumber);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // CONSUMER - this is what allows us to use the variables and functions from the model file
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 194, 190, 205),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 15),
          child: Column(
            children: [
              Consumer<Model>(
                builder: (context, value, child) => Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 60, 70, 103),

                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ],
                    color: Color.fromARGB(255, 226, 222, 235),
                    border: Border.all(
                      color: Color.fromARGB(255, 60, 70, 103),
                      width: 4.5,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(1.5)),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      // Bits Icon
                      children: [
                        SizedBox(width: 15),
                        Image.asset(
                          'assets/bits.png',
                          fit: BoxFit.contain,
                          height: 25,
                        ),
                        SizedBox(width: 10),
                        // Bits Text
                        Expanded(
                          child: RichText(
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: value.formattedBits,

                                  style: TextStyle(
                                    fontSize: 34,
                                    fontFamily: 'Tiny5',
                                    color: Color.fromARGB(255, 24, 30, 50),
                                  ),
                                ),
                                TextSpan(
                                  text: value.type,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontFamily: 'Tiny5',
                                    color: Color.fromARGB(255, 25, 30, 47),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 14),
                        //Health Bar
                        Image.asset(
                          'assets/health bar/${value.health}.png',
                          fit: BoxFit.contain,
                          height: 29,
                          alignment: Alignment.center,
                        ),
                        SizedBox(width: 11),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              //ARLO
              Container(
                height: 200,
                width: double.infinity,

                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 60, 70, 103),

                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ],
                  color: Color.fromARGB(255, 41, 48, 76),
                  border: Border.all(
                    color: Color.fromARGB(255, 60, 70, 103),
                    width: 4.5,
                  ),
                  borderRadius: BorderRadius.circular(1.5),
                ),
                child: Mainscreen(),
              ),
              SizedBox(height: 15),

              Consumer<Model>(
                builder: (context, value, child) => Row(
                  children: [
                    //WORLD BUTTON / BUTTON 1
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        value.page = 1;
                        switchPage(1);
                      },
                      child: Container(
                        width: 66,
                        height: 47,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 60, 70, 103),

                              offset: Offset(
                                0,
                                5,
                              ), // changes position of shadow
                            ),
                          ],
                          color: value.clickOne,
                          border: Border.all(
                            color: Color.fromARGB(255, 60, 70, 103),
                            width: 4.5,
                          ),
                          borderRadius: BorderRadius.circular(1.5),
                        ),

                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/worldIcon.png',
                            fit: BoxFit.cover,
                            height: 28,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    //SHOP BUTTON / BUTTON 2
                    GestureDetector(
                      onTap: () {
                        value.page = 2;

                        switchPage(2);
                      },
                      child: Container(
                        width: 66,
                        height: 47,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 60, 70, 103),

                              offset: Offset(
                                0,
                                5,
                              ), // changes position of shadow
                            ),
                          ],
                          color: value.clickTwo,
                          border: Border.all(
                            color: Color.fromARGB(255, 60, 70, 103),
                            width: 4.5,
                          ),
                          borderRadius: BorderRadius.circular(1.5),
                        ),

                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/shopIcon.png',
                            fit: BoxFit.cover,
                            height: 28,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 60, 70, 103),

                                offset: Offset(
                                  0,
                                  5,
                                ), // changes position of shadow
                              ),
                            ],
                            color: Color.fromARGB(255, 241, 238, 238),
                            border: Border.all(
                              color: Color.fromARGB(255, 60, 70, 103),
                              width: 4.5,
                            ),
                            borderRadius: BorderRadius.circular(1.5),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: value.display.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Tiny5',
                                        color: Color.fromARGB(255, 60, 70, 103),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              //BOTTOM PAGE
              Consumer<Model>(
                builder: (context, value, child) =>
                    SwitchPage(child: currentPage),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
