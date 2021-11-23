import {firestore} from "firebase-admin";
import admin from "../../../config/admin";

import Event from "../../../interfaces/Event";
import Topic from "../../../interfaces/Topic";
import Notification from "../../../interfaces/AppNotification";

import sendNotification from "../../../helpers/sendNotification";

const handleAfterEvent = async (db: FirebaseFirestore.Firestore,
    event:Event, eventTopic: Topic): Promise<void> => {
  await db.doc(`events/${event.id}`).update({
    "finished": true,
  });

  if (eventTopic.uids.length === 0) {
    return;
  }

  const attendanceDoc = await db.doc(`attendance/${event.id}`).get();
  const attendance = attendanceDoc.data();

  if (!attendance) {
    return;
  }

  await Promise.all(eventTopic.uids.map(async (uid) => {
    const userInfoDoc = db.doc(`userinfo/${uid}`);

    if (attendance.participantData[uid] === true) {
      await userInfoDoc.set({
        "participationPoints": firestore.FieldValue.increment(1),
        "totalParticipation": firestore.FieldValue.increment(1),
      }, {merge: true});
    } else {
      await userInfoDoc.set({
        "totalParticipation": firestore.FieldValue.increment(1),
      }, {merge: true});
    }

    const notification: Notification = {
      title: "Evento encerrado buddies!",
      body: `O evento ${event.title} está encerrado. Esperamos que` +
          " tenha tido uma ótima experiência! Você ainda pode ver os" +
          " detalhes do evento no seu histórico.",
      route: event.id,
      emissionDate: admin.firestore.Timestamp.now(),
      type: "EVENT_END",
    };

    await sendNotification(db, uid, notification);
  }));

  await db.doc(`topics/${event.id}`).delete();
  await db.doc(`attendance/${event.id}`).delete();
};

export default handleAfterEvent;
