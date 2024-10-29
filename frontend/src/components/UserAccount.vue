<template>
  <div class="user-manager-container">
    <div id="ManagerUser">
      <h2 class="title-page">Your account</h2>
      <div class="container" id="containerUpdate">
        <div class="center">
          <!-- Afficher les informations de l'utilisateur si elles existent -->
          <div class="modal_content_account">
            <div class="container_input">
              <label for="id" class="labelConnect">ID :</label>
              <input v-model="id" disabled type="text" class="input" />

              <label for="username" class="labelConnect require"
                >Username :</label
              >
              <input v-model="username" type="text" class="input" />

              <label for="email" class="labelConnect">Email :</label>
              <input v-model="email" disabled type="email" class="input" />

              <label for="manager" class="labelConnect">My role :</label>
              <input
                v-model="role"
                disabled
                type="text"
                id="roleInput"
                class="input"
              />

              <label for="mdp" id="labelMdp" class="labelConnect hide"
                >Password</label
              >
              <input
                v-model="mdp"
                id="mdpInput"
                type="password"
                class="input hide"
              />

              <p
                style="cursor: pointer; margin-top: 20px; color: white"
                id="showUpdateMdp"
                @click="showUpdateMdp"
              >
                update password
              </p>
              <p
                style="cursor: pointer; margin-top: 20px; color: white"
                id="hideUpdateMdp"
                class="hide"
                @click="hideUpdateMdp"
              >
                return
              </p>

              <!-- Actions pour mettre à jour et supprimer l'utilisateur -->
              <div class="d-flex justify-content-center gap-3 mt-3">
                <button @click="updateUser" class="btn btn-warning w_50">
                  Update user
                </button>

                <button
                  @click="showDeleteConfirmationModal"
                  class="btn btn-danger w_50"
                >
                  Delete user
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal de Confirmation de Suppression -->
    <div
      class="modal fade"
      id="confirmationModal"
      tabindex="-1"
      aria-labelledby="confirmationModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="confirmationModalLabel">
              Confirmation
            </h5>

            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>

          <div class="modal-body text-white">
            Are you sure you want to delete this user?
          </div>

          <div class="modal-footer d-flex w-100">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Cancel
            </button>

            <button
              type="button"
              @click="confirmDeleteUser"
              class="btn btn-danger ms-auto"
              data-bs-dismiss="modal"
            >
              Delete
            </button>
          </div>
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
  </div>
</template>

<script setup>
import serv from "../Instance/axios";
import { Modal } from "bootstrap";
import { ref, onMounted } from "vue";

const id = ref(localStorage.getItem("idUser"));
const username = ref("");
const email = ref("");
const mdp = ref(null);
const role = ref(null);
const error = ref("");
const successMessage = ref("");

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
// Méthode pour récupérer un utilisateur en utilisant soit l'ID, soit l'email et le nom d'utilisateur
const getUser = async () => {
  try {
    // Vérifier si l'ID est fourni et est un nombre valide
    if (id.value && !isNaN(Number(id.value)) && Number(id.value) >= 0) {
      // Si l'ID est valide, faire la requête par l'ID
      const response = await serv.get(`/api/users/${id.value}`);

      const user = response.data.data;
      username.value = user.username;
      email.value = user.email;
      role.value = user.status;
      error.value = "";
    }
  } catch (error) {
    error.value = "Error recovering user";
    Notif("Error");
  }
};

// Méthode pour mettre à jour un utilisateur
const updateUser = async () => {
  try {
    const mdp = document.getElementById("mdpInput");
    const label = document.getElementById("labelMdp");
    const btnShowMdp = document.getElementById("showUpdateMdp");
    const btnreturnMdp = document.getElementById("hideUpdateMdp");

    if (username.value !== "" && role.value !== "") {
      if (!mdp.value) {
        await serv.put(
          `/api/users/${id.value}`,
          {
            users: {
              username: username.value,
              email: email.value,
            },
          },
        );
      } else {
        await serv.put(
          `/api/users/${id.value}`,
          {
            users: {
              username: username.value,
              email: email.value,
              mdp: mdp.value,
            },
          }
        );
      }

      btnreturnMdp.classList.add("hide");
      btnShowMdp.classList.remove("hide");

      mdp.classList.add("hide");
      label.classList.add("hide");

      // Affiche une alerte de confirmation
      successMessage.value = "User updated successfully.";
      Notif("Success");
    } else {
      error.value = "Error updating user";
      Notif("Error");
    }
  } catch (err) {
    error.value = "Error updating user";
    Notif("Error");
  }
};

// Méthode pour supprimer un utilisateur récupéré
const deleteUser = async () => {
  try {
    // Appel à l'API pour supprimer l'utilisateur récupéré
    await serv.delete(`/api/users/${id.value}`);

    // Affiche une alerte de confirmation
    successMessage.value = "User deleted successfully.";
    Notif("Success");

    localStorage.removeItem("token");
    localStorage.removeItem("idUser");
    window.location.reload();
    localStorage.setItem("activeComponent", "authentification");

    // Réinitialise le formulaire après la suppression
    error.value = "";
    cancel(); // Réinitialise les données du formulaire
  } catch (error) {
    error.value = "Error deleting user";
    Notif("Error");
  }
};

const showDeleteConfirmationModal = () => {
  // Affiche le modal de confirmation
  new Modal(document.getElementById("confirmationModal")).show();
};

const showUpdateMdp = () => {
  const mdp = document.getElementById("mdpInput");
  const label = document.getElementById("labelMdp");
  const btnShow = document.getElementById("showUpdateMdp");
  const btnreturn = document.getElementById("hideUpdateMdp");
  mdp.classList.remove("hide");
  label.classList.remove("hide");
  btnreturn.classList.remove("hide");
  btnShow.classList.add("hide");
};

const hideUpdateMdp = () => {
  const mdp = document.getElementById("mdpInput");
  const label = document.getElementById("labelMdp");
  const btnShow = document.getElementById("showUpdateMdp");
  const btnreturn = document.getElementById("hideUpdateMdp");
  mdp.classList.add("hide");
  label.classList.add("hide");
  btnreturn.classList.add("hide");
  btnShow.classList.remove("hide");

  mdp.value = null;
};

const confirmDeleteUser = () => {
  deleteUser();
};

const cancel = () => {
  id.value = "";
  username.value = "";
  email.value = "";
  mdp.value = "";
  role.value = "";
  error.value = "";
};

onMounted(() => {
  getUser();
});
</script>
