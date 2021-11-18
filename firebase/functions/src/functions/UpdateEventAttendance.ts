/* eslint-disable @typescript-eslint/no-explicit-any */
import * as functions from "firebase-functions";

import admin from "../config/admin";
import Event from "../interfaces/Event";

const db = admin.firestore();

export const updateEventAttendance = functions.firestore
    .document("events/{eventId}")
    .onUpdate(async (snapshot, _context) => {
      const eventAfter = snapshot.after.data() as Event;

      const currentDate = new Date();
      if (currentDate > eventAfter.startTime.toDate()) {
        return;
      }

      const participantData = {} as any;
      eventAfter.participants.map((participant) => participant.uid)
          .forEach((uid) => {
            participantData[uid] = false;
          });

      await db.collection("attendance").doc(eventAfter.id).set({
        "title": eventAfter.title,
        "code": eventAfter.code,
        "emissionDate": eventAfter.endTime,
        "participantData": participantData,
      });
    });
