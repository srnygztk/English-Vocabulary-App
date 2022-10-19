import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tez/db/db/db.dart';
import 'package:tez/db/db/shared_preferences.dart';
import 'package:tez/db/models/words.dart';
import 'package:tez/global_widget/app_bar.dart';
import 'package:tez/global_widget/toast.dart';
import 'package:tez/sipsak_metod.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../global_variable.dart';


class MultipleChoicePage extends StatefulWidget {
  const MultipleChoicePage({Key? key}) : super(key: key);

  @override
  _MultipleChoicePage createState() => _MultipleChoicePage();
}


class _MultipleChoicePage extends State<MultipleChoicePage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists().then((value)=>setState(()=>lists));
  }


  List<Word> _words = [];
  bool start = false;


  List<List<String>> optionsList = []; // Kelime listesi uzunlugu kadar şık listesi, Her şık listesinde 4 şık olucak.
  List<String> correctAnswers = []; // Her kelime için dogru cevaplı listede tutucağım.


  List<bool> clickControl = []; // Kelimeye ait şıklardan herhangi biri işaretlendi mi kontrolunu yapıcak.
  List<List<bool>> clickControlList = []; // Hangi şıkkın işaretlendiğin kontrolunu yapıcak.

  int correctCount = 0; // dogru cevapların sayısı sayıcak
  int wrongCount = 0; // hatalı cevapların sayısını sayıcak



  void getSelectedWordOfLists(List<int> selectedListID) async
  {
    debugPrint("A5");
    List<String> value = selectedListID.map((e) => e.toString()).toList();
    SP.write("selected_list", value);
    debugPrint("A6");
    if(chooseQuestionType == Which.learned)
    {
      _words = await DB.instance.readWordByLists(selectedListID,status: true);
    }
    else if(chooseQuestionType == Which.unlearned)
    {
      _words = await DB.instance.readWordByLists(selectedListID,status: false);
    }
    else
    {
      _words = await DB.instance.readWordByLists(selectedListID);
    }
    debugPrint("A7");

    if(_words.isNotEmpty)
    {
      debugPrint("A8");
      if(_words.length > 3)
      {

        if(listMixed) _words.shuffle();

        debugPrint("A9");
        Random random = Random();
        for(int i = 0 ; i<_words.length ; ++i)
        {

          clickControl.add(false); // Her bir kelime için cevap verilip verilmediğinin kontrolu
          // her kelime için 4 şık var, 4 şkkında işaretlenmediği belirten 4 ader false ile doldrudum.
          clickControlList.add([false,false,false,false]);


          List<String> tempOptions = [];

          while(true)
          {

            int rand = random.nextInt(_words.length); // 0 ile (kelime listesi uzunlugu - 1)

            if(rand != i)
            {

              bool isThereSame = false;

              for (var element in tempOptions) {
                if(chooseLang==Lang.eng)
                {
                  if(element == _words[rand].word_tr!)
                  {
                    isThereSame = true;
                  }
                }
                else
                {
                  if(element == _words[rand].word_eng!)
                  {
                    isThereSame = true;
                  }
                }
              }



              if(!isThereSame) tempOptions.add(chooseLang==Lang.eng?_words[rand].word_tr!:_words[rand].word_eng!);
            }
            debugPrint("A10");
            if(tempOptions.length == 3)
            {
              break;
            }
          }
          debugPrint("A11");
          tempOptions.add(chooseLang==Lang.eng?_words[i].word_tr!:_words[i].word_eng!);
          tempOptions.shuffle();
          correctAnswers.add(chooseLang==Lang.eng?_words[i].word_tr!:_words[i].word_eng!);
          optionsList.add(tempOptions);
          debugPrint("A12");

        }




        start = true;
        debugPrint("A13");
        setState(() {
          _words;
          start;
        });
        debugPrint("A14");
      }
      else
      {
        toastMessage("Mimimum 4 kelime gereklidir.");
      }
    }
    else
    {
      toastMessage("Şeçilen şartlarda liste boş.");
    }

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context,left: const Icon(Icons.arrow_back_ios,size: 22,color: Colors.black,),
            center: const Text("Çoktan Şeçmeli",style: TextStyle(fontFamily: "carter",color: Colors.black,fontSize: 22),),
            leftWidgetOnClick: ()=>Navigator.pop(context)),
        body: SafeArea(
          child: start==false?Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 16),
            padding: const EdgeInsets.only(left: 4,top: 10,right: 4),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: Color(SipsakMetod.HexaColorConverter("#DCD2FF"))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                whichRadioButton(text: "Öğrenmediklerimi sor",value: Which.unlearned),
                whichRadioButton(text: "Öğrendiklerimi sor",value: Which.learned),
                whichRadioButton(text: "Hepsini sor",value: Which.all),
                checkBox(text: "Listeyi karıştır",fWhat: forWhat.forListMixed),
                const SizedBox(height: 20,),
                const Divider(color: Colors.black,thickness: 1,),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text("Listeler",style: TextStyle(fontFamily: "RobotoRegular",fontSize: 18,color: Colors.black)),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8,right: 8,bottom: 10,top: 10),
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1)
                  ),
                  child: Scrollbar(
                    thickness: 5,
                    isAlwaysShown: true,
                    child: ListView.builder(itemBuilder: (context,index){
                      return checkBox(index: index,text:lists[index]['name'].toString());
                    },itemCount: lists.length,),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: ()
                    {
                      debugPrint("A1");
                      List<int> selectedIndexNoOfList = [];

                      for(int  i = 0 ;  i<selectedListIndex.length ; ++i)
                      {
                        if(selectedListIndex[i] == true)
                        {
                          selectedIndexNoOfList.add(i);
                        }
                      }

                      debugPrint("A2");
                      List<int> selectedListIdList = [];

                      for(int i = 0 ; i<selectedIndexNoOfList.length ; ++i)
                      {
                        selectedListIdList.add(lists[selectedIndexNoOfList[i]]['list_id'] as int);
                      }

                      debugPrint("A3");
                      if(selectedListIdList.isNotEmpty)
                      {
                        getSelectedWordOfLists(selectedListIdList);
                      }
                      else
                      {
                        toastMessage("Lütfen, liste şeç.");
                      }
                      debugPrint("A4");
                    },
                    child: const Text("Başla",style: TextStyle(fontFamily: "RobotoRegular",fontSize: 18,color: Colors.black)),
                  ),
                )

              ],
            ),

          ):CarouselSlider.builder(
            options: CarouselOptions(
                height: double.infinity
            ),
            itemCount: _words.length,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex){
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          margin: const EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 16),
                          padding: const EdgeInsets.only(left: 4,top: 10,right: 4),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              color: Color(SipsakMetod.HexaColorConverter("#DCD2FF"))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(chooseLang==Lang.eng?_words[itemIndex].word_eng!:_words[itemIndex].word_tr!,style: const TextStyle(fontFamily: "RobotoRegular",fontSize: 28,color: Colors.black),),
                              const SizedBox(height: 15,),
                              customRadioButtonList(itemIndex,optionsList[itemIndex],correctAnswers[itemIndex])
                            ],
                          ),
                        ),
                        Positioned(child: Text((itemIndex+1).toString()+"/"+(_words.length).toString(),style: const TextStyle(fontFamily: "RobotoRegular",fontSize: 16,color: Colors.black),),left: 30,top: 10,),
                        Positioned(child: Text("D:"+correctCount.toString()+"/"+"Y:"+wrongCount.toString(),style: const TextStyle(fontFamily: "RobotoRegular",fontSize: 16,color: Colors.black),),right: 30,top: 10,)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: CheckboxListTile(
                      title: const Text("Öğrendim"),
                      value: _words[itemIndex].status,
                      onChanged: (value){
                        _words[itemIndex] = _words[itemIndex].copy(status:value );
                        DB.instance.markAsLearned(value!, _words[itemIndex].id as int);
                        toastMessage(value?"Öğrenildi olarak işaretlendi.":"Öğrenilmedi olarak işaretlendi");

                        setState(() {
                          _words[itemIndex];
                        });
                      },
                    ),
                  )
                ],
              );
            },
          ),)
    );
  }


  SizedBox whichRadioButton({@required String? text,@required Which? value})
  {
    return SizedBox(
      width: double.infinity,
      height: 32,
      child: ListTile(
        title: Text(text!,style: const TextStyle(fontFamily: "RobotoRegular",fontSize: 18),),
        leading: Radio<Which>(
          value: value!,
          groupValue: chooseQuestionType,
          onChanged: (Which? value)
          {
            setState(() {
              chooseQuestionType = value;
            });

            switch(value)
            {
              case Which.learned:
                SP.write("which", 0);
                break;
              case Which.unlearned:
                SP.write("which", 1);
                break;
              case Which.all:
                SP.write("which", 2);
                break;
              default:
                break;
            }

          },
        ),
      ),
    );
  }


  SizedBox checkBox({int index=0,String ?text,forWhat fWhat=forWhat.forList})
  {

    return SizedBox(
      width: 270,
      height: 33,
      child: ListTile(
        title: Text(text!,style: const TextStyle(fontFamily: "RobotoRegular",fontSize: 18),),
        leading: Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.deepPurpleAccent,
          hoverColor: Colors.blueAccent,
          value: fWhat==forWhat.forList?selectedListIndex[index]:listMixed,
          onChanged: (bool ? value){

            setState(() {
              if(fWhat  == forWhat.forList)
              {
                selectedListIndex[index] = value!;
              }
              else
              {
                listMixed = value!;
                SP.write("mix", value);
              }
            });




          },
        ),
      ),
    );
  }


  // optionsList[itemIndex]  =>  [  [anlasmak,izin vermek,olay,durum] , [anlasmak,izin vermek,olay,durum] ,[anlasmak,izin vermek,olay,durum] .....
  Container customRadioButton(int index,List<String> options,int order)
  {
    Icon uncheck = const Icon(Icons.radio_button_off_outlined,size: 16);
    Icon check = const Icon(Icons.radio_button_checked_outlined,size: 16);
    return Container(
      margin: const EdgeInsets.all(4),
      child: Row(
        children: [
          clickControlList[index][order]==false?uncheck:check,
          const SizedBox(width: 10),
          Text(options[order],style: const TextStyle(fontSize: 18),)
        ],
      ),
    );
  }



  Column customRadioButtonList(int index,List<String> options,String correctAnswer)
  {

    Divider dV = const Divider(thickness: 1,height: 1);

    return Column(
      children: [
        dV,
        InkWell(
          onTap: ()=>toastMessage("Şeçmek için çift tıklayın."),
          onDoubleTap: ()=>checker(index,0,options,correctAnswer),
          child: customRadioButton(index,options,0),
        ),dV,
        InkWell(
          onTap: ()=>toastMessage("Şeçmek için çift tıklayın."),
          onDoubleTap: ()=>checker(index,1,options,correctAnswer),
          child: customRadioButton(index,options,1),
        ),dV,
        InkWell(
          onTap: ()=>toastMessage("Şeçmek için çift tıklayın."),
          onDoubleTap: ()=>checker(index,2,options,correctAnswer),
          child: customRadioButton(index,options,2),
        ),dV,
        InkWell(
          onTap: ()=>toastMessage("Şeçmek için çift tıklayın."),
          onDoubleTap: ()=>checker(index,3,options,correctAnswer),
          child: customRadioButton(index,options,3),
        ),dV
      ],
    );

  }

  void checker(index,order,options,correctAnswer)
  {
    if(clickControl[index] == false)
    {

      clickControl[index] = true;
      setState(()=>clickControlList[index][order] = true);

      if(options[order] == correctAnswer)
      {
        correctCount++;
      }
      else
      {
        wrongCount++;
      }

      if((correctCount + wrongCount) == _words.length)
      {
        toastMessage("Test bitti.");
      }
    }
  }

}