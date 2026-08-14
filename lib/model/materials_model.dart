// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/cia_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/outher_changes_model.dart';
import 'package:bsu_control/model/section_itens_model.dart';
import 'package:bsu_control/model/team_model.dart';

import 'materials_consumed_model.dart';

class MaterialsModel {
  String? id;
  OBMModel obm;
  TeamModel? team;
  CiaModel? cia;
  String ciaID;
  String obmID;
  String teamID;
  List<SectionItensModel> itens;
  List<OtherChangeModel>? changes;
  List<MaterialsConsumed>? lastMaterialsConsumed;

  MaterialsModel(
      {this.id,
      required this.obm,
      required this.team,
      required this.itens,
      this.ciaID = '',
      this.obmID = '',
      this.teamID = '',
      this.cia,
      this.changes,
      this.lastMaterialsConsumed});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'obm': obm.toMap(),
      'team': team?.toMap(),
      'cia': cia?.toMap(),
      'ciaID': ciaID,
      'obmID': obmID,
      'teamID': teamID,
      'itens': itens.map((x) => x.toMap()).toList(),
      'changes': changes?.map((x) => x.toMap()).toList(),
      'lastMaterialsConsumed':
          lastMaterialsConsumed?.map((e) => e.toMap()).toList(),
    };
  }

  factory MaterialsModel.fromMap(Map<String, dynamic> map) {
    return MaterialsModel(
      id: map['id'] != null ? map['id'] as String : null,
      obm: OBMModel.fromMap(map['obm'] as Map<String, dynamic>),
      team: map['team'] != null
          ? TeamModel.fromMap(map['team'] as Map<String, dynamic>)
          : null,
      cia: map['cia'] != null
          ? CiaModel.fromMap(map['cia'] as Map<String, dynamic>)
          : null,
      ciaID: map['ciaID'] as String,
      obmID: map['obmID'] as String,
      teamID: map['teamID'] as String,
      itens: List<SectionItensModel>.from(
        (map['itens'] as List).map<SectionItensModel>(
          (x) => SectionItensModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      changes: map['changes'] != null
          ? List<OtherChangeModel>.from(
              (map['changes'] as List).map<OtherChangeModel?>(
                (x) => OtherChangeModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      lastMaterialsConsumed: List<MaterialsConsumed>.from(
        (map['lastMaterialsConsumed'] as List).map<MaterialsConsumed>(
          (x) => MaterialsConsumed.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MaterialsModel.fromJson(String source) =>
      MaterialsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
