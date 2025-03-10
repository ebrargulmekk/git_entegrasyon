import 'package:flutter/material.dart';
import '../http_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HttpService httpService = HttpService();
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      List<dynamic> fetchedUsers = await httpService.getUsers();
      setState(() {
        users = fetchedUsers;
      });
    } catch (e) {
      print("❌ Kullanıcıları çekerken hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kullanıcı Listesi")),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];
          return ListTile(
            title: Text(user["isim"] + " " + user["soyisim"]),
            subtitle: Text(user["email"]),
          );
        },
      ),
    );
  }
}
