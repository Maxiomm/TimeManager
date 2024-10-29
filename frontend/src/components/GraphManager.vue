<template>
  <div>
    <!-- Bouton pour basculer entre la recherche par équipe et la recherche manuelle -->
    <div v-if="isGeneralManager" class="switch-button">
      <button @click="toggleSearchMode" class="btn btn-switch btn-secondary">
        {{ isTeamSearch ? "Manual Search" : "Team Search" }}
      </button>
    </div>

    <!-- Recherche par équipes (visible si isTeamSearch est true) -->
    <div v-if="isTeamSearch">
      <div class="user-input">
        <select
            v-model="selectedTeam"
            @change="fetchTeamUsers"
            class="form-control input-small"
        >
          <option value="" disabled>Select a team</option>
          <option v-for="team in teams" :key="team.id" :value="team.id">
            {{ team.name }}
          </option>
        </select>

        <select
            v-if="teamUsers.length > 0"
            v-model="selectedUser"
            @change="setUserId"
            class="form-control input-small"
        >
          <option value="" disabled>Select a user</option>
          <option v-for="user in teamUsers" :key="user.id" :value="user.id">
            {{ user.username }}
          </option>
        </select>
      </div>
    </div>

    <!-- Recherche manuelle (visible si isTeamSearch est false) -->
    <div v-else class="user-input">
      <input
          v-model="username"
          type="text"
          placeholder="User's username"
          class="input-small input_search"
      />
      <input
        v-model="email"
        type="email"
        placeholder="User's email"
        class="input_search input-small"
      />

      <div @click="fetchUserData">
        <i class="fas fa-search search"></i>
      </div>
    </div>

    <!-- Boutons pour sélectionner le graphique à afficher -->
    <div class="button-group" v-if="selectedUserId">
      <button @click="setCurrentGraph('calendar')" class="">
        <i class="fas fa-calendar"></i>
      </button>
      <button @click="setCurrentGraph('worktime')" class="">
        <i class="fas fa-bar-chart"></i>
      </button>
      <button @click="setCurrentGraph('category')" class="">
        <i class="fas fa-pie-chart"></i>
      </button>
    </div>

    <!-- Affichage conditionnel des graphiques selon le bouton cliqué -->
    <section
      class="chart-section"
      v-if="selectedUserId && currentGraph === 'calendar'"
    >
      <UserCalendar :user-id="selectedUserId" :key="chartKey" />
    </section>

    <section
      class="chart-section"
      v-if="selectedUserId && currentGraph === 'worktime'"
    >
      <WorkTimeChart :user-id="selectedUserId" :key="chartKey" />
    </section>

    <section
      class="chart-section"
      v-if="selectedUserId && currentGraph === 'category'"
    >
      <CategoryChart
        :user-id="selectedUserId"
        :key="chartKey"
        :is-manager-view="true"
      />
    </section>
  </div>

  <!-- Modal de Error -->
  <div id="notifError" class="notif-container notif-close">
    <div class="notif">
      <i class="fas fa-circle-exclamation  wrong-color icon_notif"></i>
      <p class="text_notif"> {{ errorMessage }}</p>
      <i @click="NotifClose('Error')" class="fas fa-x icon-close"></i>
    </div>
  </div>

  <!-- Notif de Info -->
  <div id="notifInfo" class="notif-container notif-close">
    <div class="notif">
      <i class="fas fa-circle-info info-color icon_notif"></i>
      <p class="text_notif"> {{ infoMessage }}</p>
      <i @click="NotifClose('Info')" class="fas fa-x icon-close"></i>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import serv from "../Instance/axios";

// Importation des composants de graphiques
import WorkTimeChart from "./WorkTimeChart.vue";
import CategoryChart from "./CategoryChart.vue";
import UserCalendar from "./UserCalendar.vue";

// Reçoit l'ID utilisateur comme prop depuis SideNavBar
const props = defineProps({
  userId: {
    type: Number,
    required: true,
  },
});

// Variables réactives pour l'email, le username et l'ID de l'utilisateur
const email = ref(null);
const username = ref(null);
const selectedUserId = ref(null);
const currentGraph = ref("worktime");
const teams = ref([]);
const teamUsers = ref([]);
const selectedTeam = ref("");
const selectedUser = ref("");
const isGeneralManager = ref(false);
const chartKey = ref(0);
const errorMessage = ref("")
const infoMessage = ref("")
const isTeamSearch = ref(true); // Par défaut, on est en mode "Recherche par équipes"

const Notif = (typeNotif) => {
  const id = "notif" + typeNotif
  const notif = document.getElementById(id)
  const AllNotif = document.querySelectorAll('.notif-container')

  AllNotif.forEach(function (each){
    each.classList.add('notif-close')
    each.classList.remove('notif-open')
  })

  notif.classList.toggle('notif-close')
  notif.classList.toggle('notif-open')

  setTimeout(function () {
    notif.classList.add('notif-close')
    notif.classList.remove('notif-open')
  }, 3000)
}

const NotifClose = (typeNotif) => {
  const id = "notif" + typeNotif
  const notif = document.getElementById(id)
  notif.classList.toggle('notif-close')
  notif.classList.toggle('notif-open')
}

// Fonction pour récupérer le rôle de l'utilisateur connecté via `props.userId`
const fetchCurrentUserRole = async () => {
  try {
    const response = await serv.get(`/api/users/${props.userId}`);

    const userRole = response.data.data.status;

    // Vérifie si l'utilisateur est un general manager ou un manager
    if (userRole === "general manager" || userRole === "manager") {
      isGeneralManager.value = userRole === "general manager"; // Toujours vérifier s'il est general manager
      await fetchTeams(); // Récupérer les équipes liées à l'utilisateur
    }
  } catch (error) {
    console.error(
        "Erreur lors de la récupération du rôle de l'utilisateur :",
        error
    );
  }
};

// Fonction pour récupérer les équipes liées au manager
const fetchTeams = async () => {
  try {
    const response = await serv.get(`/api/team/admin/${props.userId}`);
    teams.value = response.data.data; // Stocker les équipes récupérées

    if(teams.value.length === 0){
      infoMessage.value = "You have no teams"
      Notif("Info")
    }
  } catch (error) {
    console.error("Erreur lors de la récupération des équipes :", error);
  }
};

// Fonction pour récupérer les utilisateurs d'une équipe sélectionnée
const fetchTeamUsers = async () => {
  try {
    const response = await serv.get(
        `/api/teamlink/team/${selectedTeam.value}`
    );

    // Récupérer les détails complets des utilisateurs
    const usersData = await Promise.all(
        response.data.data.map(async (teamLink) => {
          const userResponse = await serv.get(`/api/users/${teamLink.user_id}`);
          return userResponse.data.data; // Retourne les détails de l'utilisateur
        })
    );

    teamUsers.value = usersData; // Stocker les utilisateurs récupérés
  } catch (error) {
    console.error(
        "Erreur lors de la récupération des utilisateurs de l'équipe :",
        error
    );
  }
};

// Fonction pour définir l'utilisateur sélectionné
const setUserId = () => {
  selectedUserId.value = selectedUser.value;
};

// Fonction pour récupérer les données de l'utilisateur via l'email et le nom d'utilisateur
const fetchUserData = async () => {
  // Réinitialiser l'utilisateur précédent
  selectedUserId.value = null;

  try {
    if(email.value !== null && username.value !== null){
      const response = await serv.get(
          `/api/users?email=${email.value}&username=${username.value}`
      );
      if (response.data && response.data.data) {
        const userData = response.data.data;
        selectedUserId.value = userData.id;
      } else {
        errorMessage.value = "User not found"
        Notif('Error')

      }
    }else{
      console.log()
      errorMessage.value = "Please enter either a valid email and username."
      Notif('Error')
    }
  } catch (err) {
    errorMessage.value = err.response.data.error
    Notif("Error")
  }
};


// Fonction pour définir et sauvegarder le graphique courant dans localStorage
const setCurrentGraph = (graph) => {
  currentGraph.value = graph;
  localStorage.setItem("selectedGraph", graph);
};

const toggleSearchMode = () => {
  isTeamSearch.value = !isTeamSearch.value;

  if (isTeamSearch.value) {
    // Réinitialiser les inputs manuels lorsque on passe à la recherche par équipe
    username.value = null;
    email.value = null;

    // Réinitialiser les sélections d'équipe et d'utilisateur
    selectedTeam.value = "";
    teamUsers.value = [];
    selectedUser.value = "";
    selectedUserId.value = null;
  } else {
    // Réinitialiser les sélections d'équipe et d'utilisateur lorsque on passe à la recherche manuelle
    selectedTeam.value = "";
    selectedUser.value = "";
    teamUsers.value = [];
    selectedUserId.value = null;
  }
};

// Watcher pour surveiller les changements dans `selectedUser` et actualiser automatiquement le graphique
watch(selectedUser, (newUserId) => {
  if (newUserId) {
    selectedUserId.value = newUserId;
    chartKey.value += 1; // Change la clé pour forcer le rechargement des graphiques
  }
});

// Au montage du composant, on récupère le rôle de l'utilisateur et les équipes s'il est manager
onMounted(() => {
  fetchCurrentUserRole();
  const savedGraph = localStorage.getItem("selectedGraph");
  if (savedGraph) {
    currentGraph.value = savedGraph;
  }
});
</script>
