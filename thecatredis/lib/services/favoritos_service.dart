import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thecatredis/models/cat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritosService {
  Future<(bool r, List<CatModel> gatos, String m)> getAll() async {
    List<CatModel> cats = [];
    String mensagem = '';

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty || email.isEmpty) {
      return (false, cats, 'Usuário não autenticado.');
    }

    final r = await http.get(Uri.parse('https://sueliton.shop/favoritos'), headers: {'authorization': token});

    if (r.statusCode == 200) {
      // [https://cdn2.thecatapi.com/images/h8.jpg, https://cdn2.thecatapi.com/images/19l.gif, https://cdn2.thecatapi.com/images/1cl.jpg, https://cdn2.thecatapi.com/images/1n6.jpg]
      final List<dynamic> data = jsonDecode(r.body);

      //O ID é a parte final da URL (sem a extensão)

      if (data.isNotEmpty) {
        cats = data.map((e) => CatModel(url: e, id: e.split('/').last.split('.').first ?? e)).toList();
      }

      mensagem = cats.isEmpty ? 'Nenhum gatinho favorito encontrado.' : '${cats.length} gatinhos favoritos encontrados.';
    }

    return (r.statusCode == 200, cats, mensagem);
  }

  Future<(bool r, String m)> addCat(CatModel cat) async {
    String mensagem = '';

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty || email.isEmpty) {
      return (false, 'Usuário não autenticado.');
    }

    final r = await http.post(Uri.parse('https://sueliton.shop/addfavoritos'), body: {
      "useremail": email,
      "favorito": cat.url,
    }, headers: {
      'authorization': token
    });

    return (r.statusCode == 200, mensagem);
  }

  //Remover favorito
  Future<(bool r, String m)> removeCat(CatModel cat) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty || email.isEmpty) {
      return (false, 'Usuário não autenticado.');
    }

    final r = await http.delete(Uri.parse('https://sueliton.shop/favoritos'), body: {
      "useremail": email,
      "favorito": cat.url,
    }, headers: {
      'authorization': token
    });

    return (r.statusCode == 200, r.statusCode == 200 ? 'Gatinho removido com sucesso.' : 'Erro ao remover gatinho.');
  }
}
