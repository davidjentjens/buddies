import * as functions from "firebase-functions";

import admin from "../../config/admin";

import Event from "../../interfaces/Event";
import Topic from "../../interfaces/Topic";

import handleBeforeEvent from "./helpers/handleBeforeEvent";
import handleDuringEvent from "./helpers/handleDuringEvent";
import handleAfterEvent from "./helpers/handleAfterEvent";

const db = admin.firestore();

export const sweepEventsPeriodically = functions.pubsub
    .schedule("* * * * *")
    .onRun(async (_context) => {
      const events = db.
          collection("events")
          .where("finished", "==", false);
      const querySnapshot = await events.get();

      await Promise.all(querySnapshot.docs.map(async (eventDoc) => {
        const event = eventDoc.data() as Event;

        const eventTopicDoc = await db.doc(`topics/${event.id}`).get();
        const eventTopic = eventTopicDoc.data() as Topic;

        const eventStartDate = event.startTime.toDate();
        const eventEndDate = event.endTime.toDate();

        const currentDate = new Date();
        const diffInMS = eventStartDate.getTime() - currentDate.getTime();
        const diffInHours = diffInMS / 1000 / 60 / 60;

        if (diffInHours > 0 && diffInHours < 24) {
          await handleBeforeEvent(db, event, eventTopic);
          await eventDoc.ref.update({
            "beforeNotificationSent": true,
          });
          return;
        }

        if (currentDate > eventStartDate && currentDate < eventEndDate) {
          await handleDuringEvent(db, event, eventTopic);
          await eventDoc.ref.update({
            "duringNotificationSent": true,
          });
          return;
        }

        if (currentDate > eventEndDate) {
          await handleAfterEvent(db, event, eventTopic);
        }
      }));
    });
