import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String text;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          overflow: TextOverflow.ellipsis,
          maxLines: isExpanded ? 100 : 3,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? "Ler menos" : "Ler mais",
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(0),
            textStyle: TextStyle(fontWeight: FontWeight.normal, height: 1),
          ),
        ),
      ],
    );
  }
}
