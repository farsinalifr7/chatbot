import 'package:chatpot/pages/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final isInput = false;
  List<MessageModel> prompt = [];

  Future<void> sendMessage() async {
    final message1 = _controller.text;
    setState(() {
      _controller.clear();
      prompt.add(
          MessageModel(isInput: true, message: message1, time: DateTime.now()));
    });

    final content = [Content.text(message1)];
    final responce = await model.generateContent(content);
    setState(() {
      prompt.add(MessageModel(
          isInput: false, message: responce.text ?? "", time: DateTime.now()));
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
            height: 75,
            width: double.infinity,
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: 80,
                  child: Image.asset(
                      "asset/images/vecteezy_small-robots-futuristic-marvels-of-artificial-intelligence_24238434.png"),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  "Chatbot",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: prompt.length,
                  itemBuilder: (context, index) {
                    final message = prompt[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10)
                          .copyWith(
                              left: message.isInput ? 40 : 8,
                              right: message.isInput ? 8 : 40),
                      child: Container(
                        decoration: BoxDecoration(
                          color: message.isInput
                              ? Colors.grey[200]
                              : const Color.fromARGB(255, 219, 240, 219),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                            bottomLeft: message.isInput
                                ? const Radius.circular(15)
                                : Radius.zero,
                            bottomRight: message.isInput
                                ? Radius.zero
                                : const Radius.circular(15),
                          ),
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: GoogleFonts.lora(
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      color: message.isInput
                                          ? Colors.black
                                          : Colors.green[800],
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
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  DateFormat('hh:mm a').format(message.time),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
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
                        color: Colors.green[800]),
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
}
