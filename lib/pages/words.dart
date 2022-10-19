import 'package:flutter/material.dart';
import 'package:tez/db/db/db.dart';
import 'package:tez/db/models/words.dart';
import 'package:tez/global_widget/app_bar.dart';
import 'package:tez/global_widget/toast.dart';
import 'package:tez/pages/add_word.dart';

import '../sipsak_metod.dart';

class WordsPage extends StatefulWidget {
  final int ?listID;
  final String  ?listName;

  const WordsPage(this.listID,this.listName,{Key? key}) : super(key: key);

  @override
  _WordsPageState createState() => _WordsPageState(listID: listID,listName: listName);
}

class _WordsPageState extends State<WordsPage> {
  int ?listID;
  String ?listName;

  _WordsPageState({@required this.listID,@required this.listName});

  List<Word> _wordList = [];

  bool pressController = false;
  List<bool> deleteIndexList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWordByList();
  }

  void getWordByList() async
  {
    _wordList = await DB.instance.readWordByList(listID);
    for(int i = 0 ; i<_wordList.length ; ++i)
      deleteIndexList.add(false);
    setState(()=>_wordList);

  }

  void delete() async
  {
    List<int> removeIndexList = [];


    for(int i = 0; i<deleteIndexList.length ; ++i)
      {
        if(deleteIndexList[i] == true)
        {
          removeIndexList.add(i);
        }
      }


    for(int i = removeIndexList.length -1 ; i>=0 ; --i)
      {
        DB.instance.deleteWord(_wordList[removeIndexList[i]].id!);
        _wordList.removeAt(removeIndexList[i]);
        deleteIndexList.removeAt(removeIndexList[i]);
      }



    setState(() {
      _wordList;
      deleteIndexList;
      pressController = false;
    });

    toastMessage("Şeçili kelimeler silindi.");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          context,
          left: const Icon(Icons.arrow_back_ios,color: Colors.black,size: 22,),
          center: Text(listName!,style: TextStyle(fontFamily: "carter",fontSize:22,color: Colors.black ),),
          right: pressController!=true?Image.asset("assets/images/logo.png",height: 35,width: 35,):InkWell(
            onTap: delete,
            child: Icon(Icons.delete,color: Colors.deepPurpleAccent,size: 24,),
          ),
          leftWidgetOnClick: ()=>
              Navigator.pop(context)
      ),
      body: SafeArea(
        child: ListView.builder(itemBuilder: (context,index){
          return wordItem(_wordList[index].id!,index,word_eng: _wordList[index].word_eng,word_tr: _wordList[index].word_tr,staus: _wordList[index].status!);
        },itemCount: _wordList.length,),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>  AddWordPage(listID,listName))).then((value){
              getWordByList();
            });
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.purple,
        )
    );
  }

  InkWell wordItem(int wordId,int index,{@required String ?word_tr,@required String ?word_eng,@required bool ?staus}) {
    return InkWell(
      onLongPress: (){
        setState(() {
          pressController = true;
          deleteIndexList[index] = true;
        });
      },
      child: Center(
              child: Container(
                width: double.infinity,
                child: Card(
                  color: pressController!=true?Color(SipsakMetod.HexaColorConverter("#DCD2FF")):Color(SipsakMetod.HexaColorConverter("#E7E3F5")),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  margin: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 15,top: 10),
                              child: Text(word_tr!,style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: "RobotoMedium"),)),
                          Container(     margin: EdgeInsets.only(left: 30,bottom: 10),
                              child: Text(word_eng!,style: TextStyle(color: Colors.black,fontSize: 16,fontFamily: "RobotoRegular"),)),
                        ],
                      ),
                      pressController!=true?Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.deepPurpleAccent,
                        hoverColor: Colors.blueAccent,
                        value: staus,
                        onChanged: (bool? value)
                        {
                          _wordList[index] = _wordList[index].copy(status: value);
                          if(value == true)
                            {
                              toastMessage("Öğrenildi olarak işaretlendi.");
                              DB.instance.markAsLearned(true, _wordList[index].id as int);

                            }
                          else
                            {
                              toastMessage("Öğrenilmedi olarak işaretlendi.");
                              DB.instance.markAsLearned(false, _wordList[index].id as int);
                            }

                          setState(() {
                            _wordList;
                          });

                        },
                      ):Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.deepPurpleAccent,
                        hoverColor: Colors.blueAccent,
                        value: deleteIndexList[index],
                        onChanged: (bool ?value)
                        {
                          setState(() {
                            deleteIndexList[index] = value!;
                            bool deleteProcessController = false;

                            deleteIndexList.forEach((element) {
                              if(element==true)
                                deleteProcessController = true;
                            });

                            if(!deleteProcessController)
                            {
                              pressController = false;
                            }
                          });


                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
