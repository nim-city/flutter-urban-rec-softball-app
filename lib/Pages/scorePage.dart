import 'package:flutter/material.dart';
import 'package:softball_team_creator/CustomWidgets/ListTiles.dart';
import 'package:softball_team_creator/Models/Inning.dart';
import 'package:softball_team_creator/Models/databaseFunctions.dart';

class ScorePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MyScorePage();
  }
}

class MyScorePage extends StatefulWidget {

  MyScorePage({Key key}) : super(key: key);

  @override
  _MyScorePageState createState() => _MyScorePageState();
}

class _MyScorePageState extends State<MyScorePage> {

  PageController controller = PageController();

  int homeScore = 0;
  int awayScore = 0;
  List<Inning> innings = [];

  void _loadInitialScores() {
    ScoresDatabaseFunctions.getScores().then((scores) {
      setState(() {
        awayScore = scores[0];
        homeScore = scores[1];
      });
    });
  }

  void _loadInitialInnings() {
    ScoresDatabaseFunctions.getInnings().then((innings) {
      setState(() {
        this.innings = innings;
      });
    });
  }

  void _calculateTotalScores() {
    setState(() {
      int _awayScore = 0;
      int _homeScore = 0;
      innings.forEach((inning) {
        _awayScore += inning.awayScore;
        _homeScore += inning.homeScore;

      });
      this.awayScore = _awayScore;
      this.homeScore = _homeScore;
    });
  }

  void _changeInning(direction) {
    int currentPage = controller.page.round();
    if (direction == 1) {
      if (currentPage == 6) { return; }
      controller.animateToPage(currentPage + 1, duration: Duration(milliseconds: 300), curve: Curves.linear);
    } else if (direction == -1) {
      if (currentPage == 0) { return; }
      controller.animateToPage(currentPage - 1, duration: Duration(milliseconds: 300), curve: Curves.linear);
    }

  }

  @override
  void initState() {
    _loadInitialScores();
    _loadInitialInnings();

    ScoresDatabaseFunctions.getCurrentInning().then((inning) {
      controller.jumpToPage(inning - 1);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: Text(
                    'Total Scores',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    'Away: $awayScore',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    'Home: $homeScore',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35,
            child: PageView.builder(
              itemCount: this.innings.length,
              controller: controller,
              pageSnapping: true,
              onPageChanged: (index) {
                ScoresDatabaseFunctions.setCurrentInning(index + 1);
              },
              itemBuilder: (context, index) {
                return InningTile(inning: innings[index], updateScores: _calculateTotalScores, changeInning: _changeInning);
              }
            ),
          ),
        ],
      ),
    );
  }
}

