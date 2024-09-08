import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        body: SafeArea(
            child: Column(
              children: [
              const Padding(
              padding: EdgeInsets.only(top: 30),
              ),
              const Text(
                'Виселица',
                style: TextStyle(
                    fontFamily: 'swampy_clean',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                  //textAlign: TextAlign.center,
                ),
              const Padding(
              padding: EdgeInsets.only(top: 30),
              ),
              const Image(image: AssetImage('my_res/images/gallow.png'),),
              const Padding(
              padding: EdgeInsets.only(top: 60),
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.deepPurple[700],
                      fixedSize: const Size(120,70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2),
                      )),
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, '/game');
                  },
                child: const Text('Play',
                  style: TextStyle(color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'swampy_clean'),)),

            ],)
        )
    );
  }
}
