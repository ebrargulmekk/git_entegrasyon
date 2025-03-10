import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ProfilSayfasi extends StatefulWidget {
  @override
  _ProfilSayfasiState createState() => _ProfilSayfasiState();
}

class _ProfilSayfasiState extends State<ProfilSayfasi> {
  final storage = GetStorage(); // 📌 Kullanıcı verilerini buradan okuyacağız.

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData(); // 📌 Uygulama açıldığında kullanıcı verilerini yükle
  }

  // 📌 Kullanıcı verilerini GetStorage'tan yükle
  void loadUserData() {
    String? storedData = storage.read("userData");

    if (storedData != null) {
      Map<String, dynamic> userData = jsonDecode(storedData);

      setState(() {
        emailController.text = userData["email"] ?? "";
        passwordController.text = userData["password"] ?? "";
        firstNameController.text = userData["firstName"] ?? "";
        lastNameController.text = userData["lastName"] ?? "";
        shopNameController.text = userData["shopName"] ?? "";
        addressController.text = userData["address"] ?? "";
        phoneController.text = userData["phone"] ?? "";
      });

      print("✅ Kullanıcı verileri başarıyla yüklendi.");
    } else {
      print("❌ Kullanıcı verisi bulunamadı!");
      Get.snackbar("Hata", "Kullanıcı bilgileri alınamadı! Lütfen tekrar giriş yapın.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // 📌 Kullanıcı bilgilerini güncelleme fonksiyonu
  Future<void> updateUserProfile() async {
    final String url = "http://sdr.acilimsoft.com/apppublishsource/EBRAR_TEST/api/User/Update";

    // 📌 Kullanıcı ID'sini GetStorage'tan al
    int? userId = storage.read("userId");
    if (userId == null || userId == -1) {
      Get.snackbar("Hata", "Kullanıcı ID'si bulunamadı!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // 📌 Güncellenecek kullanıcı verilerini oluştur
    Map<String, dynamic> updatedUserData = {
      "id": userId, // 🔥 Eğer API ID bekliyorsa bunu ekle
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "shopName": shopNameController.text.trim(),
      "address": addressController.text.trim(),
      "phone": phoneController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedUserData),
      );

      print("📌 Güncelleme API Yanıt Kodu: ${response.statusCode}");
      print("📌 Güncelleme API Yanıtı: ${response.body}");

      if (response.statusCode == 200) {
        // 📌 API’den gelen yanıtta hata olup olmadığını kontrol et
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey("error") || responseData["status"] == "fail") {
          Get.snackbar("Hata", "API Hatası: ${responseData["message"] ?? "Bilinmeyen hata"}",
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        // 📌 Verileri GetStorage içinde güncelle
        await storage.write("userData", jsonEncode(updatedUserData));

        Get.snackbar("Başarılı", "Bilgileriniz güncellendi!",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Hata", "Güncelleme başarısız! Sunucu hatası olabilir.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("❌ Güncelleme Hatası: $e");
      Get.snackbar("Bağlantı Hatası", "Sunucuya bağlanırken bir hata oluştu: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil Sayfası"), backgroundColor: Colors.purple),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              readOnly: true, // 📌 Email değiştirilemez!
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Şifre"),
              obscureText: true,
            ),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: "İsim"),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: "Soyisim"),
            ),
            TextField(
              controller: shopNameController,
              decoration: InputDecoration(labelText: "Firma Adı"),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Adres"),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Telefon"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateUserProfile, // 📌 Güncelleme fonksiyonunu çağır
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              child: Text("Güncelle"),
            ),
          ],
        ),
      ),
    );
  }
}
