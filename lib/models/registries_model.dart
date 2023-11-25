import 'package:flutter/material.dart';
import 'package:medlembre/services/registro_service.dart';

class RegistriesModel with ChangeNotifier {
  List<Registro> _registries = [];

  void loadRegistries() async {
    clearRegistries();
    var registros = await listarRegistros();
    registros.forEach((element) {
      addRegistry(element);
    });
    notifyListeners();
  }

  // Adiciona um Registro
  Future<void> addRegistry(Registro registry) async {
    _registries.add(registry);
    notifyListeners();
  }

  void clearRegistries() {
    _registries.clear();
    notifyListeners();
  }

  List<Registro> get registries => _registries;
}
