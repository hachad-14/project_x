// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, avoid_unnecessary_containers, library_private_types_in_public_api
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stts;
import 'package:path_provider_ios/path_provider_ios.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _speechToText = stts.SpeechToText();
  bool islistening = false;
  String fText = "Appuyer sur le micro pour lancer la discussion.";

  void listen() async {
    if (!islistening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => print("$status"),
        onError: (errorNotification) => print("$errorNotification"),
      );
      if (available) {
        setState(() {
          islistening = true;
        });
        _speechToText.listen(
            onResult: (result) => setState(() {
                  fText = result.recognizedWords;
                }));
      }
    } else {
      setState(() {
        islistening = false;
      });
      _speechToText.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    _speechToText = stts.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[ 
        Align(
          alignment: Alignment(0, 0),
          child: Container(
            margin: const EdgeInsets.only(top:30),
            height: 60,
            width: 380,
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3),spreadRadius: 0.5,blurRadius: 2, offset: Offset(0, 1))]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,              
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 120, left: 120),
                  child: Text("Project X", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment(0, 0),
          child: Container(
            margin: const EdgeInsets.only(top:0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,              
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50,left: 20),
                  child: Text(fText, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                ),
              ]
            )
          ),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: islistening,
        glowColor: Colors.red,
        endRadius: 80,
        duration: Duration(seconds: 1),
        repeat: true,
        child: FloatingActionButton(
          onPressed: () {
            listen();
          },
          child: Icon(islistening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}
