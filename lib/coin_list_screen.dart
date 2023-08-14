import 'package:coincap/Model/ModelCoin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


import 'constant/constants.dart';

class CoinListScreen extends StatefulWidget {
  //1badesh data miyad inja va in list por mishe
  CoinListScreen({Key? key, this.cryptoList}) : super(key: key);
  List<Model_Coin>? cryptoList;
  @override
  _CoinListScreenState createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  List<Model_Coin>? cryptoList;
  bool isSearchLoadingVisible = false;
  @override
  void initState() {
    super.initState();
    //2 tavasot widget.cryptoList be class bala dast resi darim
    //hala ** in state dakhe widget balast
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        title: Text(

          'کیریپتو بازار',
          style: TextStyle(color: redColor,fontFamily: 'mr'),
        ),
        centerTitle: true,
        //icon back appbar ke back neshon nemideh
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                onChanged: (value) {
                  _fiterList(value);
                },
                decoration: InputDecoration(
                    hintText: 'اسم رمزارز معتبر را سرچ کنید',
                    hintStyle: TextStyle(fontFamily: 'mr', color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    filled: true,
                    fillColor: greenColor),
              ),
            ),
          ),
          Visibility(
            visible: isSearchLoadingVisible,
            child: Text(
              '...در حال اپدیت اطلاعات رمز ارزها',
              style: TextStyle(color: greenColor, fontFamily: 'mr'),
            ),
          ),
          Expanded(
            //RefreshIndicator onRefresh dareh ke vaghti karbar
            //safaro mikeshe paiin in call mishe
            //ke ma dobareh dataro migirim setstate mikonim to list
            child: RefreshIndicator(
              //rang dayereh RefreshIndicator
              backgroundColor: greenColor,
              //rang flesh RefreshIndicator
              color: blackColor,
              onRefresh: () async {
                List<Model_Coin> fereshData = await _getData();
                setState(() {
                  cryptoList = fereshData;
                });
              },
              //va bache RefreshIndicator mishe listviewmon
              child: ListView.builder(
                itemCount: cryptoList!.length,
                itemBuilder: (context, index) {
                  //inja har bar yeki az item haye list ro mideh behesh ke ye iteam besazeh
                  //ro safhe
                  return _getListTileItem(cryptoList![index]);
                },
              ),
            ),
          )
        ],
      )),
    );
  }
//2 inja ye ListTile barmigardoneh
  Widget _getListTileItem(Model_Coin crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(color: greenColor),
      ),
      subtitle: Text(
        crypto.symbol,
        style: TextStyle(color: greyColor),
      ),
      leading: SizedBox(
        width: 30.0,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: TextStyle(color: greyColor),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  //ta 2 ragham ashar bokhoreh
                  crypto.priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: greyColor, fontSize: 18),
                ),
                Text(
                  crypto.changePercent24hr.toStringAsFixed(2),
                  style: TextStyle(
                    //inja estefadeh shode to rang matn gheymata
                    color: _getColorChnageText(crypto.changePercent24hr),
                  ),
                )
              ],
            ),
            SizedBox(
                width: 50,
                child: Center(
                  //inja miyarim _getIconChangePercent estefadeh mikonim
                  //va vorodi crypto.changePercent24hr besh midim
                  child: _getIconChangePercent(crypto.changePercent24hr),
                )),
          ],
        ),
      ),
    );
  }

  //ye method darim _getIconChangePercent ke ye vorodi migireh
  //age vorodi < kochiktar ya = mosavi ba 0 bashe flesh ro be paiin
  //vagarna ro be bala
  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? Icon(
            Icons.trending_down,
            size: 24,
            color: redColor,
          )
        : Icon(
            Icons.trending_up,
            size: 24,
            color: greenColor,
          );
  }
//ye method darim ke ye vordi migireh age vorodi kochiktar ya mosavi ba 0
//bashe red nabashe sabz ro barmigardoneh
  Color _getColorChnageText(double percentChange) {
    return percentChange <= 0 ? redColor : greenColor;
  }

  //inja kole data ro az server migireh va mirizeh dakhel list barmigardoneh
  Future<List<Model_Coin>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Model_Coin> cryptoList = response.data['data']
        .map<Model_Coin>((jsonMapObject) => Model_Coin.formJsonObject(jsonMapObject))
        .toList();
    return cryptoList;
  }

  Future<void> _fiterList(String enteredKeyword) async {
    List<Model_Coin> cryptoResultList = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        isSearchLoadingVisible = true;
      });
      var result = await _getData();
      setState(() {
        cryptoList = result;
        isSearchLoadingVisible = false;
      });
      return;
    }
    cryptoResultList = cryptoList!.where((element) {
      return element.name.toLowerCase().contains(enteredKeyword.toLowerCase());
    }).toList();

    setState(() {
      cryptoList = cryptoResultList;
    });
  }
}
