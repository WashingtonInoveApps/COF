import 'dart:developer';

import 'package:bsu_control/app_interface.dart';
import 'package:bsu_control/app_repository.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/db.dart';
import 'package:bsu_control/enum/checklist_enum.dart';
import 'package:bsu_control/enum/state_enum.dart';
import 'package:bsu_control/model/app_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/config_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:mobx/mobx.dart';

import 'model/checklist_model.dart';
import 'model/notification_model.dart';

part 'app_controller.g.dart';

// ignore: library_private_types_in_public_api
class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase with Store {
  final ConfigModel config;
  // final double maxWidth;

  late IAppRepository repository;

  _AppControllerBase({required this.config}) {
    repository = AppRepository(
      appID: config.appID,
      endpoint: config.endpoint,
      test: config.test,
    );

    processWidth(constrainedMaxWidth: double.infinity, childRight: false);
    getUserDB(tag: 'user');
  }

  AppModel appModel = AppModel(carsTypes: []);

  double get maxWidth => config.maxWidth;

  @observable
  int version = 1;

  @observable
  double width = 0.0;

  @observable
  int router = 0;

  @observable
  UserModel user = UserModel();

  @observable
  bool menuOpen = false;

  @observable
  bool loading = false;

  @observable
  bool modeMOBILE = false;

  @observable
  ChecklistModel? checklistUserVehicular;

  @observable
  ChecklistModel? checklistUserMaterial;

  @observable
  List<CarModel> cars = <CarModel>[].asObservable();

  @observable
  List<ChecklistModel> checklistsOperationDay =
      <ChecklistModel>[].asObservable();

  @observable
  List<NotificationModel> notifications = <NotificationModel>[].asObservable();

  @observable
  List<UserModel> users = <UserModel>[].asObservable();

  List<OBMModel> obms = <OBMModel>[];

  Stream<List<CarModel>> get listenCar => repository.listenCar();

  Stream<List<UserModel>> get listenUsers => repository.listenUsers();

  @computed
  List<String> get carsTypes {
    if (cars.isEmpty) return ['Outros'];

    List<String> types = [];

    for (final car in cars) {
      if (!types.contains(car.type)) types.add(car.type);
    }

    types.sort((a, b) => a.compareTo(b));
    return types..add('Outros');
  }

  @computed
  bool get newRegisterVehicular {
    if (checklistUserVehicular == null) return true;

    if (!(checklistUserVehicular?.enable ?? false)) return true;

    return false;
  }

  @computed
  bool get newRegisterMaterial {
    if (checklistUserMaterial == null) return true;

    if (!(checklistUserMaterial?.enable ?? false)) return true;

    return false;
  }

  @computed
  List<CarModel> get carsUsers {
    if (user.managerOperational || user.admin) {
      return List<CarModel>.from(cars);
    } else {
      return List<CarModel>.from(
          cars.where((e) => e.obmID == user.obmID).toList());
    }
  }

  @action
  Future<void> setUser(UserModel value) async {
    user = value;

    checklistUserMaterial = null;
    checklistUserVehicular = null;

    final result = await repository.getChecklistUser(userID: value.id!);

    processChecklist(
      list: result,
      userID: value.id!,
    );
  }

  @action
  void processChecklist({
    required List<ChecklistModel> list,
    required String userID,
  }) {
    final result = list
        .where(
          (e) => e.userID == userID,
        )
        .toList();

    final material = result.cast<ChecklistModel?>().firstWhere(
          (e) => e?.type == ChecklistType.materials,
          orElse: () => null,
        );

    final vehicular = result.cast<ChecklistModel?>().firstWhere(
          (e) => e?.type == ChecklistType.vehicular,
          orElse: () => null,
        );

    if (material != null) {
      if (_isNotActive(material)) return;

      checklistUserMaterial = material;
    }

    if (vehicular != null) {
      if (_isNotActive(vehicular)) return;

      checklistUserVehicular = vehicular;
    }
  }

  bool _isNotActive(ChecklistModel value) {
    if (!value.enable) return true;

    if (DateTime.now().isAfter(
      DateTime(
        value.date.year,
        value.date.month,
        value.date.day,
      ).add(const Duration(days: 2)),
    )) {
      if (value.state != StateProgress.reactivated) {
        return true;
      }
    }

    return false;
  }

  @action
  void changeMenuOpen() => menuOpen = !menuOpen;

  @action
  void clearChecklistUser(ChecklistModel value) {
    if (checklistUserVehicular?.id == value.id) {
      checklistUserVehicular = null;
      return;
    }

    if (checklistUserMaterial?.id == value.id) {
      checklistUserMaterial = null;
      return;
    }

    return;
  }

  @action
  void setRouter(int value) {
    router = value;
    menuOpen = false;
  }

  Stream<List<ChecklistModel>> listenChecklistOperationDay() {
    final dateReference = Core.getOperationalDay(DateTime.now());

    log('Data Operacional: ${Core.formatDate(dateReference)}');

    return repository.listenChecklistOperationDay(referenceDate: dateReference);
  }

  @action
  void setCars(List<CarModel> value) {
    notifications.clear();

    for (final car in value) {
      if (car.km > car.oil && car.oil > 0) {
        notifications.add(NotificationModel(
          description:
              'Verifique o oléo do veículo ${car.prefix}, já está na hora de realizar a troca.',
        ));
      }

      if (car.oil <= 0) {
        notifications.add(NotificationModel(
          description:
              'Adicione a KM da próxima troca de oléo do veículo: ${car.prefix}',
        ));
      }
    }

    cars
      ..clear()
      ..addAll(value);
  }

  @action
  void setUsers(List<UserModel> value) {
    users
      ..clear()
      ..addAll(value);

    users.sort((a, b) => a.name.compareTo(b.name));
  }

  @action
  void setChecklistsOperationDay(List<ChecklistModel> value) {
    value.sort((a, b) => a.date.compareTo(b.date));

    checklistsOperationDay
      ..clear()
      ..addAll(value);

    if (user.id != null) {
      processChecklist(list: checklistsOperationDay, userID: user.id!);
    }
  }

  Future<void> getOBMs() async {
    final result = await repository.getOBMs();

    result.sort((a, b) => a.prefix.compareTo(b.prefix));

    for (final obm in result) {
      if (obm.cias.isNotEmpty) {
        {
          obm.cias.sort((a, b) => a.name.compareTo(b.name));
        }
      }
      if (obm.team.isNotEmpty) {
        obm.team.sort((a, b) => a.name.compareTo(b.name));
      }
    }

    obms
      ..clear()
      ..addAll(result);

    return;
  }

  Future<bool> getUserDB({required String tag}) async {
    final result = await DBController.get(tag: tag);
    if (result != null) user = UserModel.fromMap(result);

    return result != null;
  }

  @action
  double processWidth(
      {required double constrainedMaxWidth, required bool childRight}) {
    final maxWidth = config.maxWidth;

    bool modeMOBILE = (constrainedMaxWidth > maxWidth)
        ? (maxWidth <= 500)
        : (constrainedMaxWidth <= 500);

    double width = (modeMOBILE || childRight)
        ? ((constrainedMaxWidth > maxWidth) ? maxWidth : constrainedMaxWidth)
        : maxWidth * 0.47;

    this.modeMOBILE = modeMOBILE;
    this.width = width;

    log('Modo MOBILE: $modeMOBILE');
    log('Width: $width , Max Width: $maxWidth');

    return width;
  }

  @action
  Future<void> initApplication() async {
    final result = await repository.getAppModel();
    await getOBMs();

    log('OBMs: ${obms.length}');

    version = result.version;
  }
}
