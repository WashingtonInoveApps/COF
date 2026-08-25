// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/file_model.dart';
import 'package:bsu_control/model/user_model.dart';

class CarServiceModel {
  String? id;
  DateTime date;
  DateTime? expired;
  CarModel? car;
  String description;
  String local;
  String obmID;
  String obs;
  StateCarProblems problem;
  UserModel user;
  List<FileModel>? images;

  CarServiceModel({
    this.id,
    required this.date,
    this.car,
    this.description = '',
    this.obs = '',
    this.obmID = '',
    this.local = '',
    this.problem = StateCarProblems.others,
    required this.user,
    this.images,
    this.expired,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'expired': expired?.millisecondsSinceEpoch,
      'car': car?.toMapServiceResume(),
      'description': description,
      'local': local,
      'obmID': obmID,
      'obs': obs,
      'problem': problem.name,
      'user': user.toMapResume(),
      'images': images?.map((x) => x.toMap()).toList(),
    };
  }

  factory CarServiceModel.fromMap(Map<String, dynamic> map) {
    return CarServiceModel(
      id: map['id'] != null ? map['id'] as String : null,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      obmID: map['obmID'] ?? '',
      expired: map['expired'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expired'] as int)
          : null,
      obs: map['obs'] ?? '',
      car: CarModel.fromMapServiceResume(map['car'] as Map<String, dynamic>),
      description: map['description'] as String,
      local: map['local'] as String,
      problem: CarEnumCore.stateCarProblemsFromString(map['problem']),
      user: UserModel.fromMapResume(map['user'] as Map<String, dynamic>),
      images: map['images'] != null
          ? List<FileModel>.from(
              (map['images'] as List).map<FileModel?>(
                (x) => FileModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarServiceModel.fromJson(String source) =>
      CarServiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  CarServiceModel copyWith({
    String? id,
    DateTime? date,
    DateTime? expired,
    CarModel? car,
    String? description,
    String? local,
    String? obmID,
    String? obs,
    StateCarProblems? problem,
    UserModel? user,
    List<FileModel>? images,
  }) {
    return CarServiceModel(
      id: id ?? this.id,
      date: date ?? this.date,
      expired: expired ?? this.expired,
      car: car ?? this.car,
      description: description ?? this.description,
      local: local ?? this.local,
      obmID: obmID ?? this.obmID,
      obs: obs ?? this.obs,
      problem: problem ?? this.problem,
      user: user ?? this.user,
      images: images ?? this.images,
    );
  }
}
