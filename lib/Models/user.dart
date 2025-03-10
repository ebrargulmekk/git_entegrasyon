import 'dart:convert';

class User {
  int id;
  String email;
  String sifre;
  String isim;
  String soyisim;
  String firmaAdi;
  String adres;

  User({
    required this.id,
    required this.email,
    required this.sifre,
    required this.isim,
    required this.soyisim,
    required this.firmaAdi,
    required this.adres,
  });

  // JSON'dan User nesnesine dönüştürme
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      sifre: json['sifre'],
      isim: json['isim'],
      soyisim: json['soyisim'],
      firmaAdi: json['firmaAdi'],
      adres: json['adres'],
    );
  }

  // User nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'sifre': sifre,
      'isim': isim,
      'soyisim': soyisim,
      'firmaAdi': firmaAdi,
      'adres': adres,
    };
  }
}
