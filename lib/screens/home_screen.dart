import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medlembre/models/registries_model.dart';
import 'package:medlembre/models/reminders_model.dart';
import 'package:medlembre/models/reminder.dart';
import 'package:medlembre/screens/add_reminder_screen.dart';
import 'package:medlembre/screens/add_registry_screen.dart';
import 'package:medlembre/services/lembrete_service.dart';
import 'package:medlembre/services/registro_service.dart';
import 'package:provider/provider.dart';
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
    _timer = Timer.periodic(
        const Duration(minutes: 1), (Timer t) => _checkReminders());
    updateReminders();
    updateRegistries();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void updateReminders() async {
    var remindersModel = Provider.of<RemindersModel>(context, listen: false);
    remindersModel.loadReminders();
  }

  void updateRegistries() async {
    var registriesModel = Provider.of<RegistriesModel>(context, listen: false);
    registriesModel.loadRegistries();
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

  Widget? getActionButton() {
    switch (_selectedIndex) {
      case 0:
        return FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AddReminderScreen())),
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        );
      case 1:
        return FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AddRegistryScreen())),
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleForIndex(_selectedIndex)),
      ),
      body: _getBodyForIndex(_selectedIndex),
      floatingActionButton: getActionButton(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
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
        setState(() {
          updateReminders();
        });
        return _buildReminderList();
      case 1:
        setState(() {
          updateRegistries();
        });
        return _buildRegistryPage();
      case 2:
        return ProfileScreen();
      default:
        return const Center(child: Text('Página não encontrada'));
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
              leading:
                  Text(reminder.emoji, style: const TextStyle(fontSize: 24)),
              title: Text(reminder.titulo),
              subtitle: Text(_calculateTimeUntilReminder(reminder)),
              onTap: () => _showReminderDetails(reminder),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline),
                    onPressed: () => _markAsCompleted(reminder.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editReminder(reminder),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
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

  Widget _buildRegistryPage() {
    return Consumer<RegistriesModel>(
      builder: (context, registriesModel, child) {
        var registries = registriesModel.registries;
        return ListView.builder(
          itemCount: registries.length,
          itemBuilder: (context, index) {
            var reminder = registries[index];
            return ListTile(
              leading: const Text("☀️", style: TextStyle(fontSize: 24)),
              title: Text(reminder.titulo),
              subtitle: Text('Concluído em: ${reminder.data}'),
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
              child: const Text('Fechar'),
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
