import 'package:engineer/app_router.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  get kPrimaryButtonColor => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgprimary,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(alignment: Alignment.center, children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/main_top.png", width: 120),
          ),
          SafeArea(
              child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Welcome to Engineer App",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                            color: textprimary),
                      ),
                      const SizedBox(
                        height: defaultPadding * 2,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Expanded(
                            flex: 8,
                            child: SvgPicture.asset(
                              "assets/icons/Maintenance-amico.svg",
                            ),
                          ),
                          const Spacer()
                        ],
                      ),
                      const SizedBox(
                        height: defaultPadding * 2,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Expanded(
                          flex: 8,
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool('welcomeStatus', true);
                                  Navigator.pushNamed(context, AppRouter.login);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: bluedark,
                                  shadowColor: bluedark,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)),
                                  minimumSize: const Size(400, 50),
                                ),
                                child: Text(
                                  "Login".toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              // ElevatedButton(
                              //     onPressed: () async {
                              //       SharedPreferences prefs =
                              //           await SharedPreferences.getInstance();
                              //       prefs.setBool('welcomeStatus', true);
                              //       Navigator.pushNamed(
                              //           context, AppRouter.register);
                              //     },
                              //     style: ElevatedButton.styleFrom(
                              //       backgroundColor: primary,
                              //       shadowColor: primaryDark,
                              //       elevation: 0,
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius:
                              //               BorderRadius.circular(18.0)),
                              //       minimumSize: const Size(400, 50),
                              //     ),
                              //     child: Text(
                              //       "Sign Up".toUpperCase(),
                              //       style: const TextStyle(
                              //           color: Colors.white, fontSize: 20.0),
                              //     ),)
                            ],
                          )),
                      const Spacer()
                    ],
                  ),
                ],
              ),
            ),
          ))
        ]),
      ),
    );
  }
}
