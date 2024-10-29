<template>
  <h2 style="text-align: center; margin-top: 2rem">User's calendar</h2>

  <FullCalendar style="max-height: 80vh" :options="calendarOptions" />
  <div
    class="modal fade"
    id="CreateTaskModal"
    tabindex="-1"
    aria-labelledby="CreateTaskModal"
    aria-hidden="true"
  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title" id="exampleModalLabel">New task</h1>

          <button
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>

        <div class="modal-body">
          <form>
            <div class="mb-3">
              <label class="label_input">Title</label>
              <input
                v-model="title"
                id="task-title"
                type="text"
                class="input"
                required
              />
            </div>

            <label class="label_input">Task's Category</label>
            <div class="mb-3">
              <select
                v-model="SelectCategories"
                id="CategoiesID"
                class="SelectOptions"
              >
                <option disabled value="">Choose a category</option>
                <option
                  v-for="category in categories"
                  :key="category.id"
                  :value="category.id"
                >
                  {{ category.title }}
                </option>
              </select>
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
            @click="CreateTask"
            class="btn btn-primary"
            data-bs-dismiss="modal"
          >
            Create task
          </button>
        </div>
      </div>
    </div>
  </div>

  <div
    class="modal fade"
    id="UpdateDeleteTaskModal"
    tabindex="-1"
    aria-labelledby="UpdateDeleteTaskModal"
    aria-hidden="true"
  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title" id="exampleModalLabel">Tasks modification</h1>

          <button
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>

        <div class="modal-body">
          <form>
            <div class="mb-3">
              <label class="label_input">Title</label>
              <input
                v-model="oldData.title"
                id="task-title"
                type="text"
                class="input"
                required
              />
            </div>

            <div class="mb-3">
              <label class="label_input">Start time</label>
              <input
                v-model="oldData.start"
                type="text"
                id="start-time"
                class="input"
              />
            </div>

            <div class="mb-3">
              <label class="label_input">End time</label>
              <input
                v-model="oldData.end"
                type="text"
                id="start-time"
                class="input"
              />
            </div>

            <h4 class="fs-5 text-white" id="oldData_category">
              {{ oldData.category_title }}
            </h4>

            <div class="mb-2 hide" id="CategoryChoose">
              <select
                v-model="SelectCategories"
                id="CategoiesID"
                class="SelectOptions"
              >
                <option
                  v-for="category in categories"
                  :key="category.id"
                  :value="category.id"
                >
                  {{ category.title }}
                </option>
              </select>
            </div>

            <p @click="ShowBtn" style="cursor: pointer" class="text-white" id="btn">Change</p>
          </form>
        </div>

        <div class="modal-footer d-flex w-100">
          <button
            type="button"
            class="btn btn-secondary"
            data-bs-dismiss="modal"
          >
            Fermer
          </button>

          <div class="flex w-100">
            <button
              type="button"
              @click="UpdateTask"
              class="btn btn-primary me-2"
              data-bs-dismiss="modal"
            >
              Update
            </button>

            <button
              type="button"
              @click="DeleteTask"
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
import FullCalendar from "@fullcalendar/vue3";
import dayGridPlugin from "@fullcalendar/daygrid";
import interactionPlugin from "@fullcalendar/interaction";
import timeGridPlugin from "@fullcalendar/timegrid";
import serv from "../Instance/axios"
import { ref, onMounted } from "vue";
import { Modal } from "bootstrap";

// Reçoit l'ID utilisateur comme prop depuis GraphManager
const props = defineProps({
  userId: {
    type: Number,
    required: true,
  },
});

const title = ref("");
const SelectCategories = ref(null);
const categories = ref([]);
const selectDate = ref(null);
const oldData = ref([]);
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

const ShowBtn = () => {
  const element = document.getElementById("CategoryChoose");
  const elementbtn = document.getElementById("btn");
  const elementOlddata = document.getElementById("oldData_category");

  elementOlddata.classList.add("hide");
  element.classList.remove("hide");
  elementbtn.classList.add("hide");
};

const showCreateTaskModal = (selectInfo) => {
  selectDate.value = selectInfo;
  new Modal(document.getElementById("CreateTaskModal")).show();
};

const showUpdateTaskModal = () => {
  new Modal(document.getElementById("UpdateDeleteTaskModal")).show();
};

const CreateTask = async () => {
  try {
    await serv.post(`/api/tasks`, {
      tasks: {
        title: title.value,
        start: selectDate.value.startStr,
        end: selectDate.value.endStr,
        category_id: SelectCategories.value,
        user_id: props.userId,
      },
    });

    const calendarApi = selectDate.value.view.calendar;


    calendarApi.addEvent({
      title: title.value,
      start: selectDate.value.startStr,
      end: selectDate.value.endStr,
      extendedProps: {
        category: SelectCategories.value,
      },
      textColor: "black",
    });

    successMessage.value = "Task successfully created !"
    Notif("Success")
    Reset()
    await fetchData();
  }catch(err){
    if(SelectCategories.value === null && title.value === ""){
      error.value = "Category and title can't be blank"
      Notif('Error')
      Reset()
    }
    else if(SelectCategories.value === null){
      error.value = "Category can't be blank"
      Notif('Error')
      Reset()
    }
    else{
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
        error.value = err.response.data.error
      }
      Notif("Error")
      Reset()
    }
  }
};

const Reset = () => {
  SelectCategories.value = null
  title.value = ""
}

const UpdateTask = async () => {
  const element = document.getElementById("CategoryChoose");
  const elementbtn = document.getElementById("btn");
  const elementOlddata = document.getElementById("oldData_category");
  const new_value = oldData.value;
  let id;

  if (SelectCategories.value != null) {
    id = SelectCategories.value;
  } else {
    id = new_value.category_id;
  }

  elementOlddata.classList.remove("hide");
  element.classList.add("hide");
  elementbtn.classList.remove("hide");

  try {
    await serv.put(`/api/tasks/` + oldData.value.id, {
      tasks: {
        title: new_value.title,
        start: new_value.start,
        end: new_value.end,
        category_id: id,
      },
    });

    selectDate.value.view.calendar;
  } catch (err) {
    if (err.response) {
      console.log(err)
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
      Reset()
    }
  }

  await fetchData();
};

const DeleteTask = async () => {
  const id = oldData.value.id;
  const event = oldData.value.event;
  const element = document.getElementById("CategoryChoose");
  const elementbtn = document.getElementById("btn");
  const elementOlddata = document.getElementById("oldData_category");

  event.remove();
  await serv.delete(`/api/tasks/` + id);

  elementOlddata.classList.remove("hide");
  element.classList.add("hide");
  elementbtn.classList.remove("hide");

  await fetchData();

  successMessage.value = "Task successfully deleted !"
  Notif("Success")
};

const calendarOptions = ref({
  plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
  headerToolbar: {
    left: "prev,next today",
    right: "dayGridMonth,timeGridWeek",
  },
  initialView: "timeGridWeek",
  editable: true,
  selectable: true,
  weekends: true,
  timeZone: "UTC",
  select: showCreateTaskModal,
  eventClick: async function (info) {
    const id = info.event.extendedProps.id;
    const title = info.event._def.title;
    const start = info.event._instance.range.start;
    const end = info.event._instance.range.end;
    const category = info.event.extendedProps.category;
    const category_info = await serv.get(`/api/categories/` + category);
    const event = info.event;

    oldData.value = {
      id: id,
      title: title,
      start: start.toISOString(),
      end: end.toISOString(),
      category_id: category,
      category_title: category_info.data.data.title,
      event: event,
    };
    showUpdateTaskModal();
  },
  eventDidMount: async function (info) {
    const category_id = info.event.extendedProps.category;
    const responseCatID = await serv.get(`/api/categories/` + category_id);
    const data = responseCatID.data.data.color;
    info.el.style.backgroundColor = data;
  },
  events: [],
  allDaySlot: false,
});

const fetchData = async () => {
  try {
    const responseTask = await serv.get(`/api/tasks/` + props.userId);
    const task_info = responseTask.data.data;

   if(task_info.length === 0){
     infoMessage.value = "You have no task"
     Notif("Info")
   }else{
     const eventsInfo = task_info.map((event) => ({
       title: event.title,
       start: event.start,
       end: event.end,
       extendedProps: {
         category: event.category_id,
         id: event.id,
       },
       textColor: "white",
     }));

     calendarOptions.value.events = eventsInfo;
   }

    const responseCat = await serv.get(`/api/categories`);
    const Cat_info = responseCat.data.data;
    categories.value = Cat_info;
  } catch (err) {
    console.log("Error retrieving tasks :", err);
  }
};


onMounted(async () => {
  await fetchData();
});
</script>

