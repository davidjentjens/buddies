import {firestore} from "firebase-admin";
import * as functions from "firebase-functions";

import admin from "../config/admin";
import Event from "../interfaces/Event";

const db = admin.firestore();

export const incrementCategoryEventNum = functions.firestore
    .document("events/{eventId}")
    .onCreate(async (snapshot, _context) => {
      const event = snapshot.data() as Event;

      const categorieRef = db.doc(`categories/${event.category}`);

      await categorieRef.update({
        eventNum: firestore.FieldValue.increment(1),
      });
    });
