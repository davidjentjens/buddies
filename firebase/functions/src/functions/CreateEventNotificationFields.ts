/* eslint-disable @typescript-eslint/no-explicit-any */
import * as functions from "firebase-functions";

import admin from "../config/admin";
import Event from "../interfaces/Event";

const db = admin.firestore();

export const createEventNotificationFields = functions.firestore
    .document("events/{eventId}")
    .onCreate(async (snapshot, _context) => {
      const event = snapshot.data() as Event;

      await db.doc(`events/${event.id}`).create({
        "beforeNotificationSent": false,
        "duringNotificationSent": false,
      });
    });
