import axios from "axios";
import { ref } from "vue";

const token = localStorage.getItem("token");
const jwt = localStorage.getItem("jwt");

const mobile = ref(false);

function isDesktop() {
  return !navigator.userAgent.match(/Mobi/);
}

if (isDesktop()) {
  mobile.value = false;
} else {
  mobile.value = true;
}

const serv = axios.create({
  // ...(mobile.value === false
  // ? { baseURL: "http://localhost:4000" }
  // : { baseURL: "http://10.109.249.2:4000" }),
  baseURL: "http://localhost:4000",
  withCredentials: true,
  headers: {
    ...(jwt !== "" ? { "X-Custom-Header": jwt } : {}),
    authorization: token,
    "Y-Custom-Header": mobile.value,
  },
});

export default serv;
