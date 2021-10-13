import 'package:flutter/material.dart';

class CreateButton extends StatelessWidget {
  final formKey;

  const CreateButton({Key? key, required this.formKey}) : super(key: key);

  _submitForm(BuildContext context) {
    // Validate returns true if the form is valid, or false otherwise.
    if (formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
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
