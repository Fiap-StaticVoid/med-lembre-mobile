import 'package:medlembre/services/requestController.dart';
import 'dart:convert';

class Perfil {
  String? id;
  String nome;
  DateTime dataNascimento;
  String tipoSanguineo;
  String genero;
  List<String> alergiasERestricoes;

  Perfil({
    this.id,
    required this.nome,
    required this.dataNascimento,
    required this.tipoSanguineo,
    required this.genero,
    required this.alergiasERestricoes,
  });

  Perfil.fromJSON(Map<String, dynamic> data)
      : id = data["id"],
        nome = data["nome"],
        dataNascimento = DateTime.parse(data["dataNascimento"]),
        tipoSanguineo = data["tipoSanguineo"],
        genero = data["genero"],
        alergiasERestricoes = List<String>.from(data["alergiasERestricoes"]);

  Map<String, dynamic> toJSON() {
    var data =
        "${dataNascimento.year.toString()}-${dataNascimento.month.toString().padLeft(2, '0')}-${dataNascimento.day.toString().padLeft(2, '0')}";
    return {
      "nome": nome,
      "dataNascimento": data,
      "tipoSanguineo": tipoSanguineo,
      "genero": genero,
      "alergiasERestricoes": alergiasERestricoes,
    };
  }
}

class PerfilService {
  final RequestController _req;

  PerfilService(this._req);

  Future<Perfil> criarPerfil(Perfil perfil) async {
    var data = await _req.post("perfis", perfil.toJSON());
    return Perfil.fromJSON(data);
  }

  Future<List<Perfil>> listarPerfis() async {
    var datas =
        await _req.get("perfis", null); // Pass null as the second argument
    return datas
        .map<Perfil>((json) => Perfil.fromJSON(json as Map<String, dynamic>))
        .toList();
  }

  Future<Perfil> fetchUserProfile(String userId) async {
    var data = await _req.get(
        "perfis/$userId", null); // Pass null as the second argument
    return Perfil.fromJSON(data as Map<String, dynamic>);
  }
}
