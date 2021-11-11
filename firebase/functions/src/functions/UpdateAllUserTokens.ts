/* eslint-disable max-len */
import * as functions from "firebase-functions";

import admin from "../config/admin";
import FCMToken from "../interfaces/FCMToken";
import Topic from "../interfaces/Topic";

const db = admin.firestore();

export const updateAllUserTokens = functions.firestore
    .document("topics/{topicId}")
    .onUpdate(async (snapshot, _context) => {
      const topicBefore = snapshot.before.data() as Topic;
      const topicAfter = snapshot.after.data() as Topic;

      if (topicAfter.uids.length < topicBefore.uids.length) {
        const difference = topicBefore.uids
            .filter((uid) => topicAfter.uids.indexOf(uid) === -1);

        const uidToUnsubscribe = difference[0];

        const userSnapshot = await db.doc(`fcm_tokens/${uidToUnsubscribe}`).get();
        const user = userSnapshot.data() as FCMToken;

        await Promise.all(user.tokens.map(async (token: string) => {
          const topic = snapshot.after.id;
          await admin.messaging().unsubscribeFromTopic(token, topic);
        }));
      } else if (topicAfter.uids.length > topicBefore.uids.length) {
        const difference = topicAfter.uids
            .filter((uid) => topicBefore.uids.indexOf(uid) === -1);

        const uidToSubscribe = difference[0];

        const userSnapshot = await db.doc(`fcm_tokens/${uidToSubscribe}`).get();
        const user = userSnapshot.data() as FCMToken;

        await Promise.all(user.tokens.map(async (token: string) => {
          const topic = snapshot.after.id;
          await admin.messaging().subscribeToTopic(token, topic);
        }));
      }
    });
