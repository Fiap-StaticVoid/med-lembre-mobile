import 'package:flutter/material.dart';
import 'package:medlembre/models/reminders_model.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Lembretes'),
      ),
      body: Consumer<RemindersModel>(
        builder: (context, remindersModel, child) {
          final completedReminders = remindersModel.completedReminders;
          if (completedReminders.isEmpty) {
            return Center(child: Text('Nenhum lembrete concluído.'));
          }
          return ListView.builder(
            itemCount: completedReminders.length,
            itemBuilder: (context, index) {
              final reminder = completedReminders[index];
              return ListTile(
                leading: Text(reminder.emoji, style: TextStyle(fontSize: 24)),
                title: Text(reminder.title),
                // Outros detalhes do lembrete concluído...
              );
            },
          );
        },
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Saúde'),
      ),
      body: Center(
        child: Text('Nenhum registro de saúde ainda.'),
      ),
    );
  }

