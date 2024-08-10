import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thecatredis/models/cat_model.dart';
import 'package:thecatredis/services/data/gatins.dart';

//Variável estática da API KEY = x-api-key
const apiKey = 'live_vPk1MS3qSLZlGF6jTuAz7dMeBKueJIjB4h93rrtt5NkvFeCO3gzRhJ2PWe8WifzA';

class CatService {
  Future<(List<CatModel> gatos, bool r)> getImages({bool realAPI = false}) async {
    List<CatModel> cats = [];

    if (realAPI == false) {
      //Mapa de gatos
      cats = gatos.map((g) => CatModel(id: g['id'], url: g['url'])).toList();

      return (cats, true);
    } else {
      final response = await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search?limit=100'), headers: {
        'x-api-key': apiKey,
      });

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        for (var item in json) {
          cats.add(CatModel.fromJson(item));
        }

        print('Gatos carregados: ${cats.length}');
      }

      return (cats, response.statusCode == 200);
    }
  }
}
