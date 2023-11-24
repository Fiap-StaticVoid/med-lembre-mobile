import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:medlembre/models/reminder.dart';
import 'package:medlembre/models/reminders_model.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.existingReminder != null) {
      _titleController.text = widget.existingReminder!.titulo;
      _selectedDate = widget.existingReminder!.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(widget.existingReminder!.dateTime);
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

  void _saveOrUpdateReminder() async {
    DateTime fullDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final reminder = Reminder(
      id: widget.existingReminder?.id ?? DateTime.now().toString(),
      titulo: "consulta", // Substitua pelo título desejado
      horaInicio: "21:10:02",
      intervalo: 2,
      intervaloTipo: "diario",
      duracao: 5,
      duracaoTipo: "mensal",
      concluido: false,
      dateTime: fullDateTime, // Forneça um valor válido para dateTime
      emoji: '💧', // Adicione um emoji se desejar
      frequencyType: 'times_per_day', // Escolha o tipo de frequência desejado
      timesPerDay: 4, // Defina o número de vezes por dia
      intervalInHours: 6, // Defina o intervalo em horas
      intervalInMinutes: 30, // Defina o intervalo em minutos
      description: '', // Adicione uma descrição se desejar
      address: '', // Adicione um endereço se desejar
      confirmationCode: '', // Adicione um código de confirmação se desejar
      isCompleted: false, // Define se o lembrete está concluído
    );

    try {
      if (widget.existingReminder == null) {
        await Provider.of<RemindersModel>(context, listen: false)
            .addReminder(reminder);
      } else {
        await Provider.of<RemindersModel>(context, listen: false)
            .updateReminder(reminder);
      }
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar o lembrete: $e')),
      );
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
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título do Lembrete',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(
                  'Data de Início: ${DateFormat.yMd().format(_selectedDate)}'),
              subtitle:
                  Text('Hora de Início: ${_selectedTime.format(context)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                await _selectDate(context);
                await _selectTime(context);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveOrUpdateReminder,
              child: Text(
                  widget.existingReminder == null ? 'Adicionar' : 'Editar'),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
