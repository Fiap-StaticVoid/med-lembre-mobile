import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medlembre/models/reminder.dart';

class ReminderDetailsScreen extends StatelessWidget {
  final Reminder reminder;

  ReminderDetailsScreen({required this.reminder});

  @override
  Widget build(BuildContext context) {
    // A função isMedicalConsultation é usada para determinar se o código de confirmação deve ser exibido
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
            Text('Título: ${reminder.title}', style: TextStyle(fontSize: 18)),
            Text('Data e Hora: ${DateFormat.yMd().add_Hm().format(reminder.dateTime)}', style: TextStyle(fontSize: 18)),
            if (isConsultation && reminder.confirmationCode.isNotEmpty)
              Text('Código de Confirmação: ${reminder.confirmationCode}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Outros detalhes do lembrete podem ser adicionados aqui
          ],
        ),
      ),
    );
  }
}
