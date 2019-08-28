import 'package:flutter/material.dart';
import 'package:softball_team_creator/Models/Inning.dart';
import 'package:softball_team_creator/Models/Player.dart';

class InningTile extends StatefulWidget {

  final Function updateScores;
  final Inning inning;
  final Function changeInning;

  InningTile({Key key, this.inning, this.updateScores, this.changeInning}) : super(key: key);

  @override
  _InningTileState createState() => _InningTileState();

}

class _InningTileState extends State<InningTile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  widget.changeInning(-1);
                }
              ),
              Text(
                "Inning ${widget.inning.inningNumber}",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: () {
                    widget.changeInning(1);
                  }
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Away:",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green
                  ),
                ),
                Text(
                  "${widget.inning.awayScore}",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.inning.increaseAwayScore();
                          widget.updateScores();
                        });
                      },
                      icon: Icon(Icons.add, size: 20.0,),
                      padding: EdgeInsets.all(0.0),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.inning.decreaseAwayScore();
                          widget.updateScores();
                        });
                      },
                      icon: Icon(Icons.remove, size: 20.0,),
                    ),
                  ],
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Home:",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue
                  ),
                ),
                Text(
                  "${widget.inning.homeScore}",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.inning.increaseHomeScore();
                          widget.updateScores();
                        });
                      },
                      icon: Icon(Icons.add, size: 20.0,),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.inning.decreaseHomeScore();
                          widget.updateScores();
                        });
                      },
                      icon: Icon(Icons.remove, size: 20.0,),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

}

class PlayerListTile extends StatelessWidget {

  final Function removePlayer;
  final Player player;

  PlayerListTile({Key key, this.player, this.removePlayer}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 40.0, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "${player.name}  (${player.sex})",
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              removePlayer(this.player);
            },
          ),
        ],
      ),
    );
  }

}