import 'package:buddies/widgets/Loader.dart';
import 'package:flutter/material.dart';

import '../../../services/Database/Collection.dart';
import '../../../models/Category.dart';

class SelectCategory extends StatelessWidget {
  const SelectCategory({Key? key}) : super(key: key);

  _categoryList(BuildContext context, List<Category> categories) {
    return categories
        .map(
          (category) => Padding(
            padding: EdgeInsets.only(top: 16, left: 25, right: 25, bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: InkWell(
                onTap: () => {Navigator.pop(context, category)},
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).secondaryHeaderColor,
                        BlendMode.colorBurn,
                      ),
                      child: Image(
                        image: NetworkImage((category.images..shuffle()).first),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Text(
                        category.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Selecione uma categoria",
            style: Theme.of(context).textTheme.headline6),
      ),
      body: StreamBuilder(
        stream: Collection<Category>(path: '/categories').streamData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView(
              itemExtent: 200,
              children: _categoryList(context, snapshot.data),
            );
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }
}
