import * as functions from "firebase-functions";

import admin from "../config/admin";
import messagingApi from "../services/messagingApi";

const db = admin.firestore();

export const unsubscribeAllUsers = functions.pubsub
    .schedule("* * * * 1").onRun(async (_context) => {
      const userSnapshots = await db.collection("fcm_tokens").get();

      await Promise.all(userSnapshots.docs.map(async (userSnapshot) => {
        const user = userSnapshot.data();
        functions.logger.log("USER", user);

        await Promise.all(user.tokens.map(async (token: string) => {
          const {data} = await messagingApi.get(`${token}?details=true`);

          functions.logger.log("TOKEN", data);

          const topics:string[] = Object.keys(data.rel.topics);

          functions.logger.log(topics);

          await Promise.all(topics.map(async (topic) => {
            functions.logger.log(token, topic);

            await admin.messaging().unsubscribeFromTopic(token, topic);
          }));
        }));
      }));
    });
