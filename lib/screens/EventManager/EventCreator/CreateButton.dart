import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:buddies/services/Database/DatabaseService.dart';
import 'package:provider/provider.dart';

import '../../../models/LocationData.dart';
import '../../../models/UserDetails.dart';
import '../../../models/Event.dart';
import '../../../models/Category.dart';
import '../../../models/UserInfo.dart';
import '../../../widgets/Loader.dart';
import '../../../services/Database/Document.dart';

class CreateButton extends StatelessWidget {
  final formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final Category? selectedCategory;
  final DateTime selectedInitialDate;
  final DateTime selectedFinalDate;
  final LocationResult? selectedLocation;

  const CreateButton(
      {Key? key,
      required this.formKey,
      required this.titleController,
      required this.descriptionController,
      required this.selectedCategory,
      required this.selectedInitialDate,
      required this.selectedFinalDate,
      required this.selectedLocation})
      : super(key: key);

  _submitForm(BuildContext context, FirebaseAuth.User user) async {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: Text(
          'Há erros de validação. Por favor corrija-os antes de prosseguir.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red[300],
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height / 8,
            right: 40,
            left: 40),
      ));
      return;
    }

    if (this.selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: Text(
          'Erro: Selecione a categoria do evento.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red[300],
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height / 8,
            right: 40,
            left: 40),
      ));
      return;
    }

    if (this.selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: Text(
          'Erro: Selecione o lugar onde ocorrerá o evento.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red[300],
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height / 8,
            right: 40,
            left: 40),
      ));
      return;
    }

    final geo = Geoflutterfire();
    GeoFirePoint selectedPoint = geo.point(
        latitude: this.selectedLocation!.latLng!.latitude,
        longitude: this.selectedLocation!.latLng!.longitude);

    var userInfo =
        await Document<UserInfo>(path: 'userinfo/${user.uid}').getData();
    var rating = 5.0;

    if (userInfo.totalParticipation != 0) {
      rating = (userInfo.participationPoints / userInfo.totalParticipation) * 5;
    }

    UserDetails creatorUser = new UserDetails(
      uid: user.uid,
      name: user.displayName ?? 'Criador Anônimo',
      photoUrl: user.photoURL ?? '',
      rating: rating.toStringAsFixed(1),
    );

    LocationData locationData = new LocationData(
      formattedAddress: selectedLocation!.formattedAddress!,
      latitude: selectedLocation!.latLng!.latitude,
      longitude: selectedLocation!.latLng!.longitude,
      postalCode: selectedLocation!.postalCode!,
    );

    Event event = new Event(
      id: 'id',
      title: this.titleController.text,
      description: this.descriptionController.text,
      photoUrl: (this.selectedCategory!.images..shuffle()).first,
      startTime: Timestamp.fromDate(this.selectedInitialDate),
      endTime: Timestamp.fromDate(this.selectedFinalDate),
      locationData: locationData,
      point: selectedPoint.data,
      creator: creatorUser,
      participants: [creatorUser],
      participantUids: [user.uid],
      category: this.selectedCategory!.id,
    );

    try {
      await DatabaseService().createEvent(event);

      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: Text(
          'Parabéns! O seu evento foi criado com sucesso!',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green[300],
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height / 8,
            right: 40,
            left: 40),
      ));

      Navigator.pop(context);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: Text(
          'Ocorreu um erro inesperado ao criar o evento. Tente novamente mais tarde',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red[300],
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height / 8,
            right: 40,
            left: 40),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseAuth.User?>(context);

    if (user == null) {
      return LoadingScreen();
    }

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: TextButton(
        child: Text(
          'Criar Evento',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () => _submitForm(context, user),
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero)),
            primary: Colors.white,
            backgroundColor: Theme.of(context).primaryColor),
      ),
    );
  }
}
