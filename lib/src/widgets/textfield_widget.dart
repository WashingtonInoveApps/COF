import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldText extends StatefulWidget {
  final List<TextInputFormatter>? mask;
  final TextEditingController? controller;
  final String? Function(String? text)? validation;
  final TextInputType inputType;
  final String? hint;
  final Function(String? text)? onSaved;
  final String? initValue;
  final void Function(String text)? onChange;
  final bool upper;
  final bool obscure;

  const FieldText({
    Key? key,
    this.upper = true,
    this.obscure = false,
    this.mask,
    this.onChange,
    this.controller,
    this.validation,
    this.inputType = TextInputType.text,
    this.hint,
    this.onSaved,
    this.initValue,
  }) : super(key: key);

  @override
  _FieldTextState createState() => _FieldTextState();
}

class _FieldTextState extends State<FieldText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextFormField(
            style: title,
            initialValue: widget.initValue,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                enabledBorder: InputBorder.none,
                hintText: widget.hint,
                hintStyle: subtitleHint),
            controller: widget.controller,
            inputFormatters: widget.mask ?? [],
            textAlign: TextAlign.justify,
            onChanged: widget.onChange,
            validator: widget.validation,
            maxLines: widget.obscure ? 1 : null,
            keyboardType: widget.inputType,
            obscureText: widget.obscure,
            textCapitalization: widget.upper
                ? TextCapitalization.characters
                : TextCapitalization.none,
            onSaved: widget.onSaved,
          ),
        ),
      ),
    );
  }
}
