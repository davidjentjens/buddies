/* eslint-disable max-len */
import * as functions from "firebase-functions";

import admin from "../config/admin";

const db = admin.firestore();

export const unsubscribeUsersOnDeleteEvent = functions.firestore
    .document("events/{eventId}")
    .onDelete(async (snapshot, _context) => {
      const eventId = snapshot.id;

      await db.doc(`topics/${eventId}`).update({
        "uids": [],
      });
    });
