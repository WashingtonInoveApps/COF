import 'dart:io';

import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:validators/validators.dart' as validator;

class Validation {
  static String? validatorPreenchimento(String? text) {
    if (validator.isNull(text)) return "Preencha o campo obrigatório.";

    return null;
  }

  static String? validatorPrice(String? text) {
    if (text != null && text.isNotEmpty) {
      if (!validator.isFloat(text)) return "Insira um preço válido.";

      return null;
    } else {
      return "Insira um preço válido.";
    }
  }

  static String? validatorListImage(List? image) {
    if (image == null || image.isEmpty) return "Insira uma imagem.";

    return null;
  }

  static String? validatorImage(File? file) {
    if (file == null) return "Selecione uma imagem para seu produto.";

    return null;
  }

  static String? validatorNumber(String? text) {
    if (text != null) {
      if (!validator.isInt(text)) return "Insira um número válido.";
    }

    return null;
  }

  static String? validatorCPF(String? text) {
    if (!CPFValidator.isValid(text)) return "Insira um CPF válido.";

    return null;
  }

  static String? validatorEmail(String? text) {
    if (text != null) if (!validator.isEmail(text)) return "Insira um email válido.";

    return null;
  }

  static String? validatorPhone(String? text) {
    if (text == null) return "";

    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(patttern);

    if (!regExp.hasMatch(text.replaceAll(RegExp(r'[^0-9]'), "")) || text.replaceAll(RegExp(r'[^0-9]'), "").length < 11) {
      return "Insira um número válido.";
    }

    return null;
  }

  static String? validatorPassoword(String? password) {
    if (password != null) {
      if (password.length < 6 || password.isEmpty) return "Insira uma senha maior que 5 caracteres";
    }
    return null;
  }

  static String? validatorConfirmePassoword(String? password1, String? password2) {
    if (password1 != null && password2 != null) {
      if (password1 != password2) return "Senhas não correspondem";

      if (password2.isEmpty) return "Preencha o campo obrigatório.";
    }

    return null;
  }
}
