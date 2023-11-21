import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/reminder.dart';
import '../models/reminders_model.dart';

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
      _titleController.text = widget.existingReminder!.title;
      _selectedDate = widget.existingReminder!.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(widget.existingReminder!.dateTime);
      _selectedEmoji = widget.existingReminder!.emoji;
      _frequencyType = widget.existingReminder!.frequencyType;
      _timesPerDay = widget.existingReminder!.timesPerDay;
      _intervalInHours = widget.existingReminder!.intervalInHours;
      _intervalInMinutes = widget.existingReminder!.intervalInMinutes;
    } else {
      // Se não estiver editando um lembrete existente, inicialize com valores padrão
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
  // Lista de palavras-chave relacionadas a consultas médicas
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
    // Adicione mais palavras-chave conforme necessário
  ];

  // Converte o título para letras minúsculas e remove acentos
  String lowerCaseTitle = removeDiacritics(title.toLowerCase());

  // Verifica se o título contém alguma das palavras-chave
  for (var keyword in medicalKeywords) {
    if (lowerCaseTitle.contains(keyword)) {
      return true;
    }
  }
  return false;
}

// Função para remover acentos de uma string
String removeDiacritics(String str) {
  var withDia = 'áàãâäéèêëíìîïóòõôöúùûüç';
  var withoutDia = 'aaaaaeeeeiiiiooooouuuuc';
  for (int i = 0; i < withDia.length; i++) {
    str = str.replaceAll(withDia[i], withoutDia[i]);
  }
  return str;
}


  

  void _saveOrUpdateReminder() {
    String confirmationCode = widget.existingReminder?.confirmationCode ?? '';
    if (_isMedicalConsultation(_titleController.text) && confirmationCode.isEmpty) {
      confirmationCode = _generateConfirmationCode();
    }

    final reminder = Reminder(
      id: widget.existingReminder?.id ?? DateTime.now().toString(),
      title: _titleController.text,
      emoji: _selectedEmoji,
      dateTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute
      ),
      frequencyType: _frequencyType,
      timesPerDay: _timesPerDay,
      intervalInHours: _intervalInHours,
      intervalInMinutes: _intervalInMinutes,
      confirmationCode: confirmationCode,
    );

    if (widget.existingReminder == null) {
      Provider.of<RemindersModel>(context, listen: false).addReminder(reminder);
    } else {
      Provider.of<RemindersModel>(context, listen: false).updateReminder(reminder);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingReminder == null ? 'Adicionar Lembrete' : 'Editar Lembrete'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título do Lembrete', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Data de Início: ${DateFormat.yMd().format(_selectedDate)}'),
              subtitle: Text('Hora de Início: ${_selectedTime.format(context)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                await _selectDate(context);
                await _selectTime(context);
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Escolha um Emoji', border: OutlineInputBorder()),
              value: _selectedEmoji,
              items: _emojis.map((String emoji) {
                return DropdownMenuItem<String>(value: emoji, child: Text(emoji));
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedEmoji = newValue;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Tipo de Frequência', border: OutlineInputBorder()),
              value: _frequencyType,
              items: [
                DropdownMenuItem(value: 'times_per_day', child: Text('Vezes por dia')),
                DropdownMenuItem(value: 'interval_in_hours', child: Text('Intervalo em horas')),
                DropdownMenuItem(value: 'interval_in_minutes', child: Text('Intervalo em minutos')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _frequencyType = newValue;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            _buildFrequencyInput(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveOrUpdateReminder,
              child: Text(widget.existingReminder == null ? 'Adicionar' : 'Editar'),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyInput() {
    switch (_frequencyType) {
      case 'times_per_day':
        return TextField(
          decoration: InputDecoration(labelText: 'Vezes por dia', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            if (value.isNotEmpty) {
              _timesPerDay = int.tryParse(value) ?? _timesPerDay;
            }
          },
        );
      case 'interval_in_hours':
        return TextField(
          decoration: InputDecoration(labelText: 'Intervalo em horas', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            if (value.isNotEmpty) {
              _intervalInHours = int.tryParse(value) ?? _intervalInHours;
            }
          },
        );
      case 'interval_in_minutes':
        return TextField(
          decoration: InputDecoration(labelText: 'Intervalo em minutos', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            if (value.isNotEmpty) {
              _intervalInMinutes = int.tryParse(value) ?? _intervalInMinutes;
            }
          },
        );
      default:
        return Container();
    }
  }
}
