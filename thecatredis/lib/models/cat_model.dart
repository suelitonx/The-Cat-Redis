// ignore_for_file: non_constant_identifier_names

class CatModel {
  String id;
  String url;
  int width;
  int height;
  /*
  String weight;
  String name;
  String cfa_url;
  String vetstreet_url;
  String vcahospitals_url;
  String temperament;
  String origin;
  String country_codes;
  String country_code;
  String description;
  String life_span;
  int indoor;
  int lap;
  String alt_names;
  int adaptability;
  int affection_level;
  int child_friendly;
  int dog_friendly;
  int energy_level;
  int grooming;
  int health_issues;
  int intelligence;
  int shedding_level;
  int social_needs;
  int stranger_friendly;
  int vocalisation;
  int experimental;
  int hairless;
  int natural;
  int rare;
  int rex;
  int suppressed_tail;
  int short_legs;
  String wikipedia_url;
  int hypoallergenic;
  String reference_image_id;
  */

  CatModel({
    required this.id,
    required this.url,
    this.width = 0,
    this.height = 0,
    /*
    this.weight = '',
    this.name = '',
    this.cfa_url = '',
    this.vetstreet_url = '',
    this.vcahospitals_url = '',
    this.temperament = '',
    this.origin = '',
    this.country_codes = '',
    this.country_code = '',
    this.description = '',
    this.life_span = '',
    this.indoor = 0,
    this.lap = 0,
    this.alt_names = '',
    this.adaptability = 0,
    this.affection_level = 0,
    this.child_friendly = 0,
    this.dog_friendly = 0,
    this.energy_level = 0,
    this.grooming = 0,
    this.health_issues = 0,
    this.intelligence = 0,
    this.shedding_level = 0,
    this.social_needs = 0,
    this.stranger_friendly = 0,
    this.vocalisation = 0,
    this.experimental = 0,
    this.hairless = 0,
    this.natural = 0,
    this.rare = 0,
    this.rex = 0,
    this.suppressed_tail = 0,
    this.short_legs = 0,
    this.wikipedia_url = '',
    this.hypoallergenic = 0,
    this.reference_image_id = '',
    */
  });

  factory CatModel.fromJson(Map<String, dynamic> json /*, Map<String, dynamic> breeds */) {
    return CatModel(
      id: json['id'],
      url: json['url'],
      width: json['width'],
      height: json['height'],
      /*
      weight: breeds['weight']['imperial'] ?? '',
      name: breeds['name'] ?? '',
      cfa_url: breeds['cfa_url'] ?? '',
      vetstreet_url: breeds['vetstreet_url'] ?? '',
      vcahospitals_url: breeds['vcahospitals_url'] ?? '',
      temperament: breeds['temperament'] ?? '',
      origin: breeds['origin'] ?? '',
      country_codes: breeds['country_codes'] ?? '',
      country_code: breeds['country_code'] ?? '',
      description: breeds['description'] ?? '',
      life_span: breeds['life_span'] ?? '',
      indoor: breeds['indoor'] ?? 0,
      lap: breeds['lap'] ?? 0,
      alt_names: breeds['alt_names'] ?? '',
      adaptability: breeds['adaptability'] ?? 0,
      affection_level: breeds['affection_level'] ?? 0,
      child_friendly: breeds['child_friendly'] ?? 0,
      dog_friendly: breeds['dog_friendly'] ?? 0,
      energy_level: breeds['energy_level'] ?? 0,
      grooming: breeds['grooming'] ?? 0,
      health_issues: breeds['health_issues'] ?? 0,
      intelligence: breeds['intelligence'] ?? 0,
      shedding_level: breeds['shedding_level'] ?? 0,
      social_needs: breeds['social_needs'] ?? 0,
      stranger_friendly: breeds['stranger_friendly'] ?? 0,
      vocalisation: breeds['vocalisation'] ?? 0,
      experimental: breeds['experimental'] ?? 0,
      hairless: breeds['hairless'] ?? 0,
      natural: breeds['natural'] ?? 0,
      rare: breeds['rare'] ?? 0,
      rex: breeds['rex'] ?? 0,
      suppressed_tail: breeds['suppressed_tail'] ?? 0,
      short_legs: breeds['short_legs'] ?? 0,
      wikipedia_url: breeds['wikipedia_url'] ?? '',
      hypoallergenic: breeds['hypoallergenic'] ?? 0,
      reference_image_id: breeds['reference_image_id'] ?? '',
      */
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url};
  }
}
