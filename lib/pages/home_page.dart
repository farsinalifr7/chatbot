import 'package:chatpot/pages/intro_page.dart';
import 'package:chatpot/pages/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    // TODO: implement dispose
    flutterTts.stop();
    super.dispose();
  }

  // final isInput = false;
  final FlutterTts flutterTts = FlutterTts();

  bool showValueindicator = false;
  double? boxHeight = 60;
  double? boxWidth = 80;
  List<MessageModel> prompt = [];
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _targetKey = GlobalKey();
  void _scrollToTarget() {
    final RenderBox renderBox =
        _targetKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    _scrollController.animateTo(
      offset.dy,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // text to speech function
  Future _speakWithCustomization(String text) async {
    //await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.3); // Adjust pitch
    //await flutterTts.setRate(0.5); // Adjust rate
    await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
    flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  Future<void> sendMessage() async {
    final message1 = _controller.text;
    setState(() {
      _controller.clear();
      prompt.add(
          MessageModel(isInput: true, message: message1, time: DateTime.now()));
      _scrollToBottom();
      showAnimation();
      showValueindicator = true;
    });

    final content = [Content.text(message1)];
    final responce = await model.generateContent(content);
    // responce.text!.replaceAll('*', '');
    setState(() {
      prompt.add(MessageModel(
          isInput: false,
          message: responce.text!.replaceAll('**', ""),
          time: DateTime.now()));
      _scrollToBottom();
      showValueindicator = false;
      // flutterTts.setRate(0.5);
      _speakWithCustomization(responce.text!);
    });
  }

  final TextEditingController _controller = TextEditingController();
  final model = GenerativeModel(
      model: "gemini-pro", apiKey: "AIzaSyDsdx4rHgw_0CeCQKGFqYELV-4rSAszO1U");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home Page'),
      // ),
      body: Column(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const IntroPage()));
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                      )),
                  const SizedBox(
                    width: 35,
                  ),
                  AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    height: boxHeight,
                    width: boxWidth,
                    child: Image.asset(
                        "asset/images/vecteezy_small-robots-futuristic-marvels-of-artificial-intelligence_24238434.png"),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  // const Text(
                  //   "Chatbot",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 24,
                  //     color: Colors.white,
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  // physics: const ClampingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: prompt.length,
                  itemBuilder: (context, index) {
                    final message = prompt[index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5)
                              .copyWith(
                                  left: message.isInput ? 40 : 8,
                                  right: message.isInput ? 8 : 40),
                          child: Container(
                            decoration: BoxDecoration(
                              color: message.isInput
                                  ? const Color.fromARGB(255, 230, 232, 247)
                                  // : const Color.fromARGB(255, 219, 240, 219),
                                  : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(25),
                                topRight: message.isInput
                                    ? Radius.zero
                                    : const Radius.circular(25),
                                bottomLeft: const Radius.circular(25),
                                bottomRight: const Radius.circular(25),
                              ),
                            ),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText(
                                    message.message,
                                    style: GoogleFonts.lora(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          color: message.isInput
                                              ? Colors.black
                                              : Colors.grey[700],
                                          letterSpacing: .5),
                                    ),
                                    // style: TextStyle(
                                    //     fontWeight: message.isInput
                                    //         ? FontWeight.normal
                                    //         : FontWeight.w400,
                                    //     color: message.isInput
                                    //         ? Colors.black
                                    //         : Colors.green[700]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: message.isInput ? 10 : 65),
                            child: Text(
                              DateFormat('hh:mm a').format(message.time),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    );
                  })),
          if (showValueindicator == true)
            CircularProgressIndicator(
              // value: 0.6,
              backgroundColor: Colors.indigo[200],
              color: Colors.deepPurple,
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    height: 50,
                    //width: 280,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        onSubmitted: (value) {
                          sendMessage();
                        },
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          // border: OutlineInputBorder(),
                          // prefixIcon: Icon(
                          //   Icons.search,
                          //   color: Colors.grey,
                          // ),
                          hintText: "   Type here..",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    //FocusScope.of(context).unfocus();
                    //const CircularProgressIndicator();
                    //fetchNews(widget.category.toLowerCase());
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //borderRadius: BorderRadius.circular(12),
                        color: Colors.blueGrey[300]),
                    child: const Center(
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showAnimation() {
    boxHeight = 80;
    boxWidth = 200;
    Future.delayed(
        const Duration(
          milliseconds: 2000,
        ), () {
      boxHeight = 60;
      boxWidth = 50;
    });
    Future.delayed(
        const Duration(
          milliseconds: 1000,
        ), () {
      boxWidth = 200;
      boxHeight = 80;
    });
  }
}
