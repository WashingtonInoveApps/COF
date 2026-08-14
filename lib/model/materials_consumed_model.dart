// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/user_model.dart';

class MaterialsConsumed {
  final DateTime date;
  final UserModel user;
  final List<ItemModel> itens;

  MaterialsConsumed({
    required this.date,
    required this.user,
    required this.itens,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'user': user.toMap(),
      'itens': itens.map((x) => x.toMap()).toList(),
    };
  }

  factory MaterialsConsumed.fromMap(Map<String, dynamic> map) {
    return MaterialsConsumed(
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
      itens: List<ItemModel>.from(
        (map['itens'] as List).map<ItemModel>(
          (x) => ItemModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MaterialsConsumed.fromJson(String source) =>
      MaterialsConsumed.fromMap(json.decode(source) as Map<String, dynamic>);
}
