import 'package:flutter/material.dart';
import 'package:medlembre/models/reminder.dart';

class RemindersModel with ChangeNotifier {
  final List<Reminder> _reminders = [];

  // Retorna lembretes ativos
  List<Reminder> get activeReminders => 
    _reminders.where((reminder) => !reminder.isCompleted).toList();

  // Retorna lembretes concluídos
  List<Reminder> get completedReminders => 
    _reminders.where((reminder) => reminder.isCompleted).toList();

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }

  void markAsCompleted(String reminderId) {
    final reminder = _reminders.firstWhere((r) => r.id == reminderId);
    reminder.isCompleted = true;
    notifyListeners();
  }
  void deleteReminder(String id) {
    _reminders.removeWhere((reminder) => reminder.id == id);
    notifyListeners();
  }
  void updateReminder(Reminder updatedReminder) {
    final index = _reminders.indexWhere((reminder) => reminder.id == updatedReminder.id);
    if (index != -1) {
      _reminders[index] = updatedReminder;
      notifyListeners();
    }
}
}