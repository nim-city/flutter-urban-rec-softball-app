import 'package:shared_preferences/shared_preferences.dart';
import 'package:softball_team_creator/Models/Inning.dart';
import 'package:softball_team_creator/Models/Player.dart';

class RosterDatabaseFunctions {

  static final String namesKey = "Names";
  static final String sexesKey = "Sexes";

  static Future<List<Player>> getRoster() async {
    final preferences = await SharedPreferences.getInstance();

    List<String> names = preferences.getStringList(namesKey) ?? [];
    List<String> sexes = preferences.getStringList(sexesKey) ?? [];
    List<Player> roster = [];

    for (int i = 0; i < names.length; i++) {
      roster.add(Player(name: names[i], sex: sexes[i]));
    }

    return roster;
  }

  static void saveRoster(List<Player> players) async {
    final preferences = await SharedPreferences.getInstance();
    List<String> names = [];
    List<String> sexes = [];
    players.forEach((player) {
      names.add(player.name);
      sexes.add(player.sex);
    });
    preferences.setStringList(namesKey, names);
    preferences.setStringList(sexesKey, sexes);
  }

}

class ScoresDatabaseFunctions {

  static final String awayScoreKey = "AwayScore";
  static final String homeScoreKey = "HomeScore";
  static final String awayScoresKey = "AwayScores";
  static final String homeScoresKey = "HomeScores";

  static final String currentInningKey = "CurrentInning";

  static List<String> awayScores = ["0","0","0","0","0","0","0"];
  static List<String> homeScores = ["0","0","0","0","0","0","0"];

  static Future<List<Inning>> getInnings() async {
    List<Inning> innings = [];

    final preferences = await SharedPreferences.getInstance();
    awayScores = preferences.getStringList(awayScoresKey) ?? ["0","0","0","0","0","0","0"];
    homeScores = preferences.getStringList(homeScoresKey) ?? ["0","0","0","0","0","0","0"];

    for (int i = 0; i < 7; i++) {
      Inning inning = Inning(inningNumber: i+1);
      inning.awayScore = int.parse(awayScores[i]);
      inning.homeScore = int.parse(homeScores[i]);
      innings.add(inning);
    }

    return innings;
  }

  static void saveScore(Inning inning) async {
    awayScores[inning.inningNumber - 1] = inning.awayScore.toString();
    homeScores[inning.inningNumber - 1] = inning.homeScore.toString();
    final preferences = await SharedPreferences.getInstance();

    preferences.setStringList(awayScoresKey, awayScores);
    preferences.setStringList(homeScoresKey, homeScores);

    saveTotalScore();
  }

  static Future<List<int>> getScores() async {
    List<int> scores = [0,0];
    final preferences = await SharedPreferences.getInstance();

    scores[0] = preferences.getInt(awayScoreKey) ?? 0;
    scores[1] = preferences.getInt(homeScoreKey) ?? 0;

    return scores;
  }

  static void saveTotalScore() async {
    final preferences = await SharedPreferences.getInstance();
    int awayScore = 0;
    int homeScore = 0;

    awayScores.forEach((score) => {
      awayScore += int.parse(score)
    });
    homeScores.forEach((score) => {
      homeScore += int.parse(score)
    });

    preferences.setInt(awayScoreKey, awayScore);
    preferences.setInt(homeScoreKey, homeScore);
  }

  static void setCurrentInning(int currentInning) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setInt(currentInningKey, currentInning);
  }

  static Future<int> getCurrentInning() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(currentInningKey) ?? 0;
  }

}

class GeneralDatabaseFunctions {

  static Future<bool> clearScores() async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.clear();
  }

}