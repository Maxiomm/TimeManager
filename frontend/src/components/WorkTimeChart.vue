<template>
  <h2 class="title-page mb-5">Working time per day</h2>

  <div v-if="component === 'worktimeChart'" class="workingtimes">
    <div class="flex info_work">
      <div class="box">
        <div>
          <div class="flex">
            <i class="fas fa-hourglass-half icon_hours"></i>
            <p class="title_hours">Hours work</p>
          </div>
          <div class="middle">
            <p class="title_hours">{{ workH }}</p>
          </div>
        </div>
      </div>

      <div class="box margin-box">
        <div>
          <div class="flex">
            <div class="two_icon_container">
              <i class="fas fa-hourglass-half icon_hours"></i>
              <i class="fas fa-plus-circle icon_add"></i>
            </div>
            <p class="title_hours">Additional hours</p>
          </div>

          <div class="middle">
            <p class="title_hours">{{ supH }}</p>
          </div>
        </div>
      </div>

      <div class="box">
        <div>
          <div class="flex">
            <div class="two_icon_container">
              <i class="fas fa-hourglass-half icon_hours"></i>
              <i class="fas fa-file-edit icon_add"></i>
            </div>
            <p class="title_hours">Regular hours</p>
          </div>

          <div class="middle">
            <p class="title_hours">{{ regularH }}</p>
          </div>
        </div>
      </div>
    </div>
    <div class="container_my_chart">
      <canvas id="my-chart"></canvas>
    </div>
  </div>

  <div class="flex graphManage" v-if="component === 'graphManage'">
    <div class="info_work">
      <div class="box">
        <div>
          <div class="flex">
            <i class="fas fa-hourglass-half icon_hours"></i>
            <p class="title_hours">Hours work</p>
          </div>
          <div class="middle">
            <p class="title_hours">{{ workH }}</p>
          </div>
        </div>
      </div>

      <div class="box">
        <div>
          <div class="flex">
            <div class="two_icon_container">
              <i class="fas fa-hourglass-half icon_hours"></i>
              <i class="fas fa-plus-circle icon_add"></i>
            </div>
            <p class="title_hours">Additional hours</p>
          </div>

          <div class="middle">
            <p class="title_hours">{{ supH }}</p>
          </div>
        </div>
      </div>

      <div class="box">
        <div>
          <div class="flex">
            <div class="two_icon_container">
              <i class="fas fa-hourglass-half icon_hours"></i>
              <i class="fas fa-file-edit icon_add"></i>
            </div>
            <p class="title_hours">Regular hours</p>
          </div>

          <div class="middle">
            <p class="title_hours">{{ regularH }}</p>
          </div>
        </div>
      </div>
    </div>
    <div class="container_my_chart">
      <canvas id="my-chart"></canvas>
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
import { Chart, registerables } from "chart.js";
import { onMounted, ref } from "vue";
import serv from "../Instance/axios";

// Reçoit l'ID utilisateur comme prop depuis GraphManager
const props = defineProps({
  userId: {
    type: Number,
    required: true, // userId est nécessaire
  },
});

const totalWork = ref(0);
const regularHours = ref(0);
const supHours = ref(0);

const workH = ref("");
const supH = ref("");
const regularH = ref("");

const hoursWorkPerDay = ref({});
const dayWork = ref([]);
const component = localStorage.getItem("activeComponent");
const infoMessage = ref("");

Chart.register(...registerables);

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

// Fonction pour récupérer les données d'heures de travail via l'ID de l'utilisateur
const fetchWorkingTimeData = async () => {
  try {
    const responseWT = await serv.get(`/api/workingtimes/${props.userId}`);
    const targetWorkingtime = responseWT.data.data.filter(
      (event) => event.end !== null
    );

    const workData = {};
    targetWorkingtime.forEach((work) => {
      const start = new Date(work.start);
      const end = new Date(work.end);

      const totalMinutes =
        end.getHours() * 60 +
        end.getMinutes() -
        (start.getHours() * 60 + start.getMinutes());
      const totalHours = totalMinutes / 60;

      const date = `${start.getFullYear()}-${String(
        start.getMonth() + 1
      ).padStart(2, "0")}-${String(start.getDate()).padStart(2, "0")}`;

      if (workData[date]) {
        workData[date] += totalHours;
      } else {
        workData[date] = totalHours;
      }
    });

    const sortedDays = Object.keys(workData).sort(
      (a, b) => new Date(a) - new Date(b)
    );
    hoursWorkPerDay.value = workData;
    dayWork.value = sortedDays.slice(-5); // Prend les 5 derniers jours

    if (dayWork.value.length === 0) {
      infoMessage.value = "You have no workingtimes";
      Notif("Info");
    }

    const regular = 8;
    dayWork.value.forEach((each) => {
      totalWork.value += hoursWorkPerDay.value[each];
      const sup = hoursWorkPerDay.value[each] - regular;
      if (sup > 0) {
        supHours.value += sup;
        regularHours.value += regular;
      } else {
        regularHours.value += hoursWorkPerDay.value[each];
      }
    });

    const hourFixed = Math.floor(totalWork.value);
    const minFixed = (totalWork.value - hourFixed) * 60;
    const min = minFixed.toFixed(0);

    const hourSupFixed = Math.floor(supHours.value);
    const minSupFixed = (supHours.value - hourSupFixed) * 60;
    const minSup = minSupFixed.toFixed(0);

    const hourRegularFixed = Math.floor(regularHours.value);
    const minRegularFixed = (regularHours.value - hourRegularFixed) * 60;
    const minRegular = minRegularFixed.toFixed(0);

    workH.value = `${hourFixed}h ${min}min`;
    supH.value = `${hourSupFixed}h ${minSup}min`;
    regularH.value = `${hourRegularFixed}h ${minRegular}min`;
  } catch (error) {
    console.error("Error retrieving data :", error);
  }
};

// Fonction pour afficher le graphique
const renderChart = () => {
  const canvas = document.getElementById("my-chart");
  if (canvas) {
    const ctx = canvas.getContext("2d");

    new Chart(ctx, {
      type: "bar",
      data: {
        labels: dayWork.value,
        datasets: [
          {
            label: "Working time per day",
            backgroundColor: "#2c3e50",
            data: dayWork.value.map((day) => hoursWorkPerDay.value[day]),
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          tooltip: {
            callbacks: {
              label: function (tooltipItem) {
                const totalHours = tooltipItem.raw;
                const hours = Math.floor(totalHours);
                const minutes = Math.round((totalHours - hours) * 60);
                return `${hours} heures ${minutes} minutes`;
              },
            },
          },
        },
      },
    });
  } else {
    console.error("Canvas element not found.");
  }
};

// Lors du montage du composant, récupérer les données et afficher le graphique
onMounted(async () => {
  await fetchWorkingTimeData();

  // Attendre que les données soient prêtes avant de rendre le graphique
  if (
    dayWork.value.length > 0 &&
    Object.keys(hoursWorkPerDay.value).length > 0
  ) {
    renderChart();
  }
});
</script>
