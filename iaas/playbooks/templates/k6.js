
import { check,sleep } from "k6";
import http from "k6/http";

let token = "";
const BASE_URL = "http://172.31.0.239/index.php";

export const options = {
  //vus: 50,
	//duration: "60s",
   stages: [
    
    { duration: '5m', target: 50 }, 
    { duration: '10m', target: 50 }, 
    { duration: '5m', target: 100 }, 
    { duration: '10m', target: 100 },
    { duration: '5m', target: 200 }, 
    { duration: '10m', target: 200 },
    { duration: '5m', target: 400 }, 
    { duration: '10m', target: 400 }, 
    { duration: '5m', target: 600 }, 
    { duration: '10m', target: 600 }, 
    { duration: '5m', target: 800 }, 
    { duration: '10m', target: 800 }, 
    { duration: '5m', target: 0 },   
   ],
};


export default function (data) {

  const res = http.get(
    BASE_URL
  );
  check(res, {
    "status is 200": (r) => r.status === 200,
  });
  sleep(1); // Simulate user think time
}