import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'Anasayfa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Kullanıcı verilerini saklamak için
  runApp(GetMaterialApp(home: LoginPage()));
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  final storage = GetStorage(); // Giriş yapan kullanıcıyı saklamak için

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
    });

    final String url = "http://sdr.acilimsoft.com/apppublishsource/EBRAR_TEST/api/User/Login";

    Map<String, dynamic> body = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim()
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print("📌 API Yanıt Kodu: ${response.statusCode}");
      print("📌 API Yanıtı: ${response.body}");

      if (response.statusCode == 200 && responseData["message"] == "Giriş başarılı.") {
        // ✅ Kullanıcı verisini çek
        Map<String, dynamic> user = responseData["user"] ?? {};
        int userId = user["id"] ?? -1;

        print("📌 API'den Dönen Kullanıcı ID: $userId");

        if (userId != -1) {
          // ✅ Kullanıcıyı hemen yönlendir
          Get.offAll(() => Anasayfa(), transition: Transition.fadeIn, duration: Duration(milliseconds: 500));

          // ✅ Kullanıcı verisini GetStorage ile sakla
          await storage.write("userData", jsonEncode(user));

          print("✅ Kullanıcı bilgileri başarıyla saklandı.");
        } else {
          Get.snackbar("Hata", "Kullanıcı ID'si alınamadı!",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Hata", "Giriş başarısız! Sunucudan eksik veri döndü.",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Bağlantı Hatası", "Sunucuya bağlanırken bir hata oluştu: $e",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }

    setState(() {
      _isLoading = false;
    });
  }




  // ✅ Kullanıcı Kayıt Fonksiyonu
  Future<void> registerUser(String email, String password, String firstName, String lastName, String shopName, String address, String phone) async {
    final String url = "http://sdr.acilimsoft.com/apppublishsource/EBRAR_TEST/api/User";

    Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "firstName": firstName,
      "lastName": lastName,
      "shopName": shopName,
      "address": address,
      "phone": phone
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      print("📌 Kayıt API Yanıt Kodu: ${response.statusCode}");
      print("📌 Kayıt API Yanıtı: ${response.body}");

      if (response.statusCode == 200 && responseData["successful"] == true) {
        Get.back();
        Get.snackbar("Başarılı", "Kayıt başarılı! Şimdi giriş yapabilirsiniz.", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Hata", responseData["message"] ?? "Kayıt başarısız!", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Bağlantı Hatası", "Sunucuya bağlanırken bir hata oluştu: $e", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // 📌 Kayıt Ol Dialog Box'ı
  void showRegisterDialog() {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController companyController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    Get.defaultDialog(
      title: "Kayıt Ol",
      content: Column(
        children: [
          TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
          TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: "Şifre")),
          TextField(controller: firstNameController, decoration: InputDecoration(labelText: "İsim")),
          TextField(controller: lastNameController, decoration: InputDecoration(labelText: "Soyisim")),
          TextField(controller: companyController, decoration: InputDecoration(labelText: "Firma Adı")),
          TextField(controller: addressController, decoration: InputDecoration(labelText: "Adres")),
          TextField(controller: phoneController, decoration: InputDecoration(labelText: "Telefon")),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              registerUser(
                emailController.text.trim(),
                passwordController.text.trim(),
                firstNameController.text.trim(),
                lastNameController.text.trim(),
                companyController.text.trim(),
                addressController.text.trim(),
                phoneController.text.trim(),
              );
            },
            child: Text("Kayıt Ol"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Şifre",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: loginUser,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                child: Text("Giriş Yap"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: showRegisterDialog,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                child: Text("Kayıt Ol"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
