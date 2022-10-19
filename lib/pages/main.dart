import 'package:flutter/material.dart';
import 'package:tez/db/db/shared_preferences.dart';
import 'package:tez/global_widget/app_bar.dart';
import 'package:tez/pages/lists.dart';
import 'package:tez/pages/multiple_choice.dart';
import 'package:tez/pages/words_card.dart';
import 'package:tez/sipsak_metod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../global_variable.dart';
import 'dart:io' show Platform;
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}


const _url = 'https://udemy.com';
class _MainPageState extends State<MainPage> {

  //ca-app-pub-3940256099942544/6300978111
  //ca-app-pub-9294431630194064/7046472731

  // IOS APP ID : ca-app-pub-9294431630194064~2793023646
  // IOS BANNER ID : ca-app-pub-9294431630194064/3914533629

  // ANDROID APP ID : ca-app-pub-9294431630194064~4995024461
  // ANDROID BANNER ID : ca-app-pub-9294431630194064/7046472731


  String bannerID()
  {
    if (Platform.isAndroid) {
      return "ca-app-pub-9294431630194064/7046472731";
    }

    return "ca-app-pub-9294431630194064/3914533629";

  }

  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();
  PackageInfo ?packageInfo;
  String version = "";


  Container ?adContainer = Container();

  @override
  initState()  {
    // TODO: implement initState
    super.initState();
    packageInfoInit();
    setState(() {
      adContainer;
    });
  }


  void packageInfoInit() async
  {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo!.version;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width*0.5,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset("assets/images/logo.png",height: 80,),
                  const Text("QUEZY",style:  TextStyle(fontFamily: "RobotoLight",fontSize: 26),),
                  const Text("İstediğini öğren.",style: TextStyle(fontFamily: "RobotoLight",fontSize: 16),),
                  SizedBox(width:MediaQuery.of(context).size.width*0.35,child: const Divider(color: Colors.black,)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("v"+version+"\nserenaygztk@gmail.com",style: TextStyle(fontFamily: "RobotoLight",fontSize: 14,color: Color(SipsakMetod.HexaColorConverter("#0A588D"))),textAlign: TextAlign.center),
              )

            ],
          ),
        ),
      ),
      appBar: appBar(context,
          left:const FaIcon(FontAwesomeIcons.bars,color: Colors.black,size: 20,),
          center:Image.asset("assets/images/logo_text.png",height: 40),
          leftWidgetOnClick: ()=>{_scaffoldKey.currentState!.openDrawer()}
      ),

      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    langRadioButton(
                        text: "İngilizce - Türkçe",
                        group: chooseLang,
                        value: Lang.eng),
                    langRadioButton(
                        text: "Türkçe - İngilizce",
                        group: chooseLang,
                        value: Lang.tr),
                    const SizedBox(height: 25,),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ListsPage()));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 55,
                        margin: EdgeInsets.only(bottom: 20),
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // 10% of the width, so there are ten blinds.
                            colors: <Color>[
                              Color(SipsakMetod.HexaColorConverter("#7D20A6")),
                              Color(SipsakMetod.HexaColorConverter("#481183")),
                            ],
                            // red to yellow
                            tileMode: TileMode
                                .repeated, // repeats the gradient over the canvas
                          ),
                        ),
                        child: const Text(
                          "Listelerim",
                          style: TextStyle(
                              fontSize: 28,
                              fontFamily: "Carter",
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          card(context,
                              startColor: "#1DACC9",
                              endColor: "#0C33B2",
                              title: "Kelime\nKartları",click: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const WordCardsPage()));
                              }),
                          card(context,
                              startColor: "#FF3348",
                              endColor: "#B029B9",
                              title: "Çoktan\nŞeçmeli",click: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const MultipleChoicePage()));
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                adContainer!
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell card(BuildContext context,
      {@required String? startColor,
        @required String? endColor,
        @required String? title,@required Function ?click}) {
    return InkWell(
      onTap: ()=>click!(),
      child: Container(
        alignment: Alignment.center,
        height: 200,
        width: MediaQuery.of(context).size.width * 0.37,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // 10% of the width, so there are ten blinds.
            colors: <Color>[
              Color(SipsakMetod.HexaColorConverter(startColor!)),
              Color(SipsakMetod.HexaColorConverter(endColor!)),
            ],
            // red to yellow
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title!,
              style: const TextStyle(
                  fontSize: 28, fontFamily: "Carter", color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const Icon(
              Icons.file_copy,
              size: 32,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  SizedBox langRadioButton({
    @required String? text,
    @required Lang? value,
    @required Lang? group,
  }) {
    return SizedBox(
      width: 250,
      height: 30,
      child: ListTile(

        title: Text(text!,style: const TextStyle(fontFamily: "Carter",fontSize: 15),),
        leading: Radio<Lang>(
          value: value!,
          groupValue: chooseLang,
          onChanged: (Lang? value) {
            setState(() {
              chooseLang = value;
            });

            // TRUE  => İngilizcen türkçeye
            // FALSE => Türkçeden ingilizce

            if(value == Lang.eng)
            {
              SP.write("lang",true);
            }
            else
            {
              SP.write("lang",false);
            }
          },
        ),
      ),
    );
  }
}
