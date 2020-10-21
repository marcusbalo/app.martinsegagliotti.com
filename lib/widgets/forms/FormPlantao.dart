import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

get keysPlantao => ['plantonista', 'observacoes', 'periodo', 'hora'];
formPlantao(BuildContext context, Function(dynamic) fnTime,
        TextEditingController timerController) =>
    Column(
      children: [
        periodoSlector((_) {}),
        FormBuilderTextField(
          keyboardType: TextInputType.datetime,
          attribute: 'hora',
          validators: [
            FormBuilderValidators.required(errorText: 'Campo obrigatório')
          ],
          controller: timerController,
          readOnly: false,
          onTap: () async {
            TimeOfDay time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              cancelText: 'CANCELAR',
              helpText: '',
              builder: (BuildContext context, Widget child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child,
                );
              },
            );
            String formatedDate =
                (time != null) ? '${time.hour}:${time.minute}' : '';
            if (formatedDate.isNotEmpty) {
              fnTime(formatedDate);
            }
          },
          decoration: InputDecoration(labelText: 'Hora'),
        ),
        plantonistaSlector((_) {}),
        FormBuilderTextField(
          keyboardType: TextInputType.text,
          attribute: 'observacoes',
          decoration: InputDecoration(labelText: 'Observações'),
        ),
      ],
    );

Widget periodoSlector(Function fn) {
  return FormBuilderDropdown(
    attribute: "periodo",
    validators: [
      FormBuilderValidators.required(errorText: 'Campo obrigatório')
    ],
    decoration: InputDecoration(labelText: "Período"),
    onChanged: fn,
    items: [
      {'tipo': 'Diurno', 'value': 'diurno'},
      {'tipo': 'Noturno', 'value': 'noturno'},
    ]
        .map(
          (entries) => DropdownMenuItem(
            value: entries['value'],
            child: Text("${entries['tipo']}"),
          ),
        )
        .toList(),
  );
}

Widget plantonistaSlector(Function fn) {
  return FormBuilderDropdown(
    attribute: "plantonista",
    decoration: InputDecoration(labelText: "Plantonista"),
    onChanged: fn,
    items: [
      {'tipo': 'Visita', 'value': 'visita'},
      {'tipo': 'P.A Tarde', 'value': 'p.a_tarde'},
    ]
        .map(
          (entries) => DropdownMenuItem(
            value: entries['value'],
            child: Text("${entries['tipo']}"),
          ),
        )
        .toList(),
  );
}
