<template>
  <div class="user-manager-container">
    <div id="ManagerUser">
      <h2 class="title-page">User Management</h2>
      <div class="center">
        <div class="grid_2">
          <p class="btnChoice" id="btnModalCreate" @click="showContaineCreate">
            Create
          </p>
          <p
            class="btnChoice unselect"
            id="btnModalUpdate"
            @click="showContaineUpdate"
          >
            Update
          </p>
        </div>
      </div>
      <div class="center" id="containerCreate">
        <div class="modal_content">
          <div class="container_input">
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
                  type="mdp"
                  v-model="mdp"
                  placeholder="Password"
                />

                <i class="fas fa-lock icon_input"></i>
              </div>

              <div v-if="currentUserRole === 'general manager'">
                <div class="container_input_icon">
                  <select v-model="newRole" id="role" class="SelectOptions">
                    <option value="employee">Employee</option>
                    <option value="manager">Manager</option>
                  </select>
                </div>
              </div>

              <div class="d-flex justify-content-center mt-4">
                <!-- Bouton pour créer l'utilisateur -->
                <button type="submit" class="btn btn-primary btn-dark-blue">
                  Create user
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
      <div class="hide" id="containerUpdate">
        <div class="center mb-4">
          <div class="grid_4">
            <input
              v-model="searchUsername"
              type="text"
              placeholder="Username"
              class="input_search"
            />
            <input
              v-model="searchEmail"
              type="email"
              placeholder="Email"
              class="input_search"
            />

            <input
              v-model="searchID"
              type="text"
              placeholder="ID"
              class="input_search"
            />

            <div class="update-search">
              <i class="fas fa-search search" @click="getUser"></i>
            </div>
          </div>
        </div>
        <div class="center">
          <!-- Afficher les informations de l'utilisateur si elles existent -->
          <div class="modal_content_account modal_content_update">
            <div class="container_input">
              <div class="container_input_icon">
                <input v-model="id" placeholder="ID" disabled type="text" />
                <i class="fas fa-list-1-2 icon_input"></i>
              </div>

              <div class="container_input_icon">
                <input v-model="username" placeholder="Username" type="text" />
                <i class="fas fa-user icon_input"></i>
              </div>

              <div class="container_input_icon">
                <input
                  v-model="email"
                  disabled
                  type="text"
                  placeholder="Email"
                />
                <i class="fas fa-envelope icon_input"></i>
              </div>

              <div class="container_input_icon">
                <input
                  v-model="role"
                  disabled
                  type="text"
                  placeholder="Role"
                  id="roleInput"
                />
                <i class="fas fa-user icon_input"></i>
              </div>

              <div class="container_input_icon">
                <select
                  v-model="role"
                  id="roleSelect"
                  class="SelectOptions hide"
                >
                  <option :value="role">{{ role }}</option>
                  <option value="employee">Employee</option>
                  <option value="manager">Manager</option>
                </select>
              </div>

              <div class="container_input_icon hide" id="mdpInput">
                <input v-model="mdp" type="text" placeholder="Password" />

                <i class="fas fa-lock icon_input"></i>
              </div>

              <div class="grid_2 mt-2">
                <div v-if="currentUserRole === 'general manager'">
                  <p
                    style="cursor: pointer; color: white"
                    id="showUpdateRole"
                    @click="showUpdateRole"
                  >
                    update role
                  </p>
                  <p
                    style="cursor: pointer; color: white"
                    id="hideUpdateRole"
                    class="hide"
                    @click="hideUpdateRole"
                  >
                    return
                  </p>
                </div>

                <p
                  style="cursor: pointer; color: white"
                  id="showUpdateMdp"
                  @click="showUpdateMdp"
                >
                  update password
                </p>
                <p
                  style="cursor: pointer; color: white"
                  id="hideUpdateMdp"
                  class="hide"
                  @click="hideUpdateMdp"
                >
                  return
                </p>
              </div>

              <!-- Actions pour mettre à jour et supprimer l'utilisateur -->
              <div class="d-flex justify-content-center gap-3 mt-3">
                <button @click="updateUser()" class="btn btn-warning">
                  Update user
                </button>

                <button
                  @click="showDeleteConfirmationModal"
                  class="btn btn-danger"
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
            Êtes-vous sûr de vouloir supprimer cet utilisateur ?
          </div>

          <div class="modal-footer d-flex w-100">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Annuler
            </button>

            <button
              type="button"
              @click="confirmDeleteUser"
              class="btn btn-danger ms-auto"
              data-bs-dismiss="modal"
            >
              Supprimer
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Notif de Succès -->
    <div id="notifSuccess" class="notif-container notif-close">
      <div class="notif">
        <i class="fas fa-check-circle check-color icon_notif"></i>
        <p class="text_notif">{{ successMessage }}</p>
        <i @click="NotifClose('Success')" class="fas fa-x icon-close"></i>
      </div>
    </div>

    <!-- Notif de Error -->
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

// Reçoit l'ID utilisateur comme prop depuis SideNavBar
const props = defineProps({
  userId: {
    type: Number,
    required: true,
  },
});

const searchEmail = ref("");
const searchUsername = ref("");
const searchID = ref(null);
const newEmail = ref("");
const newUsername = ref("");
const newRole = ref("employee");
const id = ref(null);
const username = ref("");
const email = ref("");
const mdp = ref(null);
const role = ref(null);
const error = ref("");
const successMessage = ref("");
const currentUserRole = ref("");
const adminTeams = ref([]);
const selectedTeam = ref(null);

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

const createUser = async () => {
  try {
    // Appel à l'API pour créer l'utilisateur
    const response = await serv.post(
      "/api/users",
      {
        users: {
          username: newUsername.value,
          email: newEmail.value,
          mdp: mdp.value,
          status: newRole.value || "employee",
        },
      },
    );

    const createdUserId = response.data.data.id;

    if (selectedTeam.value) {
      // Crée la liaison avec l'équipe dans teamlink
      await serv.post(
        "/api/teamlink",
        {
          team_link: {
            team_id: selectedTeam.value,
            user_id: createdUserId,
          },
        },
      );
    }

    // Affiche une alerte de confirmation
    successMessage.value = "User created successfully.";
    Notif("Success");

    cancel(); // Réinitialise les données du formulaire
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

// Fonction pour récupérer les équipes de l'administrateur
const fetchAdminTeams = async () => {
  try {
    const response = await serv.get(`/api/team/admin/${props.userId}`);
    adminTeams.value = response.data.data; // Assigne les équipes récupérées
  } catch (error) {
    console.error("Failed to fetch teams:", error);
    error.value = "Failed to load teams.";
  }
};

// Méthode pour récupérer un utilisateur en utilisant soit l'ID, soit l'email et le nom d'utilisateur
const getUser = async () => {
  try {
    // Vérifier si l'ID est fourni et est un nombre valide
    if (
      searchID.value &&
      !isNaN(Number(searchID.value)) &&
      Number(searchID.value) >= 0
    ) {
      // Si l'ID est valide, faire la requête par l'ID
      const response = await serv.get(`/api/users/${searchID.value}`);

      const user = response.data.data;

      id.value = user.id;
      username.value = user.username;
      email.value = user.email;
      role.value = user.status;
      error.value = "";
    } else if (searchEmail.value && searchUsername.value) {
      // Si l'email et le nom d'utilisateur sont fournis, faire la requête par email et username
      const response = await serv.get(
        `/api/users?email=${searchEmail.value}&username=${searchUsername.value}`
      );
      const user = response.data.data;
      id.value = user.id;
      username.value = user.username;
      email.value = user.email;
      role.value = user.status;
      error.value = "";
    } else {
      error.value =
        "Please enter either a user ID or email and a valid username.";
      Notif("Error");
    }
  } catch (err) {
    error.value = err.response.data.error;
    Notif("Error");
  }
};

// Méthode pour mettre à jour un utilisateur
const updateUser = async () => {
  try {
    const mdp = document.getElementById("mdpInput");
    const btnShowMdp = document.getElementById("showUpdateMdp");
    const btnreturnMdp = document.getElementById("hideUpdateMdp");
    const input = document.getElementById("roleInput");
    const select = document.getElementById("roleSelect");
    const btnShowRole = document.getElementById("showUpdateRole");
    const btnreturnRole = document.getElementById("hideUpdateRole");

    if (!mdp.value) {
      await serv.put(
        `/api/users/${id.value}`,
        {
          users: {
            username: username.value,
            email: email.value,
            status: role.value,
          },
        },
      );
    } else if (!role.value) {
      await serv.put(
        `/api/users/${id.value}`,
        {
          users: {
            username: username.value,
            email: email.value,
            mdp: mdp.value,
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
            status: role.value,
          },
        },
      );
    }

    btnreturnMdp.classList.add("hide");
    btnShowMdp.classList.remove("hide");
    btnreturnRole.classList.add("hide");
    btnShowRole.classList.remove("hide");

    input.classList.remove("hide");
    select.classList.add("hide");
    mdp.classList.add("hide");

    // Affiche une alerte de confirmation
    successMessage.value = "User updated successfully.";
    Notif("Success");
    cancel(); // Réinitialise les données du formulaire
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

// Méthode pour supprimer un utilisateur récupéré
const deleteUser = async () => {
  try {
    if (!id.value) {
      error.value = "No user to delete";
      return;
    }

    // Appel à l'API pour supprimer l'utilisateur récupéré
    await serv.delete(`/api/users/${id.value}`);

    // Affiche une alerte de confirmation
    successMessage.value = "User deleted successfully";
    Notif("Success");

    // Réinitialise le formulaire après la suppression
    error.value = "";

    cancel();
  } catch (error) {
    error.value = "Error deleting user";
  }
};

const showDeleteConfirmationModal = () => {
  // Affiche le modal de confirmation
  new Modal(document.getElementById("confirmationModal")).show();
};

const showContaineUpdate = () => {
  const containerCreate = document.getElementById("containerCreate");
  const containerUpdate = document.getElementById("containerUpdate");
  const btnModalCreate = document.getElementById("btnModalCreate");
  const btnModalUpdate = document.getElementById("btnModalUpdate");

  containerCreate.classList.add("hide");
  containerUpdate.classList.remove("hide");
  btnModalCreate.classList.add("unselect");
  btnModalUpdate.classList.remove("unselect");
};

const showContaineCreate = () => {
  const containerCreate = document.getElementById("containerCreate");
  const containerUpdate = document.getElementById("containerUpdate");
  const btnModalCreate = document.getElementById("btnModalCreate");
  const btnModalUpdate = document.getElementById("btnModalUpdate");

  containerCreate.classList.remove("hide");
  containerUpdate.classList.add("hide");
  btnModalCreate.classList.remove("unselect");
  btnModalUpdate.classList.add("unselect");
};

const showUpdateMdp = () => {
  const mdp = document.getElementById("mdpInput");
  const btnShow = document.getElementById("showUpdateMdp");
  const btnreturn = document.getElementById("hideUpdateMdp");
  mdp.classList.remove("hide");
  btnreturn.classList.remove("hide");
  btnShow.classList.add("hide");
};

const hideUpdateMdp = () => {
  const mdp = document.getElementById("mdpInput");
  const btnShow = document.getElementById("showUpdateMdp");
  const btnreturn = document.getElementById("hideUpdateMdp");
  mdp.classList.add("hide");
  btnreturn.classList.add("hide");
  btnShow.classList.remove("hide");
};

const showUpdateRole = () => {
  const input = document.getElementById("roleInput");
  const select = document.getElementById("roleSelect");
  const btnShow = document.getElementById("showUpdateRole");
  const btnreturn = document.getElementById("hideUpdateRole");
  input.classList.add("hide");
  select.classList.remove("hide");
  btnreturn.classList.remove("hide");
  btnShow.classList.add("hide");
};

const hideUpdateRole = () => {
  const input = document.getElementById("roleInput");
  const select = document.getElementById("roleSelect");
  const btnShow = document.getElementById("showUpdateRole");
  const btnreturn = document.getElementById("hideUpdateRole");
  input.classList.remove("hide");
  select.classList.add("hide");
  btnreturn.classList.add("hide");
  btnShow.classList.remove("hide");
};

const confirmDeleteUser = () => {
  // Confirme la suppression et appelle deleteUser()
  deleteUser();
};

const cancel = () => {
  id.value = "";
  username.value = "";
  newUsername.value = "";
  searchUsername.value = "";
  searchID.value = "";
  searchEmail.value = "";
  newEmail.value = "";
  email.value = "";
  mdp.value = "";
  role.value = "";
  newRole.value = "";
  selectedTeam.value = null;
  error.value = "";
};

// Récupère les informations de l'utilisateur connecté grâce à son userId
onMounted(async () => {
  try {
    const response = await serv.get(`/api/users/${props.userId}`);
    currentUserRole.value = response.data.data.status; // Stocke le rôle de l'utilisateur

    // Si le rôle n'est pas "general manager", on force le rôle à employee
    if (currentUserRole.value !== "general manager") {
      newRole.value = "employee";
    }

    // Récupère les équipes liées à l'utilisateur connecté s'il est admin
    await fetchAdminTeams();
  } catch (error) {
    console.error("Error retrieving user information :", error);
  }
});
</script>
