// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldText extends StatefulWidget {
  final List<TextInputFormatter>? mask;
  final TextEditingController? controller;
  final String? Function(String? text)? validation;
  final Function()? onClear;
  final String? label;
  final TextInputType inputType;
  final String? hint;
  final Function(String? text)? onSaved;
  final String? initValue;
  final void Function(String text)? onChange;
  final double borderRadius;
  final bool obscure;
  final bool search;
  final bool upper;

  const FieldText(
      {Key? key,
      this.mask,
      this.controller,
      this.validation,
      this.label,
      this.inputType = TextInputType.text,
      this.hint,
      this.onSaved,
      this.initValue,
      this.onChange,
      this.borderRadius = 5.0,
      this.obscure = false,
      this.search = false,
      this.upper = false,
      this.onClear})
      : super(key: key);

  @override
  State createState() => _FieldTextState();
}

class _FieldTextState extends State<FieldText> {
  @override
  Widget build(BuildContext context) {
    final mask = widget.mask ?? [];
    if (widget.upper) mask.add(UpperCaseTextFormatter());

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        style: Constants.title,
        initialValue: widget.initValue,
        decoration: InputDecoration(
            prefixIcon: widget.search ? const Icon(Icons.search) : null,
            suffixIcon: (widget.onClear == null)
                ? null
                : IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: widget.onClear,
                  ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: const BorderSide(color: Colors.black)),
            hintText: widget.hint,
            label: (widget.label != null)
                ? Text(
                    widget.label!,
                  )
                : null,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: Constants.primary)),
            labelStyle: Constants.title.copyWith(color: Colors.grey),
            errorStyle: Constants.title.copyWith(color: Colors.grey),
            hintStyle: Constants.title.copyWith(color: Colors.grey)),
        controller: widget.controller,
        inputFormatters: mask,
        onChanged: widget.onChange,
        validator: widget.validation,
        maxLines: widget.obscure ? 1 : null,
        keyboardType: widget.inputType,
        obscureText: widget.obscure,
        onSaved: widget.onSaved,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
