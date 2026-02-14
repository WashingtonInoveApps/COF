import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/validation.dart';
import '../../model/car_mapa_model.dart';
import '../../model/user_model.dart';
import 'textfield_widget.dart';

class CarMapaWidget extends StatefulWidget {
  final UserModel user;
  final String carId;
  final Function(CarMapaModel mapa) onInsert;
  const CarMapaWidget(
      {Key? key,
      required this.user,
      required this.onInsert,
      required this.carId})
      : super(key: key);

  @override
  State<CarMapaWidget> createState() => _CarMapaWidgetState();
}

class _CarMapaWidgetState extends State<CarMapaWidget> {
  final _key = GlobalKey<FormState>();

  late CarMapaModel mapa;

  @override
  void initState() {
    super.initState();
    mapa = CarMapaModel(
        date: DateTime.now(), user: widget.user, carId: widget.carId);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(6),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FieldText(
              hint: "ORIGEM",
              validation: Validation.validatorPreenchimento,
              onSaved: (value) {
                mapa.origin = value!;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            FieldText(
              hint: "DESTINO",
              validation: Validation.validatorPreenchimento,
              onSaved: (value) {
                mapa.destiny = value!;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            FieldText(
              hint: "KM INICIAL",
              validation: Validation.validatorNumber,
              inputType: TextInputType.number,
              onSaved: (value) {
                mapa.kmStart = value!;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            FieldText(
              hint: "KM FINAL",
              validation: Validation.validatorNumber,
              inputType: TextInputType.number,
              onSaved: (value) {
                mapa.kmFinal = value!;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
                height: 50.0,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        _key.currentState!.save();

                        Navigator.of(context).pop();
                        widget.onInsert(mapa);
                      }
                    },
                    child: Text("Inserir", style: Constants.titleButton)))
          ],
        ),
      ),
    );
  }
}
