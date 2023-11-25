import "package:medlembre/services/requestController.dart";

class Registro {
  String? id;
  String titulo;
  String data;
  String observacoes;

  Registro(
    this.id,
    this.titulo,
    this.data,
    this.observacoes,
  );

  Registro.fromJSON(Map<String, dynamic> data)
      : id = data["id"] as String,
        titulo = data["titulo"] as String,
        data = data["data"] as String,
        observacoes = data["observacoes"] as String;

  Map<String, dynamic> tojSON() {
    return {
      "titulo": titulo,
      "data": data,
      "observacoes": observacoes,
    };
  }
}

Future<Registro> criarRegistro(Registro registro) async {
  var req = RequestController("127.0.0.1:8000");
  var data = await req.post("registros", registro.tojSON());
  var _registro = Registro.fromJSON(data);
  return _registro;
}

Future<List<Registro>> listarRegistros() async {
  var req = RequestController("127.0.0.1:8000");
  var datas = await req.get("registros", null);
  List<Registro> lembretes = [];
  for (var i = 0; i < datas.length; i++) {
    lembretes.add(Registro.fromJSON(datas[i]));
  }
  return lembretes;
}

Future<bool> deletarRegistro(String id) async {
  var req = RequestController("127.0.0.1:8000");
  var status = await req.delete("registros", id);
  return status == 204;
}

Future<Registro> atualizarRegistro(String id, Registro registro) async {
  var req = RequestController("127.0.0.1:8000");
  var data = await req.patch("registros", id, registro.tojSON());
  var _registro = Registro.fromJSON(data);
  return _registro;
}
