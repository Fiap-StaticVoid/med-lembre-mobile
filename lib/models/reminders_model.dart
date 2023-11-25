import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medlembre/services/lembrete_service.dart';
import 'dart:convert';
import 'reminder.dart';

class RemindersModel with ChangeNotifier {
  final String apiUrl = 'http://127.0.0.1:8000/lembretes';
  List<Reminder> _reminders = [];

  // Carrega os lembretes da API
  Future<void> loadReminders() async {
    var lembretes = await listarLembretes();
    clearReminders();
    lembretes.forEach((element) {
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
      _reminders.add(reminder);
    });
    notifyListeners();
  }

  // Adiciona um lembrete
  Future<void> addReminder(Reminder reminder) async {
    _reminders.add(reminder);
    notifyListeners();
  }

  void clearReminders() {
    _reminders.clear();
    notifyListeners();
  }

  // Retorna lembretes ativos
  List<Reminder> get activeReminders =>
      _reminders.where((reminder) => !reminder.isCompleted).toList();

  // Retorna lembretes concluídos
  List<Reminder> get completedReminders =>
      _reminders.where((reminder) => reminder.isCompleted).toList();

  // Atualiza um lembrete
  Future<void> updateReminder(Reminder reminder) async {
    var response = await http.patch(
      Uri.parse('$apiUrl/${reminder.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reminder.toJson()),
    );
    if (response.statusCode == 200) {
      _reminders[_reminders.indexWhere((r) => r.id == reminder.id)] = reminder;
      notifyListeners();
    }
  }

  void markAsCompleted(String reminderId) {
    final index =
        _reminders.indexWhere((reminder) => reminder.id == reminderId);
    if (index != -1) {
      _reminders[index].isCompleted = true;
      notifyListeners();
    }
  }

  // Remove um lembrete
  Future<void> deleteReminder(String id) async {
    var response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 204) {
      _reminders.removeWhere((r) => r.id == id);
      notifyListeners();
    }
  }

  // Outros métodos conforme necessário...
}
