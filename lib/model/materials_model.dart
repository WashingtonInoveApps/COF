import 'package:bsu_control/model/cia_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/team_model.dart';

class MaterialsModel {
  final String? id;
  final String obmID;
  final String ciaID;
  final String obs;
  final TeamModel team;
  final CiaModel cia;
  final OBMModel obm;
  final List<ItensChangesModel> itens;

  MaterialsModel({
    required this.id,
    required this.obmID,
    required this.ciaID,
    required this.obs,
    required this.team,
    required this.cia,
    required this.obm,
    required this.itens,
  });
}
