import 'package:flutter/material.dart';
import 'package:tnoteapp/database/dbhelper.dart';
import 'package:tnoteapp/models/note.dart';
import 'package:tnoteapp/screens/note_screen.dart';

class NoteListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteListScreen> {
  DbHelper dbHelper = DbHelper();
  List<Note> noteList = [];

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("MY NOTES"),
        ),
      ),
      body: _buildNoteList(),
      floatingActionButton: _buildFloatActionButton(context),
    );
  }

  Widget _buildNoteList() {
    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildNoteListItem(noteList[index]);
      },
    );
  }

  Widget _buildNoteListItem(Note note) {
    return Container(
      padding: EdgeInsets.all(10.0),
      height: 125,
      child: Card(
        color: Color.fromRGBO(255, 255, 128, 1),
        elevation: 20.0,
        child: ListTile(
          title: Container(
            padding: EdgeInsets.all(10.0),
            child: Text(
              note.title,
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              note.description,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Color.fromRGBO(204, 41, 0, 1),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return deleteAlert(note.id);
                  });
            },
          ),
          onTap: () {
            updateNote(note);
          },
        ),
      ),
    );
  }

  Widget _buildFloatActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      onPressed: () {
        addNote();
      },
      tooltip: 'Add New Note',
      child: Icon(
        Icons.add,
        size: 30,
      ),
    );
  }

  void getNotes() {
    var futureNotes = dbHelper.getAll();
    futureNotes.then((value) {
      setState(() {
        noteList = value;
      });
    });
  }

  void addNote() async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteScreen(
                  note: Note("", "", ""),
                )));

    if (result != null) {
      if (result) {
        getNotes();
      }
    }
  }

  void updateNote(Note note) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteScreen(
                  note: note,
                )));

    if (result != null) {
      if (result) {
        getNotes();
      }
    }
  }

  void deleteNote(int id) {
    dbHelper.delete(id);
    getNotes();
  }

  Widget deleteAlert(int id) {
    return AlertDialog(
      title: Text("DELETE"),
      content: Text("Are You Sure?"),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No")),
        FlatButton(
            onPressed: () {
              deleteNote(id);
              Navigator.pop(context);
            },
            child: Text("Yes"))
      ],
    );
  }
}
