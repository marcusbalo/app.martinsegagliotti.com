import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

get keysAmbulatorio => [
      'atendimentos',
      'reavaliacoes',
      'interconsultas',
      'pequenasCirurgias',
      'urodinamica',
      'biopsiaDeProstata',
      'avaliacaoNoturnaCipe',
      'visitas',
      'doppler',
      'paciente',
      'registro'
    ];
formAmbulatorio() => Column(
      children: [
        FormBuilderTextField(
          attribute: 'atendimentos',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Atendimentos'),
        ),
        Row(
          children: [
            Flexible(
              child: FormBuilderTextField(
                keyboardType: TextInputType.number,
                attribute: 'reavaliacoes',
                decoration: InputDecoration(labelText: 'Reavaliações'),
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: FormBuilderTextField(
                keyboardType: TextInputType.number,
                attribute: 'interconsultas',
                decoration: InputDecoration(labelText: 'Interconsultas'),
              ),
            ),
          ],
        ),
        FormBuilderTextField(
          keyboardType: TextInputType.number,
          attribute: 'pequenasCirurgias',
          decoration: InputDecoration(labelText: 'Pequenas Cirurgias'),
        ),
        FormBuilderTextField(
          keyboardType: TextInputType.number,
          attribute: 'urodinamica',
          decoration: InputDecoration(labelText: 'Urodinâmica'),
        ),
        FormBuilderTextField(
          keyboardType: TextInputType.number,
          attribute: 'biopsiaDeProstata',
          decoration: InputDecoration(labelText: 'Biopsia de próstata'),
        ),
        FormBuilderTextField(
          keyboardType: TextInputType.number,
          attribute: 'avaliacaoNoturnaCipe',
          decoration: InputDecoration(labelText: 'Avalição Noturna CIPE'),
        ),
        Row(
          children: [
            Flexible(
              child: FormBuilderTextField(
                keyboardType: TextInputType.number,
                attribute: 'visitas',
                decoration: InputDecoration(labelText: 'Visitas'),
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: FormBuilderTextField(
                keyboardType: TextInputType.number,
                attribute: 'doppler',
                decoration: InputDecoration(labelText: 'Doppler'),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: FormBuilderTextField(
                keyboardType: TextInputType.text,
                attribute: 'paciente',
                decoration: InputDecoration(labelText: 'Paciente'),
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: FormBuilderTextField(
                keyboardType: TextInputType.text,
                attribute: 'registro',
                decoration: InputDecoration(labelText: 'Registro'),
              ),
            ),
          ],
        )
      ],
    );
