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
  category: string;
  finished: boolean;
}
