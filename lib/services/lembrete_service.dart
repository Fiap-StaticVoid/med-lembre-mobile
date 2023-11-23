import "package:medlembre/services/requestController.dart";

enum Recorrencia { horario, diario, semanal, mensal, anual }

Recorrencia recorrenciaFromString(String text) {
  return Recorrencia.values.firstWhere((e) => e.name == text)
}

String recorrenciaToString(Recorrencia rec) {
  return rec.name
}

class Lembrete {
  String? id;
  String titulo;
  String horaInicio;
  int intervalo;
  Recorrencia intervaloTipo;
  int duracao;
  Recorrencia duracaoTipo;
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
  
  Lembrete.fromJSON(Map<String,dynamic> data)
    : id = data["id"] as String,
      titulo = data["titulo"] as String,
      horaInicio = data["horaInicio"] as String,
      intervalo = data["intervalo"] as int,
      intervaloTipo = recorrenciaFromString(data["intervaloTipo"] as String),
      duracao = data["duracao"] as int,
      duracaoTipo =  recorrenciaFromString(data["duracaoTipo"] as String),
      concluido = data ["concluido"] as bool;
      
  Map<String, dynamic> tojSON() {
    return {
      "titulo": titulo,
      "horaInicio": horaInicio,
      "intervalo": intervalo,
      "intervaloTipo": recorrenciaToString(intervaloTipo),
      "duracao": duracao,
      "duracaoTipo": recorrenciaToString(duracaoTipo),
      "concluido": concluido
    };
  }
}

Future <Lembrete> criarLembrete(Lembrete lembrete) async {
  var req = RequestControlelr("127.0.0.1:8000");
  var data = await req.post("lembretes", lembrete.tojSON());
  var _lembrete = Lembrete.fromJSON(data);
  return  _lembrete;
}

Future <List<Lembrete>> listarLembretes() async {
  var req = RequestControlelr("127.0.0.1:8000");
  var datas = await req.get("lembretes", null);
  List<Lembrete> lembretes = [];
  for (var i = 0; i<datas.length;i++){
    lembretes.add(
      Lembrete.fromJSON(datas[i])
    );
  }
  return  lembretes;
}

Future <bool> deletarLembrete(String id) async {
  var req = RequestControlelr("127.0.0.1:8000");
  var status = await req.delete("lembretes", id);
  return status == 204;
}

Future <Lembrete> atualizarLembrete(String id, Lembrete lembrete) async {
  var req = RequestControlelr("127.0.0.1:8000");
  var data = await req.patch("lembretes", id, lembrete.tojSON());
  var _lembrete = Lembrete.fromJSON(data);
  return  _lembrete;
}
