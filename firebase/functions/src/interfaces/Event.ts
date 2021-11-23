import {Timestamp} from "@google-cloud/firestore";

import UserDetails from "./UserDetails";

export default interface Event{
  id: string;
  title: string;
  description: string;
  photoUrl: string;
  startTime: Timestamp;
  endTime: Timestamp;
  locationData: any;
  point: any;
  creator: UserDetails;
  participants: UserDetails[];
  participantUids: string[];
  category: string;
  beforeNotificationSent: boolean;
  duringNotificationSent: boolean;
  finished: boolean;
  code: string;
}
