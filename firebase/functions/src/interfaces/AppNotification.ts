import {Timestamp} from "@google-cloud/firestore";

export default interface AppNotification{
  id?: string;
  title: string;
  body: string;
  type: "EVENT_SOON" | "EVALUATE";
  route: string;
  emissionDate: Timestamp;
}
