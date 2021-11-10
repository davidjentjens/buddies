/* eslint-disable max-len */
import axios from "axios";

const messagingApi = axios.create({
  baseURL: "https://iid.googleapis.com/iid/info/",
  // timeout: 5000,
  headers: {
    "Authorization": "key=AAAA4RvSzRw:APA91bGRCSeht5xARrU4AWtw-8Hdec35qbWW8wdMnPS26zUSNqmbpB_Iky1FflbCU-FmZAxQ1YiqyySXjoRhjwkX4E0UPOgqr9lDTpkWVzpycnE7fy-WBvOjE5RE4AuD6o6Y-LTzpErO",
    "Content-Type": "application/json",
    "accept": "application/json",
  },
});

export default messagingApi;

