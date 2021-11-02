import * as functions from "firebase-functions";

import admin from "../config/admin";
import Event from "../interfaces/Event";
import Topic from "../interfaces/Topic";

const db = admin.firestore();

export const sweepEventsDaily = functions.pubsub
    .schedule("* 12 * * *")
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

        functions.logger.log(`\nDIFFERENCEINHOURS: ${diffInHours}\n`);

        if (diffInHours < 24) {
          const eventTopicDoc = await db.doc(`topics/${event.id}`).get();
          const eventTopic = eventTopicDoc.data() as Topic;

          if (eventTopic.tokens.length !== 0) {
            eventTopic.tokens.forEach((token) => {
              const payload = {
                token: token,
                notification: {
                  title: "Evento em breve!",
                  body: `O evento ${event.title} irá começar em menos de 24h`,
                },
                data: {
                  eventId: event.id,
                },
              };

              admin.messaging().send(payload).then((response) => {
                // Response is a message ID string.
                console.log("Successfully sent message:", response);
                return {success: true};
              }).catch((error) => {
                return {error: error.code};
              });
            });
          }
        }
      }));
    });
