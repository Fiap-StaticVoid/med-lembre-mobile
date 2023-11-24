import 'package:flutter/material.dart';
import 'package:medlembre/models/reminder.dart';

class ReminderListItem extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback onMarkAsCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShowDetails;

  ReminderListItem({
    required this.reminder,
    required this.onMarkAsCompleted,
    required this.onEdit,
    required this.onDelete,
    required this.onShowDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(reminder.emoji, style: TextStyle(fontSize: 24)),
      title: Text(reminder.titulo),
      subtitle: Text('Ativo'), // Você pode querer personalizar este texto
      onTap: onShowDetails,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: onMarkAsCompleted,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
