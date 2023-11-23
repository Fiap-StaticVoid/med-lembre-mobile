import "dart:convert";
import 'dart:js_interop_unsafe';
import 'package:http/http.dart' as http;

class RequestControlelr {
  String url_base;
  RequestControlelr(this.url_base);

  Future<Map<String,dynamic>> post(String route, Map<String,dynamic> data) async {

    var completeRoute = Uri.http(url_base, route);
  
    var response = await http.post(completeRoute,headers: {"Content-Type":"application/json"}, body: jsonEncode(data));
    print(response.body);
    return jsonDecode(response.body) as Map<String,dynamic>;
  }

  Future<List<dynamic>> get(String route, String? id) async {
    if (id != null) {
      route += "/${id}";
    }
    var completeRoute = Uri.http(url_base, route);
    var response = await http.get(completeRoute);
    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<int> delete(String route, String id) async {
    route += "/${id}";

    var completeRoute = Uri.http(url_base, route);
    var response = await http.get(completeRoute);
    return response.statusCode;
  }

  Future<Map<String,dynamic>> patch(String route, String? id, Map<String,dynamic> data) async {
    if (id != null) {
      route += "/${id}";
    }
    var completeRoute = Uri.http(url_base, route);
   var response = await http.post(completeRoute, body: data);
    return jsonDecode(response.body) as Map<String,dynamic>;
  }
}