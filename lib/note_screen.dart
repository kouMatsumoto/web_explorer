import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController _controller;

  void _commitNote() {
    _controller.clear();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: "add note here", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                ),
              ),
              Container(
                  width: 24,
                  child: IconButton(
                    iconSize: 24,
                    icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                    onPressed: _commitNote,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
