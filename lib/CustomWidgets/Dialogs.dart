

import 'package:flutter/material.dart';
import 'package:softball_team_creator/Models/Player.dart';

class AddPlayerDialog extends StatefulWidget {

  final Function savePlayer;

  AddPlayerDialog({Key key, this.savePlayer}) : super(key: key);

  @override
  _AddPlayerDialogState createState() => new _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {

  int _radioValue;
  String _selectedSex = "M";
  String _name = "";

  void _handleRadioSelection(int value) {
    setState(() {
      _radioValue = value;
      _selectedSex = (_radioValue == 0) ? "M" : "F";
    });
  }

  void _saveNewPlayer() {
    if (_name == null || _selectedSex == null) {
      return;
    }
    widget.savePlayer(Player(name: _name, sex: _selectedSex));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        contentPadding: EdgeInsets.all(0.0),
        title: Text(
          "Add a player",
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (text) {
                    setState(() {
                      _name = text;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Radio(
                          groupValue: _radioValue,
                          value: 0,
                          onChanged: _handleRadioSelection,
                        ),
                        Text("Male"),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Radio(
                          groupValue: _radioValue,
                          value: 1,
                          onChanged: _handleRadioSelection,
                        ),
                        Text("Female"),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: _saveNewPlayer,
                      child: Text("Save"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class RemovePlayerDialog extends StatelessWidget {

  final Function confirmRemove;
  final Player player;

  RemovePlayerDialog({Key key, this.player, this.confirmRemove}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        contentPadding: EdgeInsets.all(0.0),
        title: Text(
          "Are you sure you want to remove ${player.name} from the roster?",
          maxLines: 3,
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: MediaQuery.of(context).size.height / 6,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No"),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      confirmRemove(player);
                      Navigator.pop(context);
                    },
                    child: Text("Yes"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}