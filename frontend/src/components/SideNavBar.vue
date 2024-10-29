<template>
  <!-- Modal de Continue additionnal hours -->
  <div
    class="modal fade"
    id="startModal"
    tabindex="-1"
    aria-labelledby="startModalLanel"
    aria-hidden="true"
  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="startModalLanel">Additional Hours</h5>

          <button
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>

        <div class="modal-body text-white">
          Your 8 hour duration is over for today. <br />
          Do you want to work overtime?
        </div>

        <div class="flex footer_modal">
          <button
            type="button"
            @click="clockContinue"
            class="btn btn-primary"
            data-bs-dismiss="modal"
          >
            Continue
          </button>

          <button
            type="button"
            @click="clockOut"
            class="btn btn-danger"
            data-bs-dismiss="modal"
          >
            Stop
          </button>
        </div>
      </div>
    </div>
  </div>

  <div class="container">
    <!-- Barre de navigation latérale -->
    <div v-if="!isMobile" class="navbar" id="nav">
      <div id="basicUsage" v-if="token" class="timer">00:00:00</div>

      <div v-if="token" class="icon" @click="clockIn" id="startBtn">
        <div class="icon-wrapper">
          <i
            class="fas fa-play-circle"
            style="color: #1e7e34; font-size: 30px"
          ></i>
        </div>
        <div class="icon-text">Start Day</div>
      </div>

      <div v-if="token" class="icon hide" @click="clockOut" id="stopBtn">
        <div class="icon-wrapper">
          <i
            class="fas fa-stop-circle"
            style="color: #ea0a0a; font-size: 30px"
          ></i>
        </div>
        <div class="icon-text">Stop Day</div>
      </div>

      <div
        v-if="token"
        class="icon page_icon"
        id="account"
        @click="showComponent('account', $event)"
      >
        <div class="icon-wrapper">
          <i class="fas fa-user"></i>
        </div>
        <div class="icon-text">Account</div>
      </div>

      <div
        v-if="!token"
        class="icon page_icon"
        id="authentification"
        @click="showComponent('authentification', $event)"
      >
        <div class="icon-wrapper">
          <i class="fas fa-user"></i>
        </div>
        <div class="icon-text">Log in</div>
      </div>

      <div
        v-if="token"
        class="icon page_icon"
        id="calendar"
        @click="showComponent('calendar', $event)"
      >
        <div class="icon-wrapper">
          <i class="fas fa-calendar"></i>
        </div>
        <div class="icon-text">Calendar</div>
      </div>

      <div
        v-if="token"
        class="icon page_icon"
        id="worktimeChart"
        @click="showComponent('worktimeChart', $event)"
      >
        <div class="icon-wrapper">
          <i class="fas fa-bar-chart"></i>
        </div>
        <div class="icon-text">Worktime</div>
      </div>

      <div
        v-if="token"
        class="icon page_icon"
        id="pieChart"
        @click="showComponent('pieChart', $event)"
      >
        <div class="icon-wrapper">
          <i class="fas fa-pie-chart"></i>
        </div>
        <div class="icon-text">Categories</div>
      </div>

      <div
        v-if="status !== 'employee' && token"
        id="userManager"
        @click="showComponent('userManager', $event)"
        class="icon page_icon"
      >
        <div class="icon-wrapper">
          <i class="fas fa-people-group"></i>
        </div>
        <div class="icon-text">Manage users</div>
      </div>

      <div
        v-if="token"
        id="teamManager"
        @click="showComponent('teamManager', $event)"
        class="icon page_icon"
      >
        <div class="icon-wrapper">
          <i class="fas fa-project-diagram"></i>
        </div>
        <div class="icon-text">Manage teams</div>
      </div>

      <div
        v-if="status !== 'employee' && token"
        id="graphManage"
        @click="showComponent('graphManage', $event)"
        class="icon page_icon"
      >
        <div class="icon-wrapper">
          <i class="fas fa-eye"></i>
        </div>
        <div class="icon-text">Dashboards</div>
      </div>

      <div
        v-if="token"
        class="icon page_icon"
        id="faq"
        @click="showComponent('faq', $event)"
      >
        <div class="icon-wrapper">
          <i class="fas fa-question-circle"></i>
        </div>
        <div class="icon-text">FAQ</div>
      </div>

      <div v-if="token" class="icon page_icon" @click="LogOut">
        <div class="icon-wrapper">
          <i class="fas fa-xmark-circle" style="color: red"></i>
        </div>
        <div class="icon-text" style="color: red">Log out</div>
      </div>
    </div>

    <!-- Tab bar visible uniquement sur mobile -->
    <div v-if="isMobile" class="tab-bar" id="nav">
      <div id="basicUsage" v-if="token" class="timer">00:00:00</div>

      <div v-if="!token" class="tab-item icon page_icon" id="authentification">
        <div class="icon-wrapper">
          <i
            class="fas fa-user"
            @click="showComponent('authentification', $event)"
          ></i>
        </div>
      </div>

      <div v-if="!token" class="tab-item icon page_icon">
        <div class="icon-wrapper">
          <i class="fas fa-user-plus" @click="goSignIn"></i>
        </div>
      </div>

      <div v-if="token" class="tab-item icon" @click="clockIn" id="startBtn">
        <div class="icon-wrapper">
          <i
            class="fas fa-play-circle"
            style="color: #1e7e34; font-size: 30px"
          ></i>
        </div>
      </div>

      <div
        v-if="token"
        class="tab-item icon hide"
        @click="clockOut"
        id="stopBtn"
      >
        <div class="icon-wrapper">
          <i
            class="fas fa-stop-circle"
            style="color: #ea0a0a; font-size: 30px"
          ></i>
        </div>
      </div>

      <div
        v-if="token"
        class="tab-item icon"
        @click="showComponent('account', $event)"
      >
        <div class="icon-wrapper">
          <i class="fas fa-user"></i>
        </div>
      </div>

      <div
        v-if="token"
        class="tab-item icon"
        @click="showComponent('worktimeChart', $event)"
      >
        <div class="icon-wrapper">
          <i class="fas fa-bar-chart"></i>
        </div>
      </div>

      <div
        v-if="status !== 'employee' && token"
        id="userManager"
        @click="showComponent('userManager', $event)"
        class="tab-item icon page_icon"
      >
        <div class="icon-wrapper">
          <i class="fas fa-people-group"></i>
        </div>
      </div>

      <div
        v-if="token"
        id="teamManager"
        @click="showComponent('teamManager', $event)"
        class="tab-item icon page_icon"
      >
        <div class="icon-wrapper">
          <i class="fas fa-project-diagram"></i>
        </div>
      </div>

      <div
        v-if="token"
        class="tab-item icon"
        @click="showComponent('faq', $event)"
      >
        <div class="icon-wrapper">
          <i class="fas fa-question-circle"></i>
        </div>
      </div>

      <div v-if="token" class="tab-item icon page_icon" @click="LogOut">
        <div class="icon-wrapper">
          <i class="fas fa-xmark-circle" style="color: red"></i>
        </div>
      </div>
    </div>

    <!-- Affichage dynamique des composants selon l'icône sélectionnée -->
    <div class="content">
      <component :is="activeComponentComponent" :user-id="UserID" />
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
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import serv from "../Instance/axios";
import UserAuthentification from "./UserAuthentification.vue";
import UserManager from "./UserManager.vue";
import UserCalendar from "./UserCalendar.vue";
import UserAccount from "./UserAccount.vue";
import WorktimeChart from "./WorkTimeChart.vue";
import GraphManage from "@/components/GraphManager.vue";
import createUser from "@/components/CreateUser.vue";
import FAQ from "./FAQ.vue";
import PieChart from "./CategoryChart.vue";
import TeamManager from "./TeamManager.vue";
import { Timer } from "easytimer.js";
import { Modal } from "bootstrap";

const activeComponent = ref("faq");
const workingtime = ref(null);
const token = localStorage.getItem("token");
const UserID = localStorage.getItem("idUser");
const status = ref(localStorage.getItem("status"));
const timer = new Timer();
const infoMessage = ref("");
const isMobile = ref(false);

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

timer.addEventListener("secondsUpdated", function () {
  const element = document.querySelector("#basicUsage");
  if (element) {
    element.innerHTML = timer.getTimeValues().toString();
  }
});

// Fonction pour fermer toutes les modals ouvertes
const closeAllModals = () => {
  const modals = document.querySelectorAll(".modal.show");
  modals.forEach((modal) => {
    const modalInstance = Modal.getInstance(modal);
    if (modalInstance) {
      modalInstance.hide();
    }
  });
};

// Modifier la fonction showComponent pour fermer les modals avant de changer de vue
const showComponent = (componentName, event) => {
  const icons = document.querySelectorAll(".page_icon");

  icons.forEach(function (icon) {
    icon.classList.remove("click");
  });

  const clickedElement = event.target.closest(".icon");

  setTimeout(() => {
    clickedElement.classList.toggle("click");
  }, 370);
  closeAllModals(); // Ferme toutes les modals ouvertes
  activeComponent.value = componentName;
  localStorage.setItem("activeComponent", componentName);
};

// Fonction pour Clock Out
const clockOut = async () => {
  const startElement = document.getElementById("startBtn");
  const stopElement = document.getElementById("stopBtn");

  const id = workingtime.value.data.id;
  if (!workingtime.value || !id) {
    console.error(
      "No active work session or missing session ID for clock out."
    );
    return;
  }

  const workingTimeParams = {
    id: id,
    start: workingtime.value.start,
    end: new Date().toISOString(),
    isworking: false,
  };

  const url = `/api/workingtime/${UserID}/${id}`;

  try {
    await serv.put(url, {
      workingtime: workingTimeParams,
    });

    workingtime.value = null;

    startElement.classList.remove("hide");
    stopElement.classList.add("hide");
    timer.stop();
    infoMessage.value = "End day";
    Notif("Info");
  } catch (error) {
    console.error("Error during du Clock Out:", error);
  }
};

// Fonction pour Clock In
const clockIn = async () => {
  const startElement = document.getElementById("startBtn");
  const stopElement = document.getElementById("stopBtn");
  const workingTimeParams = {
    start: new Date().toISOString(),
    end: null,
    isworking: true,
  };

  try {
    const response = await serv.post(`/api/workingtime/${UserID}`, {
      workingtime: workingTimeParams,
    });
    workingtime.value = response.data;

    startElement.classList.add("hide");
    stopElement.classList.remove("hide");
    timer.start();

    setTimeout(() => {
      timer.pause();
      new Modal(document.getElementById("startModal")).show();
    }, 3600000 * 8);

    infoMessage.value = "Day start";
    Notif("Info");
  } catch (error) {
    console.error("Erreur lors du Clock In:", error);
  }
};

const clockContinue = () => {
  timer.start();

  setTimeout(() => {
    timer.stop();
  }, 3600000 * 4);
};

const LogOut = async () => {
  try {
    await serv.get("/api/logout");

    localStorage.removeItem("token");
    localStorage.removeItem("idUser");
    localStorage.removeItem("status");
    await clockOut();
    window.location.reload();

    localStorage.setItem("activeComponent", "authentification");
    showComponent("authentification");
  } catch (error) {
    console.error("Failed to logout:", error);
  }
};

// Fonction pour récupérer le statut de l'utilisateur
const fetchUserStatus = async () => {
  try {
    const response = await serv.get(`/api/users/${UserID}`);
    if (response.data && response.data.data) {
      status.value = response.data.data.status; // Assigner le statut de l'utilisateur
    }
  } catch (error) {
    console.error("Error retrieving user status :", error);
  }
};

const goSignIn = () => {
  localStorage.setItem("activeComponent", "createUser"); // Change le composant actif pour la création de compte
  window.location.reload(); // Recharge la page pour afficher le composant de création de compte
};

const activeComponentComponent = computed(() => {
  return {
    authentification: UserAuthentification,
    calendar: UserCalendar,
    account: UserAccount,
    userManager: UserManager,
    worktimeChart: WorktimeChart,
    pieChart: PieChart,
    graphManage: GraphManage,
    teamManager: TeamManager,
    createUser: createUser,
    faq: FAQ,
  }[activeComponent.value];
});

onMounted(() => {
  // Appel à la fonction pour récupérer le statut de l'utilisateur depuis l'API
  fetchUserStatus();

  const savedComponent = localStorage.getItem("activeComponent");

  const iconActive = document.getElementById(savedComponent);

  if (iconActive != null) {
    const clickedElement = iconActive.closest(".icon");
    clickedElement.classList.toggle("click");
  }

  if (savedComponent) {
    activeComponent.value = savedComponent;
  }

  // Ajoute la détection de la taille d'écran
  checkIfMobile();
  window.addEventListener("resize", checkIfMobile);
});

const checkIfMobile = () => {
  isMobile.value = window.innerWidth <= 768; // Change la limite à 768px pour les téléphones
};
</script>
