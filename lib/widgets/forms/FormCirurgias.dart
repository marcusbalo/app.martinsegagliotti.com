import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

get keysCirurgias => ['procedimento', 'paciente', 'team', 'registro'];
formCirurgias() => Column(
      children: [
        FormBuilderTextField(
          keyboardType: TextInputType.text,
          attribute: 'procedimento',
          validators: [
            FormBuilderValidators.required(errorText: 'Campo obrigatório')
          ],
          decoration: InputDecoration(labelText: 'Procedimento'),
        ),
        FormBuilderTextField(
          attribute: 'paciente',
          keyboardType: TextInputType.text,
          validators: [
            FormBuilderValidators.required(errorText: 'Campo obrigatório')
          ],
          decoration: InputDecoration(labelText: 'Paciente'),
        ),
        FormBuilderTextField(
          keyboardType: TextInputType.text,
          attribute: 'registro',
          validators: [
            FormBuilderValidators.required(errorText: 'Campo obrigatório')
          ],
          decoration: InputDecoration(labelText: 'Registro'),
        )
      ],
    );

searchFuntion(list) {
  return (key, items) {
    List<int> shownIndexes = [];
    int i = 0;
    items.forEach((item) {
      matchFn(item, keyword) {
        Map<String, dynamic> team = list
            .where((Map<String, dynamic> map) => map.containsValue(item.value))
            .toList()[0];
        return (team['name'].toLowerCase().contains(keyword.toLowerCase()));
      }

      if (matchFn(item, key) || (key?.isEmpty ?? true)) {
        shownIndexes.add(i);
      }
      i++;
    });
    return (shownIndexes);
  };
}
