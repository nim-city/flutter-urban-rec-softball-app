import 'package:flutter/material.dart';
import 'package:softball_team_creator/CustomWidgets/Dialogs.dart';
import 'package:softball_team_creator/CustomWidgets/ListTiles.dart';
import 'package:softball_team_creator/Models/Player.dart';
import 'package:softball_team_creator/Models/databaseFunctions.dart';

class RosterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MyRosterPage();
  }
}

class MyRosterPage extends StatefulWidget {
  MyRosterPage({Key key}) : super(key: key);

  @override
  _MyRosterPageState createState() => _MyRosterPageState();
}

class _MyRosterPageState extends State<MyRosterPage> {

  List<Player> _players = [];

  void _showRemoveDialog(Player player) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RemovePlayerDialog(player: player, confirmRemove: _removePlayer,);
      }
    );
  }

  void _removePlayer(Player playerToRemove) {
    setState(() {
      List<Player> tempRoster = [];
      _players.forEach((player) {
        if (player.name != playerToRemove.name) {
          tempRoster.add(player);
        }
      });
      _players = tempRoster;
      _sortRoster();
    });
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("${playerToRemove.name} removed from roster"), duration: Duration(seconds: 1)));
  }

  void _addPlayer() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPlayerDialog(savePlayer: _savePlayerToRoster);
      },
    );
  }

  void _savePlayerToRoster(Player newPlayer) {
    setState(() {
      _players.add(newPlayer);
      _sortRoster();
    });
  }

  void _sortRoster() {
    List<String> playerNames = [];
    List<Player> tempRoster = [];
    _players.forEach((player) {
      if (!playerNames.contains(player.name)) {
        playerNames.add(player.name);
        tempRoster.add(player);
      }
    });
    _players = tempRoster;
    
    List<Player> sortRoster(List<Player> longerList, List<Player> shorterList) {
      List<Player> tempRoster = [];
      for (int i = 0; i < longerList.length; i++) {
        tempRoster.add(longerList[i]);
        tempRoster.add(shorterList[i % shorterList.length]);
      }
      return tempRoster;
    }

    List<Player> malePlayers = [];
    List<Player> femalePlayers = [];

    _players.forEach((player) {
      if (player.sex == "M") {
        malePlayers.add(player);
      } else {
        femalePlayers.add(player);
      }
    });
    if (malePlayers.isEmpty || femalePlayers.isEmpty) {
      RosterDatabaseFunctions.saveRoster(_players);
      return;
    }

    _players = (malePlayers.length > femalePlayers.length) ?
    sortRoster(malePlayers, femalePlayers) :
    sortRoster(femalePlayers, malePlayers);

    RosterDatabaseFunctions.saveRoster(_players);
  }

  void _loadNextPlayer() {
    setState(() {
      List<Player> tempPlayers = [];
      for(int i = 1; i < _players.length; i++) {
        tempPlayers.add(_players[i]);
      }
      tempPlayers.add(_players[0]);
      _players = tempPlayers;

      RosterDatabaseFunctions.saveRoster(_players);
    });
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("${_players.last.name} batted"), duration: Duration(seconds: 1)));
  }

  @override
  void initState() {
    _players = [];
    _loadPlayersFromSharedPreferences();

    super.initState();
  }

  void _loadPlayersFromSharedPreferences() {
    RosterDatabaseFunctions.getRoster().then((players) {
      setState(() {
        _players = players;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _players.length,
              itemExtent: MediaQuery.of(context).size.height / 10,
              padding: EdgeInsets.only(top: 20.0),
              itemBuilder: (context, i) {
                Player currentPlayer = _players[i];
                return Dismissible(
                  key: Key(currentPlayer.name),
                  onDismissed: (direction) {
                    _loadNextPlayer();
//                    if (direction == DismissDirection.startToEnd) {
//                      _loadNextPlayer();
//                    } else if (direction == DismissDirection.endToStart) {
//                      _removePlayer(currentPlayer);
//                    }
                  },
                  child: PlayerListTile(player: currentPlayer, removePlayer: _showRemoveDialog,),
                  background: Container(color: Colors.green,),
//                  secondaryBackground: Container(color: Colors.red,),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
        child: FloatingActionButton(
          onPressed: _addPlayer,
          child: Icon(Icons.person_add),
        ),
      ),
    );
  }
}


