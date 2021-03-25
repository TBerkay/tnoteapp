import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tnoteapp/database/dbhelper.dart';
import 'package:tnoteapp/models/note.dart';

class NoteScreen extends StatelessWidget {
  Note note = Note(null, null, null);

  NoteScreen({this.note});

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  DbHelper dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("NOTE"),
          actions: [
            _buildSaveBtn(context),
            _buildDeleteBtn(context, note),
          ],
        ),
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(15.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 10.0, left: 10.0, right: 10.0),
                    child: Text(note.date),
                  )
                ],
              ),
              TextFormField(
                initialValue: note.title,
                decoration: InputDecoration(
                    labelText: "Note Title",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                onSaved: (String value) {
                  note.title = value;
                },
                validator: (String value) {
                  if (value.isEmpty) return "Title is required";

                  return null;
                },
              ),
              SizedBox(
                height: 30.0,
              ),
              TextFormField(
                initialValue: note.description,
                maxLines: 15,
                decoration: InputDecoration(
                    labelText: "Note",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                onSaved: (String value) {
                  note.description = value;
                },
                validator: (String value) {
                  if (value.isEmpty) return "Note is required";

                  return null;
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildSaveBtn(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.save,
        color: Colors.white,
      ),
      onPressed: () {
        if (!_key.currentState.validate()) return;

        if (note.id == null) {
          _key.currentState.save();
          note.date = DateFormat("hh:mm:ss dd-MM-yyyy").format(DateTime.now());
          dbHelper.insert(note);
          Navigator.pop(context, true);
        } else {
          _key.currentState.save();
          note.date = DateFormat("hh:mm:ss dd-MM-yyyy").format(DateTime.now());
          dbHelper.update(note);
          Navigator.pop(context, true);
        }
      },
    );
  }

  Widget _buildDeleteBtn(BuildContext context, Note note) {
    if (note.id != null) {
      return IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("DELETE"),
                  content: Text("Are you sure?"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    FlatButton(
                        onPressed: () {
                          dbHelper.delete(note.id);
                          Navigator.pop(context);
                          Navigator.pop(context, true);
                        },
                        child: Text("Yes")),
                  ],
                );
              });
        },
      );
    } else {
      return Container();
    }
  }
}
