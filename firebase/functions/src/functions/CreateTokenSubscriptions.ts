import * as functions from "firebase-functions";

import admin from "../config/admin";
import FCMToken from "../interfaces/FCMToken";
import Topic from "../interfaces/Topic";

const db = admin.firestore();

export const createTokenSubscriptions = functions.firestore
    .document("topics/{topicId}")
    .onCreate(async (snapshot, _context) => {
      const topic = snapshot.data() as Topic;

      await Promise.all(topic.uids.map(async (uid) => {
        const userSnapshot = await db.doc(`fcm_tokens/${uid}`).get();
        const user = userSnapshot.data() as FCMToken;

        await Promise.all(user.tokens.map(async (token: string) => {
          await admin.messaging().subscribeToTopic(token, snapshot.id);
        }));
      }));
    });
