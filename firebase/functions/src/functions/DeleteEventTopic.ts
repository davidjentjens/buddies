/* eslint-disable @typescript-eslint/no-explicit-any */
import * as functions from "firebase-functions";

import admin from "../config/admin";

const db = admin.firestore();

export const deleteEventTopic = functions.firestore
    .document("events/{eventId}")
    .onDelete(async (snapshot, _context) => {
      await db.collection("topics").doc(snapshot.id).delete();
    });
