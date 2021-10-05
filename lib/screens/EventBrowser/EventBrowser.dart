import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:algolia/algolia.dart';
import 'package:buddies/widgets/Loader.dart';
import 'package:flutter/material.dart';

import '../../widgets/AvatarButton.dart';
import 'EventSearchResults.dart';
import 'EventCatalog.dart';

class EventBrowserScreen extends StatefulWidget {
  const EventBrowserScreen({Key? key}) : super(key: key);

  @override
  _EventBrowserScreenState createState() => _EventBrowserScreenState();
}

class _EventBrowserScreenState extends State<EventBrowserScreen> {
  final Algolia _algolia = Algolia.init(
    applicationId: dotenv.env['ALGOLIA_APPLICATION_ID'] ?? "",
    apiKey: dotenv.env['ALGOLIA_API_SEARCH_KEY'] ?? "",
  );

  Widget _appBarTitle = Text("Pesquisar Eventos");
  Icon _searchIcon = Icon(Icons.search);

  bool _searching = false;
  List<AlgoliaObjectSnapshot> _searchResults = [];

  Timer? searchOnStoppedTyping;

  void _search(String searchTerm) async {
    setState(() {
      _searching = true;
    });

    AlgoliaQuery query = _algolia.instance.index('buddies_eventsearch');
    query = query.query(searchTerm);

    _searchResults = (await query.getObjects()).hits;

    setState(() {
      _searching = false;
    });
  }

  void _onChangeHandler(String value) {
    if (value.isEmpty) {
      print("Empty search");
      return;
    }

    const duration = Duration(milliseconds: 500);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping?.cancel());
    }
    setState(() =>
        searchOnStoppedTyping = new Timer(duration, () => _search(value)));
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          onChanged: _onChangeHandler,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: 'Busque por um evento...',
          ),
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text("Pesquisar Eventos");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: _appBarTitle,
        leading: MaterialButton(onPressed: _searchPressed, child: _searchIcon),
        actions: [AvatarButton()],
      ),
      body: _searching
          ? LoadingScreen()
          : this._searchIcon.icon == Icons.search
              ? EventCatalog()
              : EventSearchResults(searchResult: _searchResults),
    );
  }
}
