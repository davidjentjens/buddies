import 'package:buddies/models/Category.dart';
import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  final Category? selectedCategory;

  const EventImage({Key? key, required this.selectedCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverAppBar(
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      flexibleSpace: SizedBox(
        height: 200,
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
                image: NetworkImage(
                  this.selectedCategory != null
                      ? (this.selectedCategory!.images..shuffle()).first
                      : "https://images.unsplash.com/photo-1607962837359-5e7e89f86776?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=870&q=80",
                ),
                fit: BoxFit.cover,
              ),
            ),
            // TODO: Solução melhor para imagem do Evento?
            // Icon(
            //   Icons.camera_alt,
            //   color: Colors.white,
            //   size: 60,
            // ),
          ],
        ),
      ),
      expandedHeight: 150,
      backgroundColor: Color(0x00000000),
      elevation: 0,
    );
  }
}
