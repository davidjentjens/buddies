import {FirebaseError} from "firebase-admin";

import admin from "../../../config/admin";

import FCMToken from "../../../interfaces/FCMToken";
import Notification from "../../../interfaces/AppNotification";

const sendNotification = async (db: FirebaseFirestore.Firestore,
    uid:string, notification: Notification): Promise<void> => {
  const userTokenSnapshots = await db.collection("fcm_tokens")
      .doc(uid).get();

  const userTokens = userTokenSnapshots.data() as FCMToken;

  const notificationDoc = db
      .collection(`userinfo/${uid}/notifications`).doc();
  notification.id = notificationDoc.id;
  await notificationDoc.set(notification, {merge: true});

  await Promise.all(userTokens.tokens.map(async (userToken) => {
    const payload: admin.messaging.Message = {
      token: userToken,
      notification: {
        title: notification.title,
        body: notification.body,
        imageUrl: "https://firebasestorage.googleapis.com/v0/b/buddies-flutter.appspot.com/o/FCMImages%2Fapp_icon.png?alt=media&token=7dcbd19b-ef24-41c2-b702-908e5664a087",
      },
      data: {
        route: notification.route,
      },
    };

    try {
      const response = await admin.messaging().send(payload);
      console.log("Successfully sent message:", response);
      return {success: true};
    } catch (error) {
      return {error: (error as FirebaseError).code};
    }
  }));
};

export default sendNotification;
