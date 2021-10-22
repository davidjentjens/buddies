import * as functions from "firebase-functions";

import admin from "../config/admin";

const db = admin.firestore();

export const sweetEventsDaily = functions.runWith({memory: "2GB"}).pubsub
    .schedule("* * * * *")
    .onRun(async (_context) => {
      const currentDate = new Date();

      await db.collection("events")
          .where("startTime", "<", currentDate)
          .where("startTime", ">", currentDate.getDate() - 1)
          .get().then((response) => {
            const batch = db.batch();
            response.docs.forEach((_doc) => {
              // const docRef = db.collection("events").doc(doc.id);
              // batch.update(docRef, newDocumentBody);
            });
            batch.commit().then(() => {
              console.log("updated all documents inside events");
            });
          });
    });
