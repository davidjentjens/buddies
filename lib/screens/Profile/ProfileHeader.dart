import 'package:buddies/models/UserInfo.dart';
import 'package:buddies/services/Database/Document.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

class ProfileHeader extends StatelessWidget {
  final FirebaseAuth.User user;

  const ProfileHeader({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Document<UserInfo>(path: 'userinfo/${this.user.uid}').getData(),
      builder: (BuildContext context, AsyncSnapshot<UserInfo> futureSnapshot) {
        if (futureSnapshot.hasData) {
          var rating = 5.0;

          if (futureSnapshot.data!.totalParticipation != 0) {
            rating = (futureSnapshot.data!.participationPoints /
                    futureSnapshot.data!.totalParticipation) *
                5;
          }

          return Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    child: CircleAvatar(
                      backgroundImage: this.user.photoURL != null
                          ? NetworkImage(this.user.photoURL!)
                          : AssetImage("assets/avatar_placeholder.jpg")
                              as ImageProvider,
                    ),
                    height: 75,
                    width: 75),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(this.user.displayName ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_rate,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${rating.toStringAsFixed(1)} / 5',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
