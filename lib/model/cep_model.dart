// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CEPModel {
  String cep;
  String place;
  String complement;
  String district;
  String location;
  String uf;
  double lat;
  double lon;
  String number;
  String reference;
  int type;
  int typeLocal;
  double distance;
  double value;

  CEPModel(
      {this.cep = '',
      this.place = '',
      this.complement = '',
      this.district = '',
      this.location = '',
      this.reference = '',
      this.uf = '',
      this.lat = 0.0,
      this.lon = 0.0,
      this.type = 0,
      this.typeLocal = 0,
      this.number = '',
      this.value = 0.0,
      this.distance = 0.0});

  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'place': place,
      'complement': complement,
      'district': district,
      'location': location,
      'reference': reference,
      'uf': uf,
      'lat': lat,
      'lon': lon,
      'number': number,
      'typeLocal': typeLocal,
      'type': type,
      'distance': distance,
      'value': value,
    };
  }

  factory CEPModel.fromMap(Map<String, dynamic> map) {
    return CEPModel(
        cep: map['cep'] ?? '',
        place: map['place'] ?? '',
        complement: map['complement'] ?? '',
        reference: map['reference'] ?? '',
        district: map['district'] ?? '',
        location: map['location'] ?? '',
        uf: map['uf'] ?? '',
        lat: map['lat']?.toDouble() ?? 0.0,
        lon: map['lon']?.toDouble() ?? 0.0,
        distance: map['distance']?.toDouble() ?? 0.0,
        value: map['value']?.toDouble() ?? 0.0,
        number: map['number'] ?? '',
        typeLocal: map['typeLocal'] ?? 0,
        type: map['type'] ?? 0);
  }

  String toJson() => json.encode(toMap());

  factory CEPModel.fromJson(String source) =>
      CEPModel.fromMap(json.decode(source));

  CEPModel copyWith(
      {String? cep,
      String? place,
      String? complement,
      String? district,
      String? location,
      String? uf,
      double? lat,
      double? lon,
      double? distance,
      double? value,
      String? number,
      String? reference,
      int? typeLocal,
      int? type}) {
    return CEPModel(
        cep: cep ?? this.cep,
        place: place ?? this.place,
        complement: complement ?? this.complement,
        district: district ?? this.district,
        location: location ?? this.location,
        uf: uf ?? this.uf,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        number: number ?? this.number,
        reference: reference ?? this.reference,
        typeLocal: typeLocal ?? this.typeLocal,
        distance: distance ?? this.distance,
        value: value ?? this.value,
        type: type ?? this.type);
  }
}
