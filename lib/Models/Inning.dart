import 'package:softball_team_creator/Models/databaseFunctions.dart';

class Inning {

  int inningNumber;
  int homeScore;
  int awayScore;

  Inning({this.inningNumber}) {
    homeScore = 0;
    awayScore = 0;
  }

  void increaseAwayScore() {
    if (awayScore == 5) { return; }
    awayScore++;
    ScoresDatabaseFunctions.saveScore(this);
  }

  void decreaseAwayScore() {
    if (awayScore == 0) { return; }
    awayScore--;
    ScoresDatabaseFunctions.saveScore(this);
  }

  void increaseHomeScore() {
    if (homeScore == 5) { return; }
    homeScore++;
    ScoresDatabaseFunctions.saveScore(this);
  }

  void decreaseHomeScore() {
    if (homeScore == 0) { return; }
    homeScore--;
    ScoresDatabaseFunctions.saveScore(this);
  }

}