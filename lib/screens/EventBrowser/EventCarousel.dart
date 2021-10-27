import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../models/Event.dart';
import '../../widgets/EventCard.dart';

class EventCarousel extends StatefulWidget {
  final List<Event> events;

  const EventCarousel({Key? key, required this.events}) : super(key: key);

  @override
  _EventCarouselState createState() => _EventCarouselState();
}

class _EventCarouselState extends State<EventCarousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(top: 20, right: 18, left: 18, bottom: 5),
        child: Row(
          children: [
            Icon(Icons.pin_drop, color: Theme.of(context).primaryColor),
            SizedBox(width: 5),
            Text(
              "Eventos próximos de você",
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
      ),
      CarouselSlider(
        items: this.widget.events.map<Widget>((Event event) {
          return EventCard(event: event);
        }).toList(),
        carouselController: _controller,
        options: CarouselOptions(
          autoPlay: true,
          height: 320.0,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: this.widget.events.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 12.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).secondaryHeaderColor)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
