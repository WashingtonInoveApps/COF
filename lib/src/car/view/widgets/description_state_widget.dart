import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/enum.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';

class DescriptionStateWidget extends StatefulWidget {
  final Function(CarStatusModel) onInsert;
  final UserModel user;
  const DescriptionStateWidget(
      {Key? key, required this.onInsert, required this.user})
      : super(key: key);

  @override
  State createState() => _DescriptionStateWidgetState();
}

class _DescriptionStateWidgetState extends State<DescriptionStateWidget> {
  StateCarProblems state = StateCarProblems.others;

  final _controllerDesc = TextEditingController();
  // final _controllerLocal = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    _controllerDesc.dispose();
    // _controllerLocal.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(10),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<StateCarProblems>(
                    value: state,
                    onChanged: (value) {
                      setState(() {
                        state = value ?? state;
                      });
                    },
                    underline: Container(),
                    isExpanded: true,
                    items:
                        List.generate(StateCarProblems.values.length, (index) {
                      return DropdownMenuItem<StateCarProblems>(
                        value: StateCarProblems.values[index],
                        child: Text(
                          StateCarProblems.values[index].label,
                          style: Constants.title,
                        ),
                      );
                    })),
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 50,
                child: FieldText(
                  controller: _controllerDesc,
                  label: 'Descrição',
                  hint: "Ex: Vazamento de aguá pelo radiador",
                  validation: Validation.validatorPreenchimento,
                ),
              ),
              // FieldText(
              //   controller: _controllerLocal,
              //   label: 'Onde se encontra',
              //   hint: "Ex: Oficina fulano",
              //   validation: Validation.validatorPreenchimento,
              // ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                  height: 50.0,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          Navigator.of(context).pop();
                          widget.onInsert(CarStatusModel(
                              date: DateTime.now(),
                              user: widget.user,
                              type: state,
                              description: _controllerDesc.text,
                              local: '', //_controllerLocal.text,
                              value: false));
                        }
                      },
                      child: Text("INSERIR", style: Constants.titleButton)))
            ],
          ),
        ),
      ),
    );
  }
}
