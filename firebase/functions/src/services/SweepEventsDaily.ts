import * as functions from "firebase-functions";
import {FirebaseError} from "firebase-admin";

import admin from "../config/admin";
import Event from "../interfaces/Event";
import Topic from "../interfaces/Topic";
import FCMToken from "../interfaces/FCMToken";
import Notification from "../interfaces/AppNotification";

const db = admin.firestore();

const sendNotification = async (uid:string, notification: Notification) => {
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

export const sweepEventsDaily = functions.pubsub
    .schedule("0 * * * *")
    .onRun(async (_context) => {
      const currentDate = new Date();

      const events = db.
          collection("events")
          .where("finished", "==", false);
      const querySnapshot = await events.get();

      await Promise.all(querySnapshot.docs.map(async (doc) => {
        const event = doc.data() as Event;
        const eventStartDate = event.startTime.toDate();
        const eventEndDate = event.startTime.toDate();

        if (currentDate > eventEndDate) {
          await db.doc(`events/${event.id}`).update({
            "finished": true,
          });
        }

        const diffInMS = eventStartDate.getTime() - currentDate.getTime();
        const diffInHours = diffInMS / 1000 / 60 / 60;

        const eventTopicDoc = await db.doc(`topics/${event.id}`).get();
        const eventTopic = eventTopicDoc.data() as Topic;

        if (eventTopic.uids.length === 0) {
          return;
        }

        console.log(`Difference in hours: ${diffInHours}`);

        if (diffInHours > 0 && diffInHours < 24) {
          await Promise.all(eventTopic.uids.map(async (uid) => {
            const notification: Notification = {
              title: "Evento em breve!",
              body: `O evento ${event.title} irá começar em menos de 24h`,
              route: "notifications",
              emissionDate: admin.firestore.Timestamp.now(),
              type: "EVENT_SOON",
            };

            await sendNotification(uid, notification);
          }));
        } else if (diffInHours < 0) {
          await Promise.all(eventTopic.uids.map(async (uid) => {
            const notification: Notification = {
              title: "Evento encerrado buddies!",
              body: `O evento ${event.title} está encerrado. Pedimos que faça 
                uma avaliação de participação dos seus colegas para que 
                registrar quem estava presente. Obrigado :)`,
              route: "notifications",
              emissionDate: admin.firestore.Timestamp.now(),
              type: "EVALUATE",
            };

            await sendNotification(uid, notification);
          }));
        }
      }));
    });
