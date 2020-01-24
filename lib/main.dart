import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:audioplayers/audio_cache.dart';

import 'package:flutter/material.dart';

main() => runApp(MaterialApp(home: Dice()));

class Dice extends StatefulWidget {
  @override
  _DiceState createState() => _DiceState();
}

class _DiceState extends State<Dice> {

static AudioCache player=AudioCache(prefix: "music/");


  var dice1Image = "assets/image/dice1.png";
  var dice2Image = "assets/image/dice1.png";
  int dice1Score = 0;
  int dice2Score = 0;
  bool isDisable = true;
  bool isStart = true;
  bool isRestart = true;
  bool isDone = true;
  int gameTime1 = 10;
  int gameTime2 = 10;
  int counter = 5;
  String result = "";
  Timer timer1, timer2;
  Color colP2 = Colors.white;
  Color colP1 = Colors.white;

  start() {
    setState(() {
      isStart = false;
      isDone = true;
      time1();
    });
  }

  doRestart() {
    setState(() {
      dice1Score = 0;
      dice2Score = 0;
      isDisable = true;
      isStart = true;
      gameTime1 = 10;
      gameTime2 = 10;
      counter = 5;
      result = "";
      timer2.cancel();
      timer1.cancel();
      colP2 = Colors.white;
      colP1 = Colors.white;
    });
  }

  show() {
    player.play("winner.wav");
    setState(() {
      timer2.cancel();
      timer1.cancel();
      isDone = false;
      if (dice1Score == dice2Score) {
        result = "Drow";
        colP1 = Colors.grey;
        colP2 = Colors.grey;
      } else if (dice1Score > dice2Score) {
        result = "Player 1 Won the Match";
        colP1 = Colors.green;
        colP2 = Colors.red;
      } else {
        result = "Player 2 Won the Match";
        colP2 = Colors.green;
        colP1 = Colors.red;
      }
    });
    _dialog(result,dice1Score,dice2Score);
  }

  time1() async {
    if (counter >= 1) {
      timer1 = Timer.periodic(Duration(seconds: 1), (timer1) {
        setState(() {
          if (!isDisable)
            timer1.cancel();
          else {
            if (gameTime1 < 1) {
              timer1.cancel();
              gameTime2 = 10;
              isDisable = false;
              time2();
            } else {
              gameTime1--;
              if(gameTime1<=5)
                player.play("urgent_timer.wav");
              else
                player.play("timer.wav");
            }
          }
        });
      });
    } else {
      show();
    }
  }

  time2() async {
    counter--;
    timer2 = Timer.periodic(Duration(seconds: 1), (timer2) {
      setState(() {
        if (isDisable)
          timer2.cancel();
        else {
          if (gameTime2 < 1) {
            timer2.cancel();
            gameTime1 = 10;
            isDisable = true;
            time1();
          } else {
            gameTime2--;
            if(gameTime2<=5)
                player.play("urgent_timer.wav");
              else
                player.play("timer.wav");
          }
        }
      });
    });
  }

  dice1() {
    player.play("dice.wav");
    var r = new Random().nextInt(6) + 1;
    gameTime2 = 10;
    setState(() {
      dice1Image = "assets/image/dice$r.png";
      dice1Score = dice1Score + r;
      isDisable = false;
    });
    time2();
  }

  dice2() {
    player.play("dice.wav");
    var r = new Random().nextInt(6) + 1;
    gameTime1 = 10;
    setState(() {
      dice2Image = "assets/image/dice$r.png";
      dice2Score = dice2Score + r;
      isDisable = true;
    });
    time1();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Dice_Roller"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: colP1,
                /* decoration: BoxDecoration(
                  border: Border.all(),
                ), */
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Player 1",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                          child: Text(
                            "⌚${gameTime1.toString()}",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Score: ${dice1Score.toString()}",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Image.asset(
                        dice1Image,
                        height: 180,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: RaisedButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: (isDone
                            ? (!isStart ? (isDisable ? dice1 : null) : null)
                            : null),
                        child: Text(
                          "Roll",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 130,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: RaisedButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: isStart ? start : null,
                          child: Text(
                            "Start",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Text(
                        "Rounds:$counter",
                        style: TextStyle(fontSize: 25),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: RaisedButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: doRestart,
                          child: Text(
                            "Resart",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: colP2,
                /*  decoration: new BoxDecoration(
                  border: Border.all(),
                ), */
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Player 2",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                          child: Text(
                            "⌚$gameTime2",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Score: ${dice2Score.toString()}",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Image.asset(
                        dice2Image,
                        height: 180,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: RaisedButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: (isDone
                            ? (!isStart ? (!isDisable ? dice2 : null) : null)
                            : null),
                        child: Text(
                          "Roll",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _dialog(String res,p1,p2) async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(res),
          content: Container(
            height: 250,
            width: 100,
            child: Column(
              children: <Widget>[
                Image.asset("assets/image/winner.png",height: 150,),
                Padding(padding: EdgeInsets.all(5),),
                Text("Score",style: TextStyle(fontSize: 20),),
                Padding(padding: EdgeInsets.all(5),),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                  Text("Player 1:  $p1",),
                  Text("Player 2:  $p2",),
                ],)
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: (){
                Navigator.of(context).pop();
              }
            )
          ],
          
        );

      }
    );
  }

}
