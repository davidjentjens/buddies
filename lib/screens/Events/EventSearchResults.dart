import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';

import '../EventDetails/EventDetails.dart';
import '../../widgets/EventIcon.dart';

class EventSearchResults extends StatelessWidget {
  final List<AlgoliaObjectSnapshot> searchResult;

  const EventSearchResults({Key? key, required this.searchResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
          bottom: 22,
          top: 14,
        ),
        children: searchResult
            .map((result) => Column(
                  children: [
                    ListTile(
                      leading: EventIcon(
                        eventType: result.toMap()["category"],
                      ),
                      title: Text(result.toMap()["title"]),
                      subtitle: Text(
                        result.toMap()["description"],
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                EventDetailScreen(
                                    eventId: result.toMap()["objectID"]),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16)
                  ],
                ))
            .toList());
  }
}
