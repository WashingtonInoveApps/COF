// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bsu_control/core/constants.dart';

enum FieldTextCase {
  normal,
  upper,
  lower,
}

class FieldText extends StatelessWidget {
  final List<TextInputFormatter>? mask;
  final TextEditingController? controller;
  final String? Function(String? text)? validation;
  final VoidCallback? onClear;
  final String? label;
  final TextInputType inputType;
  final String? hint;
  final void Function(String? text)? onSaved;
  final String? initValue;
  final void Function(String text)? onChange;

  final double borderRadius;
  final bool obscure;
  final bool search;

  /// Define a capitalização/formatação do texto.
  ///
  /// [FieldTextCase.normal] mantém o texto original.
  /// [FieldTextCase.upper] transforma em maiúsculo.
  /// [FieldTextCase.lower] transforma em minúsculo.
  final FieldTextCase textCase;

  /// Define se o campo poderá possuir múltiplas linhas.
  final int? maxLines;

  const FieldText({
    Key? key,
    this.mask,
    this.controller,
    this.validation,
    this.onClear,
    this.label,
    this.inputType = TextInputType.text,
    this.hint,
    this.onSaved,
    this.initValue,
    this.onChange,
    this.borderRadius = 5.0,
    this.obscure = false,
    this.search = false,
    this.textCase = FieldTextCase.normal,
    this.maxLines = 1,
  }) : super(key: key);

  List<TextInputFormatter> _getFormatters() {
    final formatters = List<TextInputFormatter>.from(mask ?? []);

    switch (textCase) {
      case FieldTextCase.upper:
        formatters.add(UpperCaseTextFormatter());
        break;

      case FieldTextCase.lower:
        formatters.add(LowerCaseTextFormatter());
        break;

      case FieldTextCase.normal:
        break;
    }

    return formatters;
  }

  TextCapitalization _getTextCapitalization() {
    switch (textCase) {
      case FieldTextCase.upper:
      case FieldTextCase.lower:
        return TextCapitalization.none;

      case FieldTextCase.normal:
        return TextCapitalization.sentences;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatters = _getFormatters();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextFormField(
        controller: controller,
        // TextFormField não permite controller + initialValue
        initialValue: controller == null ? initValue : null,
        style: Constants.title,
        decoration: InputDecoration(
          prefixIcon: search ? const Icon(Icons.search) : null,
          suffixIcon: onClear == null
              ? null
              : IconButton(
                  tooltip: 'Limpar',
                  onPressed: onClear,
                  icon: const Icon(
                    Icons.clear,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: Constants.primary,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          hintText: hint,
          label: label == null ? null : Text(label!),
          labelStyle: Constants.title.copyWith(
            color: Colors.grey,
          ),
          errorStyle: Constants.title.copyWith(
            color: Colors.grey,
          ),
          hintStyle: Constants.title.copyWith(
            color: Colors.grey,
          ),
        ),
        inputFormatters: formatters,
        onChanged: onChange,
        validator: validation,
        keyboardType: inputType,
        obscureText: obscure,
        maxLines: obscure ? 1 : maxLines,
        textCapitalization: _getTextCapitalization(),
        onSaved: onSaved,
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// UPPER CASE
/// ---------------------------------------------------------------------------

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
      composing: newValue.composing,
    );
  }
}

/// ---------------------------------------------------------------------------
/// LOWER CASE
/// ---------------------------------------------------------------------------

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
      composing: newValue.composing,
    );
  }
}

// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:bsu_control/core/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class FieldText extends StatefulWidget {
//   final List<TextInputFormatter>? mask;
//   final TextEditingController? controller;
//   final String? Function(String? text)? validation;
//   final Function()? onClear;
//   final String? label;
//   final TextInputType inputType;
//   final String? hint;
//   final Function(String? text)? onSaved;
//   final String? initValue;
//   final void Function(String text)? onChange;
//   final double borderRadius;
//   final bool obscure;
//   final bool search;
//   final bool upper;
//   final bool low;

//   const FieldText(
//       {Key? key,
//       this.mask,
//       this.controller,
//       this.validation,
//       this.label,
//       this.inputType = TextInputType.text,
//       this.hint,
//       this.onSaved,
//       this.initValue,
//       this.onChange,
//       this.borderRadius = 5.0,
//       this.obscure = false,
//       this.search = false,
//       this.upper = false,
//       this.low = false,
//       this.onClear})
//       : super(key: key);

//   @override
//   State createState() => _FieldTextState();
// }

// class _FieldTextState extends State<FieldText> {
//   @override
//   Widget build(BuildContext context) {
//     final mask = widget.mask ?? [];
//     if (widget.upper) mask.add(UpperCaseTextFormatter());

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: TextFormField(
//         style: Constants.title,
//         initialValue: widget.initValue,
//         decoration: InputDecoration(
//             prefixIcon: widget.search ? const Icon(Icons.search) : null,
//             suffixIcon: (widget.onClear == null)
//                 ? null
//                 : IconButton(
//                     icon: const Icon(
//                       Icons.refresh,
//                       size: 20,
//                       color: Colors.grey,
//                     ),
//                     onPressed: widget.onClear,
//                   ),
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(widget.borderRadius),
//                 borderSide: const BorderSide(color: Colors.grey)),
//             hintText: widget.hint,
//             label: (widget.label != null)
//                 ? Text(
//                     widget.label!,
//                   )
//                 : null,
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(widget.borderRadius),
//                 borderSide: const BorderSide(color: Constants.primary)),
//             labelStyle: Constants.title.copyWith(color: Colors.grey),
//             errorStyle: Constants.title.copyWith(color: Colors.grey),
//             hintStyle: Constants.title.copyWith(color: Colors.grey)),
//         controller: widget.controller,
//         inputFormatters: mask,
//         onChanged: widget.onChange,
//         validator: widget.validation,
//         maxLines: widget.obscure ? 1 : null,
//         keyboardType: widget.inputType,
//         obscureText: widget.obscure,
//         onSaved: widget.onSaved,
//         textCapitalization:
//             widget.low ? TextCapitalization.none : TextCapitalization.sentences,
//       ),
//     );
//   }
// }

// class UpperCaseTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     return newValue.copyWith(
//       text: newValue.text.toUpperCase(),
//       selection: newValue.selection,
//     );
//   }
// }
