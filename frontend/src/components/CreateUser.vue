<template>
  <div class="container_modal">
    <div class="modal_content_account">
      <div class="container_input">
        <h1 class="title">SIGN IN</h1>

        <form @submit.prevent="createUser">
          <div class="container_input_icon">
            <input
              id="username"
              type="text"
              placeholder="Username"
              v-model="newUsername"
            />

            <i class="fas fa-user icon_input"></i>
          </div>

          <div class="container_input_icon">
            <input
              id="email"
              type="email"
              placeholder="Email"
              v-model="newEmail"
            />

            <i class="fas fa-envelope icon_input"></i>
          </div>

          <div class="container_input_icon">
            <input
              id="mdp"
              type="password"
              v-model="mdp"
              placeholder="Password"
            />

            <i class="fas fa-lock icon_input"></i>
          </div>

          <div class="container_btn">
            <button class="btnLogin">Create user</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Modal de Succès -->
  <div id="notifSuccess" class="notif-container notif-close">
    <div class="notif">
      <i class="fas fa-check-circle check-color icon_notif"></i>
      <p class="text_notif">{{ successMessage }}</p>
      <i @click="NotifClose('Success')" class="fas fa-x icon-close"></i>
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
</template>

<script setup>
import { ref } from "vue";
import serv from "@/Instance/axios";

const newEmail = ref(null);
const newUsername = ref(null);
const mdp = ref(null);
const successMessage = ref("");
const error = ref("");

const createUser = async () => {
  try {
    // Appel à l'API pour créer l'utilisateur
    await serv.post(
      "/api/users",
      {
        users: {
          username: newUsername.value,
          email: newEmail.value,
          mdp: mdp.value,
          status: "employee",
        },
      }
    );

    localStorage.setItem("activeComponent", "authentification");
    window.location.reload();
  } catch (err) {
    const type = typeof err.response.data.error;
    if (type === "object") {
      const keys = Object.keys(err.response.data.error);
      const value = Object.values(err.response.data.error);
      const final_value = [];
      let KeyError = "";
      let ValueError = "";
      let sentenceError = "";
      keys.forEach(function (key, index) {
        final_value.push(value[index][0]);
      });

      const checkSameValue = final_value.every(
        (val) => JSON.stringify(val) === JSON.stringify(final_value[0])
      );

      if (checkSameValue) {
        KeyError += `${keys}`;
        ValueError = `${final_value[0]}`;
        sentenceError = `${KeyError} ${ValueError}`;
        error.value = sentenceError;
      }
    } else {
      error.value = err.response.data.error;
    }
    Notif("Error");
  }
};

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
</script>
