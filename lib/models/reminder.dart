class Reminder {
  String id;
  String titulo;
  String horaInicio;
  int intervalo;
  String intervaloTipo;
  int duracao;
  String duracaoTipo;
  bool concluido;
  String emoji;
  DateTime dateTime;
  String frequencyType;
  int timesPerDay;
  int intervalInHours;
  int intervalInMinutes;
  String description;
  String address;
  String confirmationCode;
  bool isCompleted;

  Reminder({
    required this.id,
    required this.titulo,
    required this.horaInicio,
    required this.intervalo,
    required this.intervaloTipo,
    required this.duracao,
    required this.duracaoTipo,
    required this.concluido,
    this.emoji = '💧',
    required this.dateTime,
    this.frequencyType = 'times_per_day',
    this.timesPerDay = 4,
    this.intervalInHours = 6,
    this.intervalInMinutes = 30,
    this.description = '',
    this.address = '',
    this.confirmationCode = '',
    this.isCompleted = false,
  });

  bool isMedicalConsultation() {
    List<String> medicalKeywords = [
      'consulta',
      'médica',
      'clínica',
      'hospital',
      'doutor',
      'médico'
    ];
    return medicalKeywords
        .any((keyword) => titulo.toLowerCase().contains(keyword));
  }

  String getTimeUntil() {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    if (difference.isNegative) {
      return "Lembrete passado";
    } else if (difference.inDays > 0) {
      return "Faltam ${difference.inDays} dias";
    } else if (difference.inHours > 0) {
      return "Faltam ${difference.inHours} horas";
    } else if (difference.inMinutes > 0) {
      return "Faltam ${difference.inMinutes} minutos";
    } else {
      return "Lembrete muito em breve";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'horaInicio': horaInicio,
      'intervalo': intervalo,
      'intervaloTipo': intervaloTipo,
      'duracao': duracao,
      'duracaoTipo': duracaoTipo,
      'concluido': concluido,
    };
  }

  Reminder.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        titulo = json['titulo'],
        horaInicio = json['horaInicio'],
        intervalo = json['intervalo'],
        intervaloTipo = json['intervaloTipo'],
        duracao = json['duracao'],
        duracaoTipo = json['duracaoTipo'],
        concluido = json['concluido'],
        emoji = '💧',
        dateTime = DateTime.parse(json['horaInicio']),
        frequencyType = 'times_per_day',
        timesPerDay = 4,
        intervalInHours = 6,
        intervalInMinutes = 30,
        description = '',
        address = '',
        confirmationCode = '',
        isCompleted = json['concluido'];
}
