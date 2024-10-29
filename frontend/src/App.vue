<template>
  <div class="height" style="background-color: var(--primary-color); width: 100%">
    <SideNavBar />
  </div>
</template>

<script>
import "@fortawesome/fontawesome-free/css/all.css";
import SideNavBar from "./components/SideNavBar.vue";

export default {
  components: {
    SideNavBar,
  },
};
</script>
