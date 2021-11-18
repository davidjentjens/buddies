import admin from "../../../config/admin";

import Event from "../../../interfaces/Event";
import Topic from "../../../interfaces/Topic";
import Notification from "../../../interfaces/AppNotification";

import sendNotification from "./sendNotification";

const handleAfterEvent = async (db: FirebaseFirestore.Firestore,
    event:Event, eventTopic: Topic): Promise<void> => {
  await db.doc(`events/${event.id}`).update({
    "finished": true,
  });

  // TODO: Implement rating calculation based on event attendance (attendance)

  if (eventTopic.uids.length === 0) {
    return;
  }

  await Promise.all(eventTopic.uids.map(async (uid) => {
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
};

export default handleAfterEvent;
