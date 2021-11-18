import admin from "../../../config/admin";

import Event from "../../../interfaces/Event";
import Topic from "../../../interfaces/Topic";
import Notification from "../../../interfaces/AppNotification";

import sendNotification from "../../../helpers/sendNotification";

const handleDuringEvent = async (db: FirebaseFirestore.Firestore,
    event:Event, eventTopic: Topic): Promise<void> => {
  if (eventTopic.uids.length === 0) {
    return;
  }

  await Promise.all(eventTopic.uids.map(async (uid) => {
    const notification: Notification = {
      title: "Evento iniciado!",
      body: `O evento ${event.title} iniciou. Não se esqueça de` +
       "cadastrar sua presença pelo app.",
      route: event.id,
      emissionDate: admin.firestore.Timestamp.now(),
      type: "EVENT_STARTED",
    };

    await sendNotification(db, uid, notification);
  }));
};

export default handleDuringEvent;
