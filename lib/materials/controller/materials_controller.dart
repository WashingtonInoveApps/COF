import 'package:mobx/mobx.dart';
part 'materials_controller.g.dart';

class MaterialsController = _MaterialsControllerBase with _$MaterialsController;

abstract class _MaterialsControllerBase with Store {
  @observable
  bool loading = false;

  @observable
  int limit = 10;

  @observable
  int page = 1;

  @action
  setLimit(int? value) {
    limit = value ?? limit;
    page = 1;
  }

  @action
  setPage(int value) => page = value;
}
