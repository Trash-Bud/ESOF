// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ChangeLanguageWidget();
  }
}

class _ChangeLanguageWidget extends State<ChangeLanguageWidget> {
  bool _isPortuguese = true;
  final String _flagPT = "lib/images/PTFlag.png";
  final String _flagEng = "lib/images/ENGFlag.png";
  String _textPT = "Bem Vindo!";
  String _textENG = "Welcome!";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SigarraPay',
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("lib/images/Menu.png",fit: BoxFit.contain, height: 30 ),
              Image.asset("lib/images/Bell.png",fit: BoxFit.contain, height: 30 ),
              Image.asset("lib/images/Logo.png",fit: BoxFit.contain, height: 32 ),
              InkWell(
                child: Image.asset((_isPortuguese ? _flagPT: _flagEng),fit: BoxFit.contain, height: 20, ),
                onTap: (){_toggleLanguage();},
              ),

              Image.asset("lib/images/User.png",fit: BoxFit.contain, height: 30 ),

            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(
                (_isPortuguese ? _textPT : _textENG),
                style: TextStyle(color: Colors.red,
                  fontFamily: 'Inter',
                  fontSize: 50,
                )
            ),
              Text(
                  "Joana Mesquita - up201907878",
                  style: TextStyle(color: Colors.red,
                    fontFamily: 'Inter',
                    fontSize: 20,
                  )
              ),
              Text(
                  "Miguel Freitas - up201906159",
                  style: TextStyle(color: Colors.red,
                    fontFamily: 'Inter',
                    fontSize: 20,
                  )
              ),
              Text(
                  "Diogo Pereira -  up201906422",
                  style: TextStyle(color: Colors.red,
                    fontFamily: 'Inter',
                    fontSize: 20,
                  )
              ),
              Text(
                  "Carolina Figueira - up201906845",
                  style: TextStyle(color: Colors.red,
                    fontFamily: 'Inter',
                    fontSize: 20,
                  )
              ),
              Text(
                  "Guilherme Diogo -  up201806340",
                  style: TextStyle(color: Colors.red,
                    fontFamily: 'Inter',
                    fontSize: 20,
                  )
              )]
          ),
        ),

      ),
    );
  }

  void _toggleLanguage() {
    setState(() {
      _isPortuguese = !_isPortuguese;
    });
  }
}

class ChangeLanguageWidget extends StatefulWidget {
  const ChangeLanguageWidget({Key? key}) : super(key: key);

  @override
  _ChangeLanguageWidget createState() => _ChangeLanguageWidget();
}

