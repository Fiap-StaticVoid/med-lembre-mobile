import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medlembre/models/reminders_model.dart';
import 'package:medlembre/models/reminder.dart';
import 'package:medlembre/services/lembrete_service.dart';
import 'package:provider/provider.dart';
import 'add_reminder_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer =
        Timer.periodic(Duration(minutes: 1), (Timer t) => _checkReminders());
    var remindersModel = Provider.of<RemindersModel>(context, listen: false);
    listarLembretes().then((value) => {
          value.forEach((element) {
            var reminder = Reminder(
              id: element.id?.toString() ?? '',
              titulo: element.titulo,
              horaInicio: element.horaInicio,
              intervalo: element.intervalo,
              intervaloTipo: element.intervaloTipo.name,
              duracao: element.duracao,
              duracaoTipo: element.duracaoTipo.name,
              concluido: element.concluido,
              emoji: '☀️',
              dateTime: DateTime.now(),
              frequencyType: '',
              timesPerDay: 0,
              intervalInHours: 0,
              intervalInMinutes: 0,
              description: '',
              address: '',
              confirmationCode: '',
              isCompleted: element.concluido,
            );
            remindersModel.addReminder(reminder);
          })
        });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkReminders() {
    var remindersModel = Provider.of<RemindersModel>(context, listen: false);
    var now = DateTime.now();
    for (var reminder in remindersModel.activeReminders) {
      if (reminder.dateTime.isBefore(now) && !reminder.isCompleted) {
        remindersModel.markAsCompleted(reminder.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleForIndex(_selectedIndex)),
      ),
      body: _getBodyForIndex(_selectedIndex),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => AddReminderScreen())),
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Histórico'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Lembretes';
      case 1:
        return 'Histórico';
      case 2:
        return 'Perfil';
      default:
        return 'MedLembre';
    }
  }

  Widget _getBodyForIndex(int index) {
    switch (index) {
      case 0:
        return _buildReminderList();
      case 1:
        return _buildHistoryPage();
      case 2:
        return ProfileScreen();
      default:
        return Center(child: Text('Página não encontrada'));
    }
  }

  Widget _buildReminderList() {
    return Consumer<RemindersModel>(
      builder: (context, remindersModel, child) {
        var reminders = remindersModel.activeReminders;
        return ListView.builder(
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            var reminder = reminders[index];
            return ListTile(
              leading: Text(reminder.emoji, style: TextStyle(fontSize: 24)),
              title: Text(reminder.titulo),
              subtitle: Text(_calculateTimeUntilReminder(reminder)),
              onTap: () => _showReminderDetails(reminder),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check_circle_outline),
                    onPressed: () => _markAsCompleted(reminder.id),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editReminder(reminder),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteReminder(reminder.id),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _markAsCompleted(String reminderId) {
    Provider.of<RemindersModel>(context, listen: false)
        .markAsCompleted(reminderId);
  }

  Widget _buildHistoryPage() {
    return Consumer<RemindersModel>(
      builder: (context, remindersModel, child) {
        var reminders = remindersModel.completedReminders;
        return ListView.builder(
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            var reminder = reminders[index];
            return ListTile(
              leading: Text(reminder.emoji, style: TextStyle(fontSize: 24)),
              title: Text(reminder.titulo),
              subtitle: Text(
                  'Concluído em: ${DateFormat.yMd().add_Hm().format(reminder.dateTime)}'),
            );
          },
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _calculateTimeUntilReminder(Reminder reminder) {
    final now = DateTime.now();
    final difference = reminder.dateTime.difference(now);
    if (difference.isNegative) {
      return "Lembrete passado";
    } else {
      if (difference.inDays > 0) {
        return "Faltam ${difference.inDays} dias";
      } else if (difference.inHours > 0) {
        return "Faltam ${difference.inHours} horas";
      } else {
        return "Faltam ${difference.inMinutes} minutos";
      }
    }
  }

  void _showReminderDetails(Reminder reminder) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(reminder.titulo),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Data e Hora: ${DateFormat.yMd().add_Hm().format(reminder.dateTime)}'),
                Text('Emoji: ${reminder.emoji}'),
                // Adicione mais detalhes se necessário
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _editReminder(Reminder reminder) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AddReminderScreen(existingReminder: reminder)));
  }

  void _deleteReminder(String id) {
    Provider.of<RemindersModel>(context, listen: false).deleteReminder(id);
  }
}
