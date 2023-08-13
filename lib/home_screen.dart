import 'package:coincap/Model/ModelCoin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


import 'coin_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = 'loading....';

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[800],
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image(image: AssetImage('assets/images/logo.png')),
            // SpinKitWave(
            //   color: Colors.white,
            //   size: 30.0,
            // ),
            Container(
              height: 400,
              width: 400,
              child: Lottie.network(
                  'https://assets-v2.lottiefiles.com/a/34238bb6-3140-11ee-9a60-5b3ea550ef4e/BVNMkfgnpH.json'),
            ),

          ],
        )),
      ),
    );
  }

  Future<void> getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Model_Coin> cryptoList = response.data['data']
        .map<Model_Coin>(
            (jsonMapObject) => Model_Coin.formJsonObject(jsonMapObject))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoinListScreen(
          cryptoList: cryptoList,
        ),
      ),
    );
  }
}
