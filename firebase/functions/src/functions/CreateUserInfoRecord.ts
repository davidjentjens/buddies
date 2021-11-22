import * as functions from "firebase-functions";

import admin from "../config/admin";

const db = admin.firestore();

export const createUserInfoRecord = functions.auth
    .user()
    .onCreate((user) => {
      const userInfoRef = db.doc(`userinfo/${user.uid}`);

      return userInfoRef.set({
        events: [],
        interests: [],
        uid: user.uid,
        participationPoints: 0,
        totalParticipation: 0,
      });
    });
