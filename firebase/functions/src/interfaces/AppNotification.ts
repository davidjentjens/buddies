import {Timestamp} from "@google-cloud/firestore";

export default interface AppNotification{
  id?: string;
  title: string;
  body: string;
  type: "EVENT_SOON" | "EVENT_END";
  route: string;
  emissionDate: Timestamp;
}
