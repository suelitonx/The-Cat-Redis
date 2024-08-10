import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ValueNotifier<bool> {
  //Variável privada que armazena a instância da classe PocketbaseService
  static final AuthService _instance = AuthService._();

  //Método getter que retorna a instância da classe PocketbaseService
  static AuthService get instance => _instance;

  //Construtor privado da classe PocketbaseService
  AuthService._() : super(false);

  var client = http.Client();

  Future<(bool r, String m)> login(String email, String senha) async {
    bool resultado = false;
    String mensagem = '';

    final r = await http.post(Uri.parse('http://localhost:5000/login'), body: {
      "useremail": email,
      "newpassword": senha,
    });

    final json = jsonDecode(r.body);

    if (r.statusCode == 200) {
      resultado = json['authenticated'] ?? true;
      mensagem = json['message'] ?? 'Login efetuado com sucesso.';

      if (resultado) {
        await salvarToken(json['token'], email, senha);
        value = true;
      }
    } else {
      mensagem = json['message'] ?? 'Erro ao efetuar login.';
    }

    return (resultado, mensagem);
  }

  Future<(bool r, String m)> register(String email, String senha) async {
    bool resultado = false;
    String mensagem = '';

    final r = await http.post(Uri.parse('http://localhost:5000/signup'), body: {
      "useremail": email,
      "userpassword": senha,
    });

    final json = jsonDecode(r.body);

    if (r.statusCode == 200) {
      resultado = json['signed'] ?? true;
      mensagem = json['message'] ?? 'Cadastro efetuado com sucesso.';

      if (resultado) {
        await salvarToken(json['token'], email, senha);
        value = true;
      }
    } else {
      mensagem = json['message'] ?? 'Erro ao efetuar cadastro.';
    }

    return (resultado, mensagem);
  }

  Future<void> salvarToken(String token, String email, String senha) async {
    //Salvar token no local storage
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('email', email);
    await prefs.setString('senha', senha);
  }

  Future<String> getToken() async {
    //Obter token do local storage
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<(String e, String s)> getEmailSenha() async {
    //Obter email e senha do local storage
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString('email') ?? '', prefs.getString('senha') ?? '');
  }

  Future<void> init() async {
    value = await validarToken();
  }

  Future<void> deslogar() async {
    //Limpar local storage
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '');
    value = false;
  }

  Future<bool> validarToken() async {
    //Validar token
    final token = await getToken();

    if (token.isEmpty) {
      return false;
    }

    final r = await http.get(Uri.parse('http://localhost:5000/validar'), headers: {'authorization': token});

    if (r.statusCode == 200) {
      print('Token válido: $token');
      return true;
    } else {
      print('Token inválido: $token');
      return false;
    }
  }
}
