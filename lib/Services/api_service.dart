import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String baseUrl = "http://localhost:5000/api/User";

  // 🟢 GET - Tüm Kullanıcıları Listele
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<User> users = body.map((dynamic item) => User.fromJson(item)).toList();
      return users;
    } else {
      throw Exception("Kullanıcılar yüklenemedi!");
    }
  }

  // 🟢 GET - Belirli Kullanıcıyı Getir
  Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Kullanıcı bulunamadı!");
    }
  }

  // 🟢 POST - Yeni Kullanıcı Ekle
  Future<bool> createUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    return response.statusCode == 201;
  }

  // 🟢 PUT - Kullanıcı Güncelle
  Future<bool> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    return response.statusCode == 204;
  }

  // 🟢 DELETE - Kullanıcı Sil
  Future<bool> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    return response.statusCode == 204;
  }
}
