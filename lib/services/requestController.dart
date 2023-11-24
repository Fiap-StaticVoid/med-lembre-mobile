import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestController {
  String urlBase;
  RequestController(this.urlBase);

  Future<Map<String, dynamic>> post(
      String route, Map<String, dynamic> data) async {
    var completeRoute = Uri.http(urlBase, route);
    var response = await http.post(completeRoute,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<dynamic>> get(String route, param1, {String? id}) async {
    if (id != null) {
      route += "/$id";
    }
    var completeRoute = Uri.http(urlBase, route);
    var response = await http.get(completeRoute);
    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<int> delete(String route, String id) async {
    route += "/$id";
    var completeRoute = Uri.http(urlBase, route);
    var response = await http.delete(completeRoute);
    return response.statusCode;
  }

  Future<Map<String, dynamic>> patch(
      String route, String id, Map<String, dynamic> data) async {
    route += "/$id";
    var completeRoute = Uri.http(urlBase, route);
    var response = await http.patch(completeRoute,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
