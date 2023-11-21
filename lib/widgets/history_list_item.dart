import 'package:flutter/material.dart';

class HistoryListItem extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const HistoryListItem({
    required Key key,
    required this.title,
    required this.description,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text("$description - $date"),
        leading: Icon(Icons.history),
      ),
    );
  }
}
