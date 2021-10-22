import UserDetails from "./UserDetails";

export default interface Event{
  id: string;
  title: string;
  description: string;
  photoUrl: string;
  startTime: any;
  endTime: any ;
  locationData: any;
  point: any;
  creator: UserDetails;
  participants: UserDetails[];
  category: string;
}
