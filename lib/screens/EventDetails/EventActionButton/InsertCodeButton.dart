import 'package:flutter/material.dart';

class InsertCodeButton extends StatelessWidget {
  const InsertCodeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: TextButton(
        child: Text(
          'Inserir código de participação',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () => {},
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero),
          ),
          primary: Colors.white,
          backgroundColor: Colors.grey[500],
        ),
      ),
    );
  }
}
