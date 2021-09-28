import 'package:flutter/material.dart';

import '../../services/services.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    Key? key,
  }) : super(key: key);

  _categoryList(BuildContext context, List<Category> categories) {
    return categories
        .map(
          (category) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: EventIcon(
              eventType: category.id,
              color: Theme.of(context).primaryColor,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Collection<Category>(path: '/categories').streamData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: GridView.count(
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: _categoryList(context, snapshot.data),
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
