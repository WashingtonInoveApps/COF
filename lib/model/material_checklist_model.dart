// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/cia_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/outher_changes_model.dart';
import 'package:bsu_control/model/section_itens_model.dart';
import 'package:bsu_control/model/team_model.dart';
import 'package:bsu_control/model/user_model.dart';

import 'materials_consumed_model.dart';

class MaterialChecklistModel {
  String? id;
  OBMModel obm;
  TeamModel? team;
  CiaModel? cia;
  String ciaID;
  String obmID;
  String teamID;
  UserModel user;
  List<SectionItensModel>? itens;
  List<SectionItensModel>? materials;
  List<OtherChangeModel>? others;
  List<MaterialsConsumed>? lastMaterialsConsumed;

  MaterialChecklistModel(
      {this.id,
      required this.user,
      required this.obm,
      required this.team,
      this.itens,
      this.materials,
      this.ciaID = '',
      this.obmID = '',
      this.teamID = '',
      this.cia,
      this.others,
      this.lastMaterialsConsumed});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMapResume(),
      'obm': obm.toMapResume(),
      'team': team?.toMap(),
      'cia': cia?.toMapResume(),
      'ciaID': ciaID,
      'obmID': obmID,
      'teamID': teamID,
      'itens': itens?.map((x) => x.toMap()).toList(),
      'materials': materials?.map((x) => x.toMap()).toList(),
      'others': others?.map((x) => x.toMap()).toList(),
      'lastMaterialsConsumed':
          lastMaterialsConsumed?.map((e) => e.toMap()).toList(),
    };
  }

  factory MaterialChecklistModel.fromMap(Map<String, dynamic> map) {
    return MaterialChecklistModel(
      id: map['id'],
      user: UserModel.fromMapResume(map['user'] as Map<String, dynamic>),
      obm: OBMModel.fromMapResume(map['obm'] as Map<String, dynamic>),
      team: map['team'] != null
          ? TeamModel.fromMap(map['team'] as Map<String, dynamic>)
          : null,
      cia: map['cia'] != null
          ? CiaModel.fromMapResume(map['cia'] as Map<String, dynamic>)
          : null,
      ciaID: map['ciaID'] ?? '',
      obmID: map['obmID'] ?? '',
      teamID: map['teamID'] ?? '',
      itens: map['itens'] != null
          ? List<SectionItensModel>.from(
              (map['itens'] as List).map<SectionItensModel?>(
                (x) => SectionItensModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      materials: map['materials'] != null
          ? List<SectionItensModel>.from(
              (map['materials'] as List).map<SectionItensModel?>(
                (x) => SectionItensModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      others: map['others'] != null
          ? List<OtherChangeModel>.from(
              (map['others'] as List).map<OtherChangeModel?>(
                (x) => OtherChangeModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      lastMaterialsConsumed: map['lastMaterialsConsumed'] != null
          ? List<MaterialsConsumed>.from(
              (map['lastMaterialsConsumed'] as List).map<MaterialsConsumed>(
                (x) => MaterialsConsumed.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaterialChecklistModel.fromJson(String source) =>
      MaterialChecklistModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  MaterialChecklistModel copyWith({
    String? id,
    UserModel? user,
    OBMModel? obm,
    TeamModel? team,
    CiaModel? cia,
    String? ciaID,
    String? obmID,
    String? teamID,
    List<SectionItensModel>? itens,
    List<SectionItensModel>? materials,
    List<OtherChangeModel>? others,
    List<MaterialsConsumed>? lastMaterialsConsumed,
  }) {
    return MaterialChecklistModel(
      id: id ?? this.id,
      user: user ?? this.user,
      obm: obm ?? this.obm,
      team: team ?? this.team,
      cia: cia ?? this.cia,
      ciaID: ciaID ?? this.ciaID,
      obmID: obmID ?? this.obmID,
      teamID: teamID ?? this.teamID,
      itens: itens ?? this.itens,
      materials: materials ?? this.materials,
      others: others ?? this.others,
      lastMaterialsConsumed:
          lastMaterialsConsumed ?? this.lastMaterialsConsumed,
    );
  }
}
