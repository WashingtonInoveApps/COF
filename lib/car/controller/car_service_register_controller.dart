import 'package:mobx/mobx.dart';

import '../../enum/car_enum.dart';
import '../../model/car_model.dart';
import '../../model/car_service_model.dart';
import '../../model/file_model.dart';
import '../../model/user_model.dart';
part 'car_service_register_controller.g.dart';

class CarServiceRegisterController = _CarServiceRegisterControllerBase
    with _$CarServiceRegisterController;

abstract class _CarServiceRegisterControllerBase with Store {
  final CarServiceModel? init;
  final UserModel user;
  final List<CarModel> cars;

  List<String> messagesError = [];

  @observable
  bool loading = false;

  @observable
  DateTime date = DateTime.now();

  @observable
  DateTime? expireted;

  @observable
  ObservableList<FileModel> images = <FileModel>[].asObservable();

  @observable
  CarModel? car;

  @observable
  String? description;

  @observable
  String? obs;

  @observable
  String? local;

  @observable
  StateCarProblems? problem;

  _CarServiceRegisterControllerBase(
      {required this.init, required this.user, required this.cars}) {
    initialization();
  }

  @computed
  CarServiceModel get service {
    return CarServiceModel(
      date: date,
      car: car,
      description: description ?? '',
      local: local ?? '',
      problem: problem ?? StateCarProblems.others,
      user: user,
      expired: expireted,
      obmID: car?.obmID ?? '',
      images: images,
      obs: obs ?? '',
    );
  }

  @action
  void initialization() {
    date = init?.date ?? date;

    car = cars
        .cast<CarModel?>()
        .firstWhere((e) => e?.id == init?.car?.id, orElse: () => null);

    description = init?.description ?? '';
    local = init?.local ?? '';
    problem = init?.problem;
    expireted = init?.expired;
    obs = init?.obs;

    images
      ..clear()
      ..addAll(init?.images ?? []);
  }

  @action
  void changeDate(DateTime? value) {
    date = value ?? date;
  }

  @action
  void changeExpireted(DateTime? value) {
    expireted = value;
  }

  @action
  void addImage(FileModel value) {
    images.add(value);
  }

  @action
  void removeImage(int index) {
    images.removeAt(index);
  }

  @action
  void setCar(CarModel? value) {
    car = value;
  }

  @action
  void setProblem(StateCarProblems? value) {
    problem = value;
  }

  @action
  void changeDescription(String? value) {
    description = value;
  }

  @action
  void changeLocal(String? value) {
    local = value;
  }

  @action
  void changeOBS(String? value) {
    obs = value;
  }

  List<String> validationForm() {
    List<String> messages = [];

    if (car == null) {
      messages.add('Selecione o veículo.');
    }

    if (problem == null) {
      messages.add('Selecione o motivo do serviço.');
    }

    if (description?.isEmpty ?? true) {
      messages.add('Digite a descrição do motivo.');
    }

    if (local?.isEmpty ?? true) {
      messages.add('Digite o local que se encontra o veículo.');
    }

    return messages;
  }
}
