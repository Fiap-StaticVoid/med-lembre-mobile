import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medlembre/models/reminder.dart';

class ReminderDetailsScreen extends StatelessWidget {
  final Reminder reminder;

  ReminderDetailsScreen({required this.reminder});

  @override
  Widget build(BuildContext context) {
    bool isConsultation = reminder.isMedicalConsultation();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Lembrete'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Título: ${reminder.titulo}', style: TextStyle(fontSize: 18)),
            Text(
                'Data e Hora: ${DateFormat.yMd().add_Hm().format(reminder.dateTime)}',
                style: TextStyle(fontSize: 18)),
            Text('Emoji: ${reminder.emoji}', style: TextStyle(fontSize: 18)),
            Text('Frequência: ${reminder.frequencyType}',
                style: TextStyle(fontSize: 18)),
            Text('Vezes por Dia: ${reminder.timesPerDay}',
                style: TextStyle(fontSize: 18)),
            Text('Intervalo em Horas: ${reminder.intervalInHours}',
                style: TextStyle(fontSize: 18)),
            Text('Intervalo em Minutos: ${reminder.intervalInMinutes}',
                style: TextStyle(fontSize: 18)),
            Text('Descrição: ${reminder.description}',
                style: TextStyle(fontSize: 18)),
            Text('Endereço: ${reminder.address}',
                style: TextStyle(fontSize: 18)),
            if (isConsultation && reminder.confirmationCode.isNotEmpty)
              Text('Código de Confirmação: ${reminder.confirmationCode}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
