import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:place_picker/entities/entities.dart';

import '../../../models/Category.dart';

import 'EventEditor.dart';

class EventFields extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  final Category? selectedCategory;
  final Function selectCategory;

  final DateTime selectedInitialDate;
  final DateTime selectedFinalDate;
  final Function selectDate;

  final LocationResult? selectedLocation;
  final Function selectLocation;

  EventFields(
    this.titleController,
    this.descriptionController,
    this.selectedCategory,
    this.selectCategory,
    this.selectedInitialDate,
    this.selectedFinalDate,
    this.selectDate,
    this.selectedLocation,
    this.selectLocation,
  ) : super();

  @override
  _EventFieldsState createState() => _EventFieldsState();
}

class _EventFieldsState extends State<EventFields> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: new ListTile(
              leading: const Icon(Icons.title),
              title: new TextFormField(
                controller: this.widget.titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor informe um título para o Evento";
                  }
                  if (value.length < 5) {
                    return "O título precisa ter pelo menos 5 caracteres";
                  }
                  if (value.length > 24) {
                    return "O título não pode ter mais do que 24 caracteres";
                  }
                  return null;
                },
                decoration: new InputDecoration(
                  hintText: "Título do Evento",
                ),
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.description),
            title: new TextFormField(
              controller: this.widget.descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "A descrição do Evento não pode estar vazia";
                }
                if (value.length < 10) {
                  return "A descrição precisa ter pelo menos 10 caracteres";
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: new InputDecoration(
                hintText: "Descrição do Evento",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.bookmarks),
            title: const Text('Categoria'),
            subtitle: Text(
              this.widget.selectedCategory != null
                  ? this.widget.selectedCategory!.title
                  : "Selecione uma Categoria",
            ),
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              await this.widget.selectCategory(context);
            },
          ),
          new ListTile(
            leading: const Icon(Icons.today),
            title: const Text('Dia e horário de início'),
            subtitle: Text(
              DateFormat.MMMMd('pt_BR')
                  .add_jm()
                  .format(this.widget.selectedInitialDate),
            ),
            onTap: () async => {
              FocusManager.instance.primaryFocus?.unfocus(),
              await this.widget.selectDate(context, DateType.start)
            },
          ),
          new ListTile(
            leading: const Icon(Icons.today),
            title: const Text('Dia e horário de término'),
            subtitle: Text(
              DateFormat.MMMMd('pt_BR')
                  .add_jm()
                  .format(this.widget.selectedFinalDate),
            ),
            onTap: () async => {
              FocusManager.instance.primaryFocus?.unfocus(),
              await this.widget.selectDate(context, DateType.end)
            },
          ),
          new ListTile(
            leading: const Icon(Icons.near_me_outlined),
            title: const Text('Localização'),
            subtitle: Text(this.widget.selectedLocation != null
                ? this.widget.selectedLocation!.formattedAddress ?? ""
                : "Selecione uma Localização"),
            onTap: () async => {
              FocusManager.instance.primaryFocus?.unfocus(),
              await this.widget.selectLocation(context)
            },
          ),
        ],
      ),
    );
  }
}
