import 'package:bsu_control/enum/services_enum.dart';
import 'package:bsu_control/model/service_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/services/repository/service_interface.dart';
import 'package:bsu_control/services/repository/service_repository.dart';
import 'package:mobx/mobx.dart';

import '../../core/validation.dart';
import '../../model/car_model.dart';
import '../../model/config_model.dart';
import '../../model/obm_model.dart';

part 'service_controller.g.dart';

class ServiceController = _ServiceControllerBase with _$ServiceController;

abstract class _ServiceControllerBase with Store {
  final List<UserModel> users;
  final UserModel user;
  final ConfigModel config;
  final ServiceModel? init;
  final List<CarModel> cars;
  final List<ServiceModel> servicesToday;
  final bool update;

  late IServiceRepository repository;

  _ServiceControllerBase({
    required this.config,
    required this.init,
    required this.cars,
    required this.servicesToday,
    required this.update,
    required this.user,
    required this.users,
  }) {
    final startDate = DateTime(date.year, date.month, date.day, 08, 00);
    final endDate = DateTime(date.year, date.month, date.day + 1, 08, 00);

    setComponent(ServicesComponent(
      user: user,
      startDate: startDate,
      endDate: endDate,
      functions: [ServiceFunctions.commander],
    ));

    repository = ServiceRepository(
        endpoint: config.endpoint, appID: config.appID, test: config.test);
  }

  List<String> messagesErros = [];

  @observable
  bool loading = false;

  @observable
  UserModel? userSelect;

  @observable
  DateTime date = DateTime.now();

  @observable
  int step = 0;

  @observable
  String contact = "";

  @observable
  String? cia;

  @observable
  String? team;

  @observable
  String pb = "";

  @observable
  String obs = "";

  @observable
  OBMModel obm = OBMModel(team: [], cias: []);

  @observable
  ObservableList<String> teams = <String>[].asObservable();

  @observable
  ObservableList<ServicesComponent> components =
      <ServicesComponent>[].asObservable();

  @computed
  bool get btFinish {
    if (step < 1) return false;

    return true;
  }

  @action
  void setUserSelect(UserModel? value) => userSelect = value;

  @action
  void processStep(bool value) {
    if (value) {
      step++;
    } else {
      if (step > 0) step--;
    }
  }

  @action
  void setComponent(ServicesComponent value) {
    components.add(value.copyWith(
        period: processPeriod(start: value.startDate, end: value.endDate)));
    sortCommanders();
  }

  @action
  void deleteComponent(int index) {
    components.removeAt(index);

    sortCommanders();
  }

  @action
  void changeComponent(ServicesComponent value, int index) {
    components.removeAt(index);
    components.insert(
        index,
        value.copyWith(
            period: processPeriod(start: value.startDate, end: value.endDate)));

    sortCommanders();
  }

  @action
  void setOBM(OBMModel? value) {
    if (value != null) {
      if (obm != value) {
        teams.clear();
        team = null;
        cia = null;

        obm = value;

        teams.addAll(teamsValidade(teams: obm.team));
      }
    }
  }

  @action
  void setCia(String? value) => cia = value;

  @action
  void setTeam(String? value) => team = value;

  @action
  void setContact(String? value) => contact = value ?? '';

  @action
  void changeDate(DateTime? value) => date = value ?? date;

  @action
  Future<bool> save() async {
    try {
      loading = true;

      final service = ServiceModel(
        responsable: user,
        date: date,
        components: components,
        obm: obm.name,
        cia: cia,
        team: team,
        contact: contact,
        obmID: obm.id ?? '',
        pb: pb,
        componentsIDs: components.map((e) => e.user.id ?? '').toList(),
      );

      final response = await repository.save(service: service);
      loading = false;

      return response;
    } catch (e) {
      rethrow;
    }
  }

  List<String> teamsValidade({required List<String> teams}) {
    if (obm.team.isEmpty) return [];

    final list = servicesToday.map((e) => e.team).toList();
    final result = obm.team.where((e) => !list.contains(e)).toList();

    if (update) {
      if (init?.team != null) result.insert(0, init!.team!);
    }

    return result;
  }

  bool validationForm() {
    messagesErros.clear();
    switch (step) {
      case 0:
        if (obm.cias.isNotEmpty && cia == null) {
          messagesErros.add('Escolha a companhia antes de prosseguir.');
        }

        if (teams.isNotEmpty && team == null) {
          messagesErros.add('Escolha a guarnição antes de prosseguir.');
        }

        if (Validation.validatorPhone(contact) != null) {
          messagesErros.add("Insira um contato antes de prosseguir.");
        }

        return messagesErros.isEmpty;
      case 1:
        for (final item in components) {
          final period =
              processPeriod(start: item.startDate, end: item.endDate);

          if (period == null) {
            messagesErros.add(
                "${item.user.graduation} ${item.user.name}: Verifique o intervalo do horário do serviço.");
          }

          if (item.functions.isEmpty) {
            messagesErros.add(
                '${item.user.graduation} ${item.user.name}: Adicione a função do componente.');
          }
        }

        return messagesErros.isEmpty;
      default:
        return true;
    }
  }

  ServicePeriod? processPeriod({
    required DateTime start,
    required DateTime end,
  }) {
    if (end.isBefore(start) || end.difference(start) == const Duration()) {
      return null;
    }

    final inicioMinutos = start.hour * 60 + start.minute;

    const inicioTurnoA = 8 * 60; // 08:00
    const inicioTurnoB = 20 * 60; // 20:00

    final iniciouTurnoA =
        inicioMinutos >= inicioTurnoA && inicioMinutos < inicioTurnoB;

    // Próximo 08:00 após o início
    var proximo08 = DateTime(
      start.year,
      start.month,
      start.day,
      8,
    );

    if (!proximo08.isAfter(start)) {
      proximo08 = proximo08.add(
        const Duration(days: 1),
      );
    }

    // Se começou no período A e chegou ao próximo 08:00,
    // é A/B, mesmo que tenha entrado atrasado.
    if (iniciouTurnoA &&
        (end.isAtSameMomentAs(proximo08) || end.isAfter(proximo08))) {
      return ServicePeriod.turnaAB;
    }

    // Começou entre 08:00 e 19:59
    if (iniciouTurnoA) {
      return ServicePeriod.turnoA;
    }

    // Começou entre 20:00 e 07:59
    return ServicePeriod.turnoB;
  }

  void sortCommanders() {
    if (components.isEmpty) return;

    components.sort((a, b) {
      if (a.functions.contains(ServiceFunctions.commander)) return -1;
      if (b.functions.contains(ServiceFunctions.commander)) return 1;

      return 0;
    });

    return;
  }
}
