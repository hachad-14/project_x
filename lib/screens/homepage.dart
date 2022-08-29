// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, avoid_unnecessary_containers, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, avoid_print, unnecessary_string_interpolations
import 'dart:html';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart' as stts;
import 'package:text_to_speech/text_to_speech.dart';
import 'package:translator/translator.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_audio_manager/flutter_audio_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  final String apiKey = "AIzaSyDVVL3xd6st3YnY3dN7DE-vD1JQ_D9SCS4";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final translator = GoogleTranslator();

  final speaker = TextToSpeech();

  var _speechToText = stts.SpeechToText();
  bool islistening = false;
  final String _currentLocaleId = 'fr';
  String fText = "Appuyer sur le micro pour lancer la discussion.";
  String rText = "...";

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
            localeId: _currentLocaleId,
            onResult: (result) => setState(() {
                  fText = result.recognizedWords;
                  translate();
                }));
      }
    } else {
      setState(() {
        islistening = false;
      });
      _speechToText.stop();
    }
  }

  void copy() {
    FlutterClipboard.copy(rText).then((value) => print('copied'));
    Fluttertoast.showToast(
        msg: "The translated sentence has been copied.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void translate() {
    translator.translate(fText, from: 'fr', to: 'es').then((output) {
      setState(() {
        rText = output.toString();
      });
    });
  }

  void speak() async {
    await FlutterAudioManager.changeToSpeaker();
    speaker.setVolume(1.0);
    speaker.setRate(1.0);
    speaker.setPitch(1.0);
    speaker.setLanguage("es");
    speaker.speak(rText);
    speaker.speak("je mappeler zizi et jai 22 ans");
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
              margin: const EdgeInsets.only(top: 30),
              height: 60,
              width: 380,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 0.5,
                        blurRadius: 2,
                        offset: Offset(0, 1))
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 120, left: 120),
                    child: Text("Project X v0.1",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0),
            child: Container(
                margin: const EdgeInsets.only(top: 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                          width: 380,
                          height: 250,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 0.5,
                                    blurRadius: 2,
                                    offset: Offset(0, 1))
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 22, right: 22),
                                child: Text(fText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                          width: 380,
                          height: 170,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 0.5,
                                    blurRadius: 2,
                                    offset: Offset(0, 1))
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(rText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 130, left: 0),
                              child: FloatingActionButton(
                                onPressed: () {
                                  copy();
                                  print("copy");
                                },
                                child: Icon(islistening
                                    ? Icons.copy
                                    : Icons.copy_sharp),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: FloatingActionButton(
                                onPressed: () {
                                  speak();
                                  print("speak");
                                },
                                child: Icon(islistening
                                    ? Icons.speaker
                                    : Icons.speaker),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ])),
          ),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: islistening,
          glowColor: Colors.red,
          endRadius: 80,
          duration: Duration(seconds: 1),
          repeat: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        listen();
                        print("object");
                      },
                      child: Icon(islistening ? Icons.mic : Icons.mic_none),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
