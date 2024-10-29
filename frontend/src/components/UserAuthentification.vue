<template>
  <div>
    <div class="container_modal">
      <div class="modal_content_auth">
        <div class="container_input">
          <h1 class="title">LOG IN</h1>

          <div class="container_input_icon">
            <input
              v-model="emailUser"
              id="email"
              type="email"
              placeholder="Email"
              required
            />

            <i class="fas fa-user icon_input"></i>
          </div>

          <div class="container_input_icon">
            <input
              v-model="passwordUser"
              id="password"
              type="password"
              placeholder="Password"
              required
            />

            <i class="fas fa-lock icon_input"></i>
          </div>

          <div class="container_btn">
            <div class="btnLogin" @click="logIn">Login</div>
          </div>
          <div class="center">
            <p class="text-white mt-2">
              No account yet ?
              <button @click="goSignIn" class="link">Sign in</button>
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal de Error -->
    <div id="notifError" class="notif-container notif-close">
      <div class="notif">
        <i class="fas fa-circle-exclamation wrong-color icon_notif"></i>
        <p class="text_notif">{{ error }}</p>
        <i @click="NotifClose('Error')" class="fas fa-x icon-close"></i>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import serv from "../Instance/axios";

const emailUser = ref("");
const passwordUser = ref("");
const error = ref("");
const mobile = ref(false)

function isDesktop() {
  return !navigator.userAgent.match(/Mobi/);
}

if (isDesktop()) {
  console.log("L'application est exécutée dans un navigateur de bureau.");
} else {
  mobile.value = true
}

const Notif = (typeNotif) => {
  const id = "notif" + typeNotif;
  const notif = document.getElementById(id);
  const AllNotif = document.querySelectorAll(".notif-container");

  AllNotif.forEach(function (each) {
    each.classList.add("notif-close");
    each.classList.remove("notif-open");
  });

  notif.classList.toggle("notif-close");
  notif.classList.toggle("notif-open");

  setTimeout(function () {
    notif.classList.add("notif-close");
    notif.classList.remove("notif-open");
  }, 3000);
};

const NotifClose = (typeNotif) => {
  const id = "notif" + typeNotif;
  const notif = document.getElementById(id);
  notif.classList.toggle("notif-close");
  notif.classList.toggle("notif-open");
};

const logIn = async () => {
  try {
    error.value = "";
    const log = await serv.post("api/user/auth", {
      users: {
        email: emailUser.value,
        mdp: passwordUser.value,
      },
    });
    const iduser = log.data.data.id;
    const token = log.data.token;

    if(mobile.value === true){
      const jwt = log.data.jwt_token
      localStorage.setItem("jwt", jwt);
      localStorage.setItem("activeComponent", "account");
    }else{
      localStorage.setItem("activeComponent", "calendar");
    }
    localStorage.setItem("token", token);
    localStorage.setItem("idUser", iduser);
    window.location.reload();
  } catch (err) {
    error.value = err.response.data.error;
    Notif("Error");
  }
};

const goSignIn = () => {
  localStorage.setItem("activeComponent", "createUser");
  window.location.reload();
};
</script>
