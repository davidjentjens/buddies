import admin from "../../../config/admin";

import Event from "../../../interfaces/Event";
import Topic from "../../../interfaces/Topic";
import Notification from "../../../interfaces/AppNotification";

import sendNotification from "../../../helpers/sendNotification";

const handleBeforeEvent = async (db: FirebaseFirestore.Firestore,
    event: Event, eventTopic: Topic): Promise<void> => {
  if (event.beforeNotificationSent || eventTopic.uids.length === 0) {
    return;
  }

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
};

export default handleBeforeEvent;
