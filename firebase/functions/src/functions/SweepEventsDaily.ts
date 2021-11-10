import * as functions from "firebase-functions";

import admin from "../config/admin";

import sendNotification from "../helpers/sendNotification";

import Event from "../interfaces/Event";
import Topic from "../interfaces/Topic";
import Notification from "../interfaces/AppNotification";

const db = admin.firestore();

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
        const eventEndDate = event.endTime.toDate();

        const eventTopicDoc = await db.doc(`topics/${event.id}`).get();
        const eventTopic = eventTopicDoc.data() as Topic;

        if (eventTopic.uids.length === 0) {
          return;
        }

        if (currentDate > eventEndDate) {
          await db.doc(`events/${event.id}`).update({
            "finished": true,
          });
          await Promise.all(eventTopic.uids.map(async (uid) => {
            const notification: Notification = {
              title: "Evento encerrado buddies!",
              body: `O evento ${event.title} está encerrado. Pedimos que faça` +
                " uma avaliação de participação dos seus colegas para que" +
                " possa ser registrada a sua presença. Obrigado :)",
              route: event.id,
              emissionDate: admin.firestore.Timestamp.now(),
              type: "EVALUATE",
            };

            await sendNotification(db, uid, notification);
          }));
        }

        const diffInMS = eventStartDate.getTime() - currentDate.getTime();
        const diffInHours = diffInMS / 1000 / 60 / 60;

        if (diffInHours > 0 && diffInHours < 24) {
          await Promise.all(eventTopic.uids.map(async (uid) => {
            const notification: Notification = {
              title: "Evento em breve!",
              body: `O evento ${event.title} irá começar em menos de 24h`,
              route: event.id,
              emissionDate: admin.firestore.Timestamp.now(),
              type: "EVENT_SOON",
            };

            await sendNotification(db, uid, notification);
          }));
        }
      }));
    });
