import 'package:flutter/material.dart';
import 'package:softball_team_creator/Models/databaseFunctions.dart';
import 'package:softball_team_creator/Pages/rosterPage.dart';
import 'package:softball_team_creator/Pages/scorePage.dart';

void main() => runApp(MainPage());

class MainPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MyMainPage();
  }

}

class MyMainPage extends StatefulWidget {

  MyMainPage({Key key}) : super(key: key);

  @override
  _MyMainPageState createState() => _MyMainPageState();

}

class _MyMainPageState extends State<MyMainPage> {

  RosterPage _rosterPage = RosterPage();
  ScorePage _scorePage = ScorePage();

  void _clearSharedPreferences() {
    GeneralDatabaseFunctions.clearScores().then((cleared) {
      Future.delayed(Duration(seconds: 1)).whenComplete(() {
        setState(() {
          _rosterPage.build(context);
          _scorePage.build(context);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Softball Team Creator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Softball Game"),
            actions: <Widget>[
              MaterialButton(
                onPressed: _clearSharedPreferences,
                child: Text("Clear"),
                textColor: Colors.white,
              ),
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: "Roster", icon: Icon(Icons.person)),
                Tab(text: "Scores", icon: Icon(Icons.score)),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              _rosterPage,
              _scorePage,
            ],
          ),
        ),
      ),
    );
  }
}
