import "package:medlembre/services/requestController.dart";

enum Recorrencia { horario, diario, semanal, mensal, anual }

Recorrencia recorrenciaFromString(String text) {
  return Recorrencia.values.firstWhere((e) => e.name == text)
}

String recorrenciaToString(Recorrencia rec) {
  return rec.name;
}

class Lembrete {
  String? id;
  String titulo;
  String horaInicio;
  int intervalo;
  String intervaloTipo;
  int duracao;
  String duracaoTipo;
  bool concluido;

  Lembrete(
    this.id,
    this.titulo,
    this.horaInicio,
    this.intervalo,
    this.intervaloTipo,
    this.duracao,
    this.duracaoTipo,
    this.concluido,
  );

  Lembrete.fromJSON(Map<String, dynamic> data)
      : id = data["id"] as String,
        titulo = data["titulo"] as String,
        horaInicio = data["horaInicio"] as String,
        intervalo = data["intervalo"] as int,
        intervaloTipo = data["intervaloTipo"] as String,
        duracao = data["duracao"] as int,
        duracaoTipo = data["duracaoTipo"] as String,
        concluido = data["concluido"] as bool;

  Map<String, dynamic> tojSON() {
    return {
      "titulo": titulo,
      "horaInicio": horaInicio,
      "intervalo": intervalo,
      "intervaloTipo": intervaloTipo,
      "duracao": duracao,
      "duracaoTipo": duracaoTipo,
      "concluido": concluido
    };
  }
}

Future<List<Lembrete>> listarLembretes() async {
  var req = RequestController("127.0.0.1:8000");
  var datas = await req.get("lembretes", null);
  List<Lembrete> lembretes = [];
  for (var i = 0; i < datas.length; i++) {
    lembretes.add(Lembrete.fromJSON(datas[i]));
  }
  print(lembretes);
  return lembretes;
}

Future<Lembrete> criarLembrete(Lembrete lembrete) async {
  var req = RequestController("127.0.0.1:8000");
  var data = await req.post("lembretes", lembrete.tojSON());
  var _lembrete = Lembrete.fromJSON(data);
  print(_lembrete);
  return _lembrete;
}
