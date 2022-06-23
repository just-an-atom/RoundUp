import 'dart:io' show Platform;

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoundUp!',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'RounUp!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _costInput = TextEditingController();
  String roundUpDisplay = "Enter Cost Below";
  String _resultString = "";
  double _result = 0;
  String os = Platform.operatingSystem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent)),
                        onPressed: () => {
                          if (_resultString.isNotEmpty)
                            {
                              FlutterClipboard.copy(_resultString),
                              HapticFeedback.lightImpact(),
                              print("Copied value: " + _resultString),
                            }
                        },
                        child: Text(
                          roundUpDisplay,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _result == 0
                          ? const SizedBox()
                          : Text(
                              "Nearest dollar is $roundUpDisplay away!",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _costInput,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        textCapitalization: TextCapitalization.none,
                        keyboardType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                decimal: true,
                                signed: true,
                              )
                            : TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        minLines: 1,
                        maxLines: 1,
                        autofocus: true,
                        autocorrect: false,
                        onChanged: (_val) {
                          if (_val.isNotEmpty) {
                            double _doubleVal = double.parse(_val);
                            int _roundedVal = _doubleVal.ceil();

                            _result = _roundedVal - _doubleVal;

                            if (_result == 0) {
                              _result = 1;
                            }

                            _resultString = _result.toStringAsFixed(2);
                          }

                          setState(() {
                            if (_val.isNotEmpty) {
                              roundUpDisplay = "\$" + _resultString;
                            } else {
                              _result = 0;

                              roundUpDisplay = "Enter Cost Below";
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Cost",
                          labelStyle: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 200, bottom: 0),
                        child: const Text("Made with ♥️ by Adam"),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
