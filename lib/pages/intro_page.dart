import 'package:chatpot/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        // title: Text(
        //   "ChatPot",
        //   style: GoogleFonts.lora(
        //     textStyle: const TextStyle(
        //         fontWeight: FontWeight.w400,
        //         fontSize: 24,
        //         color: Colors.white,
        //         letterSpacing: .5),
        //   ),
        // ),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
                "asset/images/vecteezy_small-robots-futuristic-marvels-of-artificial-intelligence_24238434.png"),
            Text(
              "How can I help you today?",
              style: GoogleFonts.lora(
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    color: Colors.white,
                    letterSpacing: .5),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: Container(
                color: Colors.black,
                child: Expanded(
                  child: Image.asset(
                      "asset/images/64b5b90fb3c1a1b1e219d504a1bf7824-removebg-preview.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
