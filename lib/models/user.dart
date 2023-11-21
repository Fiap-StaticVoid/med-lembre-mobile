class User {
  String id;
  String name;
  DateTime birthDate;
  String bloodType;
  String gender;
  // Adicione outros campos conforme necessário

  User({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.bloodType,
    required this.gender,
  });

  // Método para converter um objeto User em um mapa, útil para salvar nos bancos de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'bloodType': bloodType,
      'gender': gender,
    };
  }

  // Método para criar um objeto User a partir de um mapa, útil ao recuperar dados dos bancos de dados
  static User fromMap(Map<String, dynamic> map) {
    // Use uma data padrão ou trate de forma que faça sentido para a lógica do seu aplicativo
    DateTime parsedBirthDate = DateTime.tryParse(map['birthDate']) ?? DateTime(1900, 1, 1);

    return User(
      id: map['id'],
      name: map['name'],
      birthDate: parsedBirthDate,
      bloodType: map['bloodType'],
      gender: map['gender'],
    );
  }

}
