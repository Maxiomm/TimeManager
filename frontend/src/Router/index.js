import Vue from 'vue';
import VueRouter from 'vue-router';
import WorkingTimes from '@/components/WorkingTimes.vue'; // Importez votre composant

Vue.use(VueRouter);

const routes = [
  {
    path: '/workingTimes/:userID',
    name: 'WorkingTimes',
    component: WorkingTimes // Définissez la route vers votre composant
  }
];

const router = new VueRouter({
  mode: 'history',
  routes
});

export default router;
