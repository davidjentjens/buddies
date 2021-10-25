import 'package:buddies/services/Database/DatabaseService.dart';
import 'package:buddies/widgets/Loader.dart';
import 'package:flutter/material.dart';

import '../Category.dart';
import '../../services/Database/Collection.dart';
import '../../models/Category.dart';

class CategoryGrid extends StatelessWidget {
  final bool popularCategoriesOnly;

  const CategoryGrid({Key? key, required this.popularCategoriesOnly})
      : super(key: key);

  _categoryList(BuildContext context, List<Category> categories) {
    return categories
        .map(
          (category) => ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Card(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CategoryScreen(category: category),
                    ),
                  );
                },
                child: Stack(fit: StackFit.expand, children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.grey,
                      BlendMode.darken,
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).secondaryHeaderColor,
                        BlendMode.colorBurn,
                      ),
                      child: Image(
                        image: NetworkImage(category.mainImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      category.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: popularCategoriesOnly
          ? DatabaseService().streamMostPopularCategories(categoryNum: 4)
          : Collection<Category>(path: '/categories').streamData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisSpacing: 16,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: _categoryList(context, snapshot.data),
              ),
            ),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
