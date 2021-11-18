/* eslint-disable @typescript-eslint/no-explicit-any */
import * as functions from "firebase-functions";

import admin from "../config/admin";
import Event from "../interfaces/Event";

const db = admin.firestore();

export const createEventAttendance = functions.firestore
    .document("events/{eventId}")
    .onCreate(async (snapshot, _context) => {
      const event = snapshot.data() as Event;

      const participantData = {} as any;
      event.participants.map((participant) => participant.uid)
          .forEach((uid) => {
            participantData[uid] = false;
          });

      await db.collection("attendance").doc(snapshot.id).set({
        "title": event.title,
        "code": event.code,
        "emissionDate": event.endTime,
        "participantData": participantData,
      });
    });
