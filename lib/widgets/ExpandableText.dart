import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String text;
  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          overflow: TextOverflow.ellipsis,
          maxLines: widget.isExpanded ? 100 : 3,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              widget.isExpanded = !widget.isExpanded;
            });
          },
          child: Text(
            widget.isExpanded ? "Ler menos" : "Ler mais",
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
