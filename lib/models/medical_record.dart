class MedicalRecord {
  String id;
  String userId;
  DateTime date;
  String description;
  // Adicione outros campos conforme necessário

  MedicalRecord({
    required this.id,
    required this.userId,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  static MedicalRecord fromMap(Map<String, dynamic> map) {
  return MedicalRecord(
    id: map['id'],
    userId: map['userId'],
    date: DateTime.tryParse(map['date']) ?? DateTime.now(), // Data padrão
    description: map['description'],
  );
}

}
