import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:medlembre/models/reminders_model.dart';
import 'package:medlembre/models/reminder.dart';
import 'package:medlembre/services/lembrete_service.dart';

class AddReminderScreen extends StatefulWidget {
  final Reminder? existingReminder;

  AddReminderScreen({this.existingReminder});

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  String _selectedEmoji = '💧';
  String _frequencyType = 'times_per_day';
  int _timesPerDay = 4;
  int _intervalInHours = 6;
  int _intervalInMinutes = 30;
  final List<String> _emojis = ['💧', '🏃‍♂️', '💊', '📅', '🍎'];
  String _description = '';
  String _address = '';
  String _confirmationCode = '';

  @override
  void initState() {
    super.initState();
    if (widget.existingReminder != null) {
      _titleController.text = widget.existingReminder!.titulo;
      _selectedDate = widget.existingReminder!.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(widget.existingReminder!.dateTime);
      _selectedEmoji = widget.existingReminder!.emoji;
      _frequencyType = widget.existingReminder!.frequencyType;
      _timesPerDay = widget.existingReminder!.timesPerDay;
      _intervalInHours = widget.existingReminder!.intervalInHours;
      _intervalInMinutes = widget.existingReminder!.intervalInMinutes;
      _description = widget.existingReminder!.description;
      _address = widget.existingReminder!.address;
      _confirmationCode = widget.existingReminder!.confirmationCode;
    } else {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  String _generateConfirmationCode() {
    var rng = Random();
    return String.fromCharCodes(List.generate(6, (_) => rng.nextInt(26) + 65));
  }

  bool _isMedicalConsultation(String title) {
    final List<String> medicalKeywords = [
      'consulta',
      'médica',
      'medica',
      'médico',
      'medico',
      'doutor',
      'clínica',
      'clinica',
      'hospital',
    ];

    String lowerCaseTitle = removeDiacritics(title.toLowerCase());

    for (var keyword in medicalKeywords) {
      if (lowerCaseTitle.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  String removeDiacritics(String str) {
    var withDia = 'áàãâäéèêëíìîïóòõôöúùûüç';
    var withoutDia = 'aaaaaeeeeiiiiooooouuuuc';
    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }
    return str;
  }

  void _saveOrUpdateReminder() async {
    String confirmationCode = widget.existingReminder?.confirmationCode ?? '';
    if (_isMedicalConsultation(_titleController.text) &&
        confirmationCode.isEmpty) {
      confirmationCode = _generateConfirmationCode();
    }

    final reminder = Reminder(
      id: widget.existingReminder?.id ?? DateTime.now().toString(),
      titulo: _titleController.text,
      horaInicio: DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      )),
      intervalo: 0, // Ajuste conforme necessário
      intervaloTipo: 'horario', // Ajuste conforme necessário
      duracao: 0, // Ajuste conforme necessário
      duracaoTipo: 'horario', // Ajuste conforme necessário
      concluido: false,
      emoji: _selectedEmoji,
      dateTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      frequencyType: _frequencyType,
      timesPerDay: _timesPerDay,
      intervalInHours: _intervalInHours,
      intervalInMinutes: _intervalInMinutes,
      description: _description,
      address: _address,
      confirmationCode: confirmationCode,
      isCompleted: false,
    );

    try {
      if (widget.existingReminder == null) {
        await Provider.of<RemindersModel>(context, listen: false)
            .addReminder(reminder);
      } else {
        await Provider.of<RemindersModel>(context, listen: false)
            .updateReminder(reminder);
      }
      Navigator.of(context).pop(); // Feche a tela de adição/edição
    } catch (e) {
      print('Erro ao salvar o lembrete: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingReminder == null
            ? 'Adicionar Lembrete'
            : 'Editar Lembrete'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            // Campos de texto, seletores e botões como definido
            // ...
            // Implementação completa dos widgets necessários para a interface
          ],
        ),
      ),
    );
  }

  // Outros métodos e widgets auxiliares
  // ...
}
