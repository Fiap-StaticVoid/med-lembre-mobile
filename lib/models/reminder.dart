class Reminder {
  String id;
  String title;
  String emoji;
  DateTime dateTime;
  String frequencyType;
  int timesPerDay;
  int intervalInHours;
  int intervalInMinutes;
  String description; // Descrição do lembrete
  String address; // Endereço para consultas médicas
  String confirmationCode; // Código de confirmação para consultas médicas
  bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
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

  // Método para verificar se o lembrete é uma consulta médica
  bool isMedicalConsultation() {
    // Define as palavras-chave para consulta médica
    List<String> medicalKeywords = ['consulta', 'médica', 'clínica', 'hospital', 'doutor', 'médico'];

    // Verifica se o título contém alguma das palavras-chave
    for (String keyword in medicalKeywords) {
      if (this.title.toLowerCase().contains(keyword)) {
        return true;
      }
    }
    return false;
  }

   // Método para calcular o tempo restante até o lembrete
  String getTimeUntil() {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      return "Lembrete passado";
    } else if (difference.inDays > 0) {
      return "Você será lembrado em ${difference.inDays} dias";
    } else if (difference.inHours > 0) {
      return "Você será lembrado em ${difference.inHours} horas";
    } else if (difference.inMinutes > 0) {
      return "Você será lembrado em ${difference.inMinutes} minutos";
    } else {
      return "Lembrete muito em breve";
    }
  }
  
  // Métodos para conversão de/para JSON podem ser adicionados aqui, se necessário.
}
