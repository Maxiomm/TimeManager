<template>
  <div>
    <h2 class="title-page">Team Management</h2>

    <div class="content-container mx-auto">
      <!-- Formulaire de création d'équipe -->
      <div class="team-form mt-4 d-flex align-items-center">
        <input
          v-model="newTeamName"
          id="team-name"
          type="text"
          placeholder="Enter team name"
          class="form-control me-2"
        />
        <button @click="createTeam" class="btn btn-primary">
          Create New Team
        </button>
      </div>

      <!-- Liste des équipes liées au manager/general manager -->
      <div v-if="teams.length > 0" class="team-list mt-5">
        <h5 class="text-center">Your Teams</h5>
        <ul class="list-group">
          <li
            v-for="team in teams"
            :key="team.id"
            class="list-group-item"
            @click="openModal(team)"
          >
            <strong>{{ team.name }}</strong>
            <p class="mb-1">Users in team: {{ team.userCount }}</p>
          </li>
        </ul>
      </div>

      <p v-if="teams.length === 0" class="mt-3">You have no team.</p>

      <!-- Modal de gestion d'équipe -->
      <div
        class="modal fade"
        id="teamModal"
        tabindex="-1"
        aria-labelledby="teamModalLabel"
        aria-hidden="true"
        v-if="selectedTeam"
      >
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="teamModalLabel">
                Manage Team: {{ selectedTeam.name }}
              </h5>
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="modal"
                aria-label="Close"
              ></button>
            </div>
            <div class="modal-body">
              <label class="text-white" for="team-name-update">Team Name</label>
              <input
                v-model="selectedTeam.name"
                id="team-name-update"
                type="text"
                placeholder="Enter new team name"
                class="form-control"
              />

              <div class="mt-4">
                <p class="text-white" v-if="teamUsers.length > 0">
                  Users in this team
                </p>

                <!-- Champ de recherche pour les utilisateurs d'une équipe -->
                <input
                  v-if="teamUsers.length > 0"
                  v-model="searchTeamUserQuery"
                  @input="filterTeamUsers"
                  type="text"
                  placeholder="Search by username"
                  class="form-control mb-3"
                />

                <ul v-if="filteredTeamUsers.length > 0" class="list-group">
                  <li
                    class="list-group-item font-weight-bold no-hover"
                  >
                    <span style="width: 40%"><strong>Email</strong></span>
                    <span style="width: 30%"><strong>Username</strong></span>
                    <span style="width: 20%"><strong>Role</strong></span>
                    <span style="width: 10%"></span>
                  </li>

                  <li
                    v-for="user in filteredTeamUsers"
                    :key="user.id"
                    class="list-group-item"
                  >
                    <span style="width: 40%; overflow: hidden">{{ user.email }}</span>
                    <span style="width: 30%; overflow: hidden; margin-left: 5px">{{ user.username }}</span>
                    <span style="width: 20%; overflow: hidden; margin-left: 5px">{{ user.status }}</span>
                    <i
                      class="fas fa-times text-danger"
                      style="cursor: pointer; width: 10%; text-align: center"
                      @click="removeUserFromTeam(user)"
                      title="Remove user"
                    ></i>
                  </li>
                </ul>

                <p
                  v-if="filteredTeamUsers.length === 0"
                  class="text-center mt-3 text-white"
                >
                  No users found in this team.
                </p>
              </div>
            </div>

            <div class="team modal-footer">
              <button
                type="button"
                class="btn btn-secondary"
                data-bs-dismiss="modal"
                @click="closeModal"
              >
                Cancel
              </button>

              <div class="action-buttons">
                <button
                  type="button"
                  class="btn btn-primary me-2"
                  @click="openAddUserModal"
                >
                  Add User
                </button>

                <button
                  type="button"
                  class="btn btn-warning me-2"
                  @click="updateTeam"
                >
                  Update
                </button>

                <button
                  type="button"
                  class="btn btn-danger"
                  @click="deleteTeam(selectedTeam.id)"
                >
                  Delete
                </button>
              </div>
            </div>
          </div>

          <!-- Modal pour ajouter un utilisateur -->
          <div
            class="modal modalAddUser fade"
            id="addUserModal"
            tabindex="-1"
            aria-labelledby="addUserModalLabel"
            aria-hidden="true"
          >
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="addUserModalLabel">
                    Add User to Team: {{ selectedTeam.name }}
                  </h5>
                </div>

                <div class="modal-body">
                  <!-- Champ de recherche -->
                  <input
                    v-model="searchQuery"
                    @input="filterUsers"
                    type="text"
                    placeholder="Search by username"
                    class="form-control mb-3"
                  />

                  <ul class="list-group">
                    <li
                      v-for="user in filteredUsers"
                      :key="user.id"
                      class="list-group-item"
                      @click="addUserToTeam(user)"
                    >
                      <span>{{ user.username }}</span>
                      <span class="float-end">{{ user.email }}</span>
                    </li>
                  </ul>
                </div>

                <div class="modal-footer">
                  <button
                    type="button"
                    class="btn btn-secondary"
                    data-bs-dismiss="modal"
                    @click="closeAddUserModal"
                  >
                    Close
                  </button>
                </div>
              </div>
            </div>
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
        <p class="text_notif">{{ errorMessage }}</p>
        <i @click="NotifClose('Error')" class="fas fa-x icon-close"></i>
      </div>
    </div>

    <!-- Notif de Info -->
    <div id="notifInfo" class="notif-container notif-close">
      <div class="notif">
        <i class="fas fa-circle-info info-color icon_notif"></i>
        <p class="text_notif">{{ infoMessage }}</p>
        <i @click="NotifClose('Info')" class="fas fa-x icon-close"></i>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from "vue";
import serv from "../Instance/axios";
import { Modal } from "bootstrap";

const teams = ref([]);
const selectedTeam = ref(null);
const allUsers = ref([]);
const teamUsers = ref([]);
const newTeamName = ref("");
const errorMessage = ref("");
const successMessage = ref("");
const infoMessage = ref("");
const adminId = localStorage.getItem("idUser");
const filteredUsers = ref([]); // Stocke les utilisateurs filtrés
const searchQuery = ref(""); // Stocke la requête de recherche
const filteredTeamUsers = ref([]);
const searchTeamUserQuery = ref("");

let teamModal = null;

let addUserModal = null;

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

// Fonction pour récupérer les équipes liées à l'utilisateur (manager/general manager)
const fetchTeams = async () => {
  try {
    const response = await serv.get(`/api/team/admin/${adminId}`);

    // Associer le nombre d'utilisateurs à chaque équipe
    const teamData = await Promise.all(
      response.data.data.map(async (team) => {
        const userCountResponse = await serv.get(
          `/api/teamlink/team/${team.id}`
        );
        return {
          ...team,
          userCount: userCountResponse.data.data.length, // Compte des utilisateurs dans l'équipe
        };
      })
    );

    teams.value = teamData;
  } catch (error) {
    errorMessage.value = "Failed to load teams.";
    Notif("Error");
  }
};

// Fonction pour créer une équipe
const createTeam = async () => {
  if (newTeamName.value === "") {
    Notif("Error");
    errorMessage.value = "Team name cannot be empty";
  } else {
    try {
      await serv.post(
        "/api/team",
        {
          teams: {
            name: newTeamName.value,
            admin_id: adminId,
          },
        }
      );
      successMessage.value = "Team created successfully!";
      newTeamName.value = "";

      await fetchTeams(); // Recharger les équipes après la création
      Notif("Success");
    } catch (err) {
      errorMessage.value = "Failed to create the team. Please try again.";
      Notif("Error");
    }
  }
};

// Fonction pour ouvrir la modal pour ajouter un utilisateur
const openAddUserModal = async () => {
  // Récupérer tous les utilisateurs
  try {
    const response = await serv.get(`/api/allUsers`);

    // Filtrer les utilisateurs pour exclure ceux qui sont déjà dans l'équipe
    allUsers.value = response.data.data.filter((user) => {
      return !teamUsers.value.some((teamUser) => teamUser.id === user.id);
    });

    // Initialiser la liste filtrée avec tous les utilisateurs
    filteredUsers.value = allUsers.value;
    searchQuery.value = "";
  } catch (error) {
    console.error("Failed to fetch users:", error);
  }

  await nextTick();
  const modalElement = document.getElementById("addUserModal");
  addUserModal = new Modal(modalElement);
  addUserModal.show();
};

// Fonction pour fermer la modal d'ajout d'utilisateur
const closeAddUserModal = () => {
  if (addUserModal) {
    addUserModal.hide();
  }
};

// Fonction pour filtrer les utilisateurs en fonction de la recherche
const filterUsers = () => {
  if (searchQuery.value.trim() === "") {
    filteredUsers.value = allUsers.value; // Si la recherche est vide, montrer tous les utilisateurs
  } else {
    filteredUsers.value = allUsers.value.filter((user) =>
      user.username.toLowerCase().includes(searchQuery.value.toLowerCase())
    );
  }
};

// Fonction pour filtrer les utilisateurs dans une équipe
const filterTeamUsers = () => {
  if (searchTeamUserQuery.value.trim() === "") {
    filteredTeamUsers.value = teamUsers.value;
  } else {
    filteredTeamUsers.value = teamUsers.value.filter((user) =>
      user.username
        .toLowerCase()
        .includes(searchTeamUserQuery.value.toLowerCase())
    );
  }
};

// Fonction pour ajouter un utilisateur à une équipe
const addUserToTeam = async (user) => {
  try {
    await serv.post(
      "/api/teamlink",
      {
        team_link: {
          user_id: user.id, // ID de l'utilisateur à ajouter
          team_id: selectedTeam.value.id, // ID de l'équipe sélectionnée
        },
      }
    );

    successMessage.value = `User ${user.username} added to team successfully!`;

    // Ajouter directement l'utilisateur à la liste `teamUsers` sans recharger
    teamUsers.value.push({
      id: user.id,
      username: user.username,
      email: user.email,
      status: user.status,
    });

    await fetchTeams();

    // Fermer la modal d'ajout d'utilisateur
    closeAddUserModal();

    Notif("Success");
  } catch (error) {
    errorMessage.value = "Failed to add user to team.";
    Notif("Error");
  }
};

// Fonction pour supprimer un utilisateur de l'équipe
const removeUserFromTeam = async (user) => {
  try {
    // Récupérer le teamlink correspondant à l'utilisateur et à la team sélectionnée
    const response = await serv.get(
      `/api/teamlink/team/${selectedTeam.value.id}`);

    // Trouver le teamlink qui correspond à l'utilisateur à supprimer
    const teamLink = response.data.data.find(
      (link) => link.user_id === user.id
    );

    if (!teamLink) {
      errorMessage.value = `User ${user.username} is not in this team.`;
      return;
    }

    // Supprimer le teamlink
    await serv.delete(`/api/teamlink/${teamLink.id}`);

    successMessage.value = `User ${user.username} removed from team successfully!`;

    // Supprimer l'utilisateur de la liste locale sans recharger la page
    teamUsers.value = teamUsers.value.filter((u) => u.id !== user.id);

    filteredTeamUsers.value = teamUsers.value;

    // Recharger les équipes pour mettre à jour le nombre d'utilisateurs
    fetchTeams();

    Notif("Success");
  } catch (error) {
    errorMessage.value = `Failed to remove user ${user.username} from team.`;
    Notif("Error");
  }
};

// Fonction pour ouvrir la modal et sélectionner une équipe
const openModal = async (team) => {
  selectedTeam.value = { ...team };

  // Récupérer les utilisateurs liés à l'équipe
  try {
    const response = await serv.get(`/api/teamlink/team/${team.id}`);

    // Pour chaque teamlink, récupérer les détails de l'utilisateur
    const usersData = await Promise.all(
      response.data.data.map(async (teamLink) => {
        const userResponse = await serv.get(`/api/users/${teamLink.user_id}`);
        return userResponse.data.data; // Retourne les détails de l'utilisateur
      })
    );

    teamUsers.value = usersData; // Stocker les informations des utilisateurs
    filteredTeamUsers.value = teamUsers.value;
    searchTeamUserQuery.value = "";
  } catch (error) {
    console.error("Failed to fetch users for team:", error);
  }

  await nextTick(); // Attendre que le DOM soit mis à jour

  // Initialise une nouvelle instance de Modal chaque fois que l'on ouvre
  const modalElement = document.getElementById("teamModal");
  teamModal = new Modal(modalElement);
  teamModal.show();
};

// Fonction pour fermer la modal
const closeModal = () => {
  selectedTeam.value = null;
  teamUsers.value = [];

  if (teamModal) {
    teamModal.hide();
  }

  fetchTeams();
};

// Fonction pour mettre à jour une équipe
const updateTeam = async () => {
  if (!selectedTeam.value || selectedTeam.value.name.trim() === "") {
    errorMessage.value = "Please provide a valid team name.";
    Notif("Error");
  }

  try {
    await serv.put(
      `/api/team/${selectedTeam.value.id}`,
      {
        teams: {
          name: selectedTeam.value.name,
        },
      }
    );

    successMessage.value = "Team updated successfully!";
    closeModal();
    await fetchTeams(); // Recharge la liste des équipes après la modification
    Notif("Success");
  } catch (err) {
    // errorMessage.value = "Failed to update the team. Please try again.";
    const type = typeof err.response.data.errors;
    if (type === "object") {
      const keys = Object.keys(err.response.data.errors);
      const value = Object.values(err.response.data.errors);
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
      }
      errorMessage.value = sentenceError;
    } else {
      errorMessage.value = err.response.data.errors;
    }
    Notif("Error");
  }
};

// Fonction pour supprimer une équipe
const deleteTeam = async (teamId) => {
  try {
    // Étape 1 : Récupérer tous les utilisateurs associés à l'équipe
    const teamUsersResponse = await serv.get(`/api/teamlink/team/${teamId}`);

    const teamUsers = teamUsersResponse.data.data;

    // Étape 2 : Supprimer chaque teamlink pour les utilisateurs dans cette équipe
    await Promise.all(
      teamUsers.map(async (teamLink) => {
        await serv.delete(`/api/teamlink/${teamLink.id}`);
      })
    );

    // Étape 3 : Supprimer l'équipe elle-même
    await serv.delete(`/api/team/${teamId}`);
    successMessage.value = "Team deleted successfully!";
    closeModal();
    await fetchTeams();
    Notif("Success");
  } catch (err) {
    errorMessage.value = "Failed to delete the team. Please try again.";
    Notif("Error");
    successMessage.value = "";
    Notif("Error");
  }
};

// Charger les équipes lors du montage du composant
onMounted(() => {
  fetchTeams();
});
</script>

<style scoped>
.content-container {
  max-width: 600px;
  margin: 0 auto;
  padding: 0 15px;
}

.team-list {
  margin-top: 20px;
}

.team-actions {
  display: flex;
  gap: 10px;
  margin-top: 10px;
}

.list-group-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: transform 0.3s ease; /* Transition pour un effet fluide */
}

.list-group-item:hover {
  cursor: pointer; /* Change le curseur en pointeur */
  transform: scale(1.01); /* Applique un zoom lors du survol */
  box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.4); /* Ajoute un léger ombrage pour donner de la profondeur */
}

.team-actions button {
  opacity: 0; /* Les boutons sont cachés par défaut */
  transition: opacity 0.3s ease; /* Transition fluide pour les boutons */
}

.list-group-item:hover .team-actions button {
  opacity: 1; /* Affiche les boutons lors du survol */
}

.no-hover {
  pointer-events: none; /* Désactive l'interaction utilisateur */
  background-color: #f1f3f5;
}

.modal-body label[for="team-name-update"],
.modal-body p {
  color: white; /* Change la couleur du texte en blanc */
}

.modal-footer {
  display: flex;
  justify-content: space-between; /* Aligne le contenu en colonne */
  align-items: center; /* Aligne les éléments à droite */
  padding: 10px 15px;
}

.modal-footer .btn-secondary {
  border-radius: 15px; /* Bords arrondis */
  padding: 5px 10px; /* Réduit le padding pour un bouton plus petit */
  font-size: 0.875rem; /* Taille de la police réduite */
  width: auto; /* La largeur s'adapte au contenu */
  height: 35px;
}

.action-buttons {
  display: flex;
  gap: 10px; /* Espace entre les boutons Add User, Update, Delete */
}

.action-buttons .btn {
  border-radius: 15px; /* Bords arrondis pour les boutons */
  padding: 5px 15px; /* Taille compacte */
  font-size: 0.875rem; /* Taille de la police réduite */
  height: 35px; /* Hauteur fixe pour les boutons */
  white-space: nowrap;
  width: auto;
}

.team-form .btn {
  border-radius: 5px;
}
</style>
