<template>
  <div>
    <h2 class="title-page mb-2">
      Number of tasks per category
    </h2>

    <div v-if="!isManagerView" class="center">
      <div
          style="
          display: grid;
          grid-template-columns: 50% 50%;
          grid-gap: 2rem;
          width: fit-content;
          justify-content: center;
        "
      >
        <button @click="showCategoryModal" class="btn btn-primary">
          New category
        </button>

        <button @click="showModifCategoryModal" class="btn btn-warning">
          Modif category
        </button>
      </div>
    </div>

    <div class="pie-chart-container">
      <apexchart
          :key="chartKey"
          type="pie"
          :options="chartOptions"
          :series="data"
          class="PieChart"
      ></apexchart>
    </div>
  </div>

  <!-- Modal Create category -->
  <div
      class="modal fade"
      id="showCategoryModal"
      tabindex="-1"
      aria-labelledby="showCategoryModal"
      aria-hidden="true"
  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="exampleModalLabel">New Category</h1>
          <button
              type="button"
              class="btn-close bg-white"
              data-bs-dismiss="modal"
              aria-label="Close"
          ></button>
        </div>

        <div class="modal-body">
          <form>
            <div class="mb-3">
              <input
                  v-model="title"
                  id="task-title"
                  type="text"
                  placeholder="Title"
                  class="input"
                  required
              />
            </div>

            <label class="label_input">Category's color</label>
            <div class="mb-3" style="width: 100px">
              <input type="color" id="head" name="head" style="cursor: pointer" :style="{ backgroundColor: color }"
                     v-model="color"/>
            </div>
          </form>
        </div>

        <div class="modal-footer">
          <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
          >
            Close
          </button>

          <button
              type="button"
              class="btn btn-primary"
              data-bs-dismiss="modal"
              @click="createCategory"
          >
            Create category
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal update category -->
  <div
      class="modal fade"
      id="showModifCategoryModal"
      tabindex="-1"
      aria-labelledby="showModifCategoryModal"
      aria-hidden="true"
  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title" id="exampleModalLabel">
            Category modification
          </h1>

          <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
          ></button>
        </div>

        <div class="modal-body">
          <form>
            <div class="mb-2" id="CategoryChoose">
              <select
                  v-model="category_id"
                  id="CategoiesID"
                  class="SelectOptions"
              >
                <option value="" selected>Category to update</option>
                <option
                    v-for="category in categories"
                    :key="category.id"
                    :value="category.id"
                >
                  {{ category.title }}
                </option>
              </select>
            </div>

            <div class="mb-3">
              <input
                  v-model="newtilte"
                  id="task-title"
                  type="text"
                  placeholder="New title"
                  class="input"
                  required
              />
            </div>

            <label class="label_input">Category's color</label>
            <div class="mb-3">
              <input
                  type="color"
                  style="width: 100px"
                  :style="{ backgroundColor: color }"
                  id="head"
                  name="head"
                  v-model="color"
              />
            </div>


          </form>
        </div>

        <div class="modal-footer d-flex w-100">
          <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
          >
            Close
          </button>

          <div class="center w-100">
          <button
              type="button"
              @click="updateCategory"
              class="btn btn-primary me-2"
              data-bs-dismiss="modal"
          >
            Update
          </button>

          <button
              type="button"
              @click="deleteCategory"
              class="btn btn-danger"
              data-bs-dismiss="modal"
          >
            Delete
          </button>

          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Notif de Succès -->
  <div id="notifSuccess" class="notif-container notif-close">
    <div class="notif">
      <i class="fas fa-check-circle check-color icon_notif"></i>
      <p class="text_notif"> {{ successMessage }}</p>
      <i @click="NotifClose('Success')" class="fas fa-x icon-close"></i>
    </div>
  </div>

  <!-- Notif de Error -->
  <div id="notifError" class="notif-container notif-close">
    <div class="notif">
      <i class="fas fa-circle-exclamation  wrong-color icon_notif"></i>
      <p class="text_notif"> {{ error }}</p>
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
import {onMounted, ref} from "vue";
import serv from "../Instance/axios";

import apexchart from "vue3-apexcharts";
import {Modal} from "bootstrap";

// Reçoit l'ID utilisateur comme prop depuis GraphManager
const props = defineProps({
  userId: {
    type: Number,
    required: true,
  },
  isManagerView: {
    type: Boolean,
    default: false,
  },
});

// Données du graphique
const labels = ref([]);
const data = ref([]);
const backgroundColor = ref([]);
const color = ref("#000a29");
const categories = ref([]);
const newtilte = ref("");
const category_id = ref('');
const title = ref("");
const error = ref("");
const infoMessage = ref("");
const successMessage = ref("")

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

const chartOptions = ref({
  chart: {
    type: "pie",
    toolbar: {
      show: false, // Désactive la barre d'outils pour réduire l'interactivité
    },
  },
  plotOptions: {
    pie: {
      expandOnClick: true,
    },
  },
  states: {
    active: {
      filter: {
        type: "none", // Désactive le changement de couleur au clic
      },
    },
  },
  labels: [],
  colors: [],
});

// Clé réactive pour forcer le re-rendu
const chartKey = ref(0);

const fetchData = async () => {
  try {
    const responseCat = await serv.get(`/api/categories`);
    const info = responseCat.data.data;

    // Reset des données avant de les remplir à nouveau
    labels.value = [];
    backgroundColor.value = [];
    data.value = [];

    for (const category of info) {
      labels.value.push(category.title);
      backgroundColor.value.push(category.color);

      if (category.id) {
        const responseTasks = await serv.get(
            `/api/tasks/cat/${props.userId}/${category.id}`
        );

        const infoTask = responseTasks.data.data;
        if(infoTask.length !== 0){
          data.value.push(infoTask.length);
        }
      }
    }
    if(data.value.length === 0){
      infoMessage.value = "You have no tasks"
      Notif("Info")
    }

    // Mettre à jour les labels et les couleurs dans les options du graphique
    chartOptions.value.labels = [...labels.value];
    chartOptions.value.colors = [...backgroundColor.value];

    // Forcer le rerender en modifiant la clé
    chartKey.value += 1;
  } catch (error) {
    console.error(
        "Error retrieving categories and tasks :",
        error
    );
  }
};

const fetchCategory = async () => {
  const responseCat = await serv.get(`/api/categories`);
  const Cat_info = responseCat.data.data;
  categories.value = Cat_info;
  if(categories.value.length === 0){
    infoMessage.value = "You have no categories"
    Notif("Info")
  }
};

// Méthode pour créer un category
const createCategory = async () => {
  try {
    // Appel à l'API pour créer l'utilisateur
    await serv.post(
        "/api/categories",
        {
          categories: {
            title: title.value,
            color: color.value,
          },
        }
    );

    await fetchData();

    // Réinitialise le formulaire après la création
    error.value = "";
    title.value = "";
    color.value = "";
    successMessage.value = "Category successfully created"
    Notif('Success')
  } catch (err) {
    const type = typeof err.response.data.error
    if(type === "object"){
      const keys = Object.keys(err.response.data.error)
      const value = Object.values(err.response.data.error)
      const final_value = []
      let KeyError = ""
      let ValueError = ""
      let sentenceError = ""
      keys.forEach(function (key, index){
        final_value.push(value[index][0])
      })

      const checkSameValue = final_value.every(val => JSON.stringify(val) === JSON.stringify(final_value[0]))

      if(checkSameValue){
        KeyError += `${keys}`
        ValueError = `${final_value[0]}`
        sentenceError = `${KeyError} ${ValueError}`
        error.value = sentenceError
      }
    }else{
      error.value = err.response.data.errors
    }

    Notif('Error')
  }
};

// Méthode pour mettre à jour un utilisateur
const updateCategory = async () => {
  try {
    if(category_id.value !== ""){
      const responsegetCategory = await serv.get(
          `/api/categories/${category_id.value}`
      );

      if (newtilte.value === null) {
        title.value = responsegetCategory.data.data.title;
      } else {
        title.value = newtilte.value;
      }

      await serv.put(
          `/api/categories/${category_id.value}`,
          {
            categories: {
              title: title.value,
              color: color.value,
            },
          }
      );

      successMessage.value = "Category successfully updated"
      Notif('Success')

      await fetchData();
      newtilte.value = ""
    }else{
      error.value = "ID category missing"
      Notif("Error")
      newtilte.value = ""
    }
  } catch (err) {
      const type = typeof err.response.data.errors
      if(type === "object"){
        const keys = Object.keys(err.response.data.errors)
        const value = Object.values(err.response.data.errors)
        const final_value = []
        let KeyError = ""
        let ValueError = ""
        let sentenceError = ""
        keys.forEach(function (key, index){
          final_value.push(value[index][0])
        })

        const checkSameValue = final_value.every(val => JSON.stringify(val) === JSON.stringify(final_value[0]))

        if(checkSameValue){
          KeyError += `${keys}`
          ValueError = `${final_value[0]}`
          sentenceError = `${KeyError} ${ValueError}`
          error.value = sentenceError
        }
      }else{
        error.value = err.response.data.errors
      }
    Notif("Error")
  }
}

// Méthode pour supprimer une category récupéré
const deleteCategory = async () => {
  try {
    // Appel à l'API pour supprimer l'utilisateur récupéré
    await serv.delete(`/api/categories/${category_id.value}`);

    successMessage.value = "Category successfully deleted"
    Notif('Success')

    await fetchData();

    // Réinitialise le formulaire après la suppression
    error.value = "";
  } catch (error) {
    error.value = "ID category missing";
    Notif("Error")
  }
};

const showModifCategoryModal = () => {
  // Affiche le modal de confirmation
  fetchCategory();
  new Modal(document.getElementById("showModifCategoryModal")).show();
};

const showCategoryModal = () => {
  new Modal(document.getElementById("showCategoryModal")).show();
};

onMounted(() => {
  fetchData();
  fetchCategory();
});
</script>

