/* eslint-disable @typescript-eslint/no-explicit-any */
import * as functions from "firebase-functions";

import admin from "../config/admin";
import Event from "../interfaces/Event";

const db = admin.firestore();

export const createEventTopic = functions.firestore
    .document("events/{eventId}")
    .onCreate(async (snapshot, _context) => {
      const event = snapshot.data() as Event;

      const participantUids = event.participants
          .map((participant) => participant.uid);

      await db.doc(`topics/${event.id}`).create({
        "uids": participantUids,
      });
    });
