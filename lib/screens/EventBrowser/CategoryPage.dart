import 'package:flutter/material.dart';

import '../../widgets/AvatarButton.dart';
import 'CategoryGrid.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Categorias de Eventos"),
        actions: [AvatarButton()],
      ),
      body: ListView(children: [
        SizedBox(height: 25),
        CategoryGrid(popularCategoriesOnly: false),
        SizedBox(height: 25)
      ]),
    );
  }
}
