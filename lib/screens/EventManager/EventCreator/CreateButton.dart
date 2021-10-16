import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';

class CreateButton extends StatelessWidget {
  final formKey;
  final DateTime selectedInitialDate;
  final DateTime selectedFinalDate;
  final LocationResult? selectedLocation;

  const CreateButton(
      {Key? key,
      required this.formKey,
      required this.selectedInitialDate,
      required this.selectedFinalDate,
      required this.selectedLocation})
      : super(key: key);

  _submitForm(BuildContext context) {
    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: Text(
          'Erro: Selecione o lugar onde ocorrerá o evento.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red[300],
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height / 8,
            right: 40,
            left: 40),
      ));
    }

    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Criando Evento...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: TextButton(
        child: Text(
          'Criar Evento',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () => _submitForm(context),
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero)),
            primary: Colors.white,
            backgroundColor: Theme.of(context).primaryColor),
      ),
    );
    ;
  }
}
