<template>
  <div>
    <h2 class="title-page">FAQ</h2>
    <div class="faq">
      <div v-for="(item, index) in faqs" :key="index" class="faq-item">

        <div class="faq-question" @click="toggleAnswer(index)">
          <span>{{ item.question }}</span>
          <button class="faq-toggle">
            {{ item.isOpen ? '-' : '+' }}
          </button>
        </div>

          <div v-if="item.isOpen" class="faq-answer">
            {{ item.answer }}
          </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      faqs: [
        {
          question: '1. Can I track overtime?',
          answer: 'Yes, overtime is automatically calculated if you work over your normal schedule.',
          isOpen: false
        },
        {
          question: '2. Are weekends included?',
          answer: 'No.',
          isOpen: false
        },
        {
          question: '3. Does the app support night shifts?',
          answer: 'No.',
          isOpen: false
        },
        {
          question: '4. Can managers approve hours ?',
          answer: 'No, managers only have access to the data but cannot approve the hours because they are calculated automatically.',
          isOpen: false
        },
        {
          question: '5. What to do if the application does not work properly?',
          answer: "If the app is not working properly, please contact the developers for assistance.",
          isOpen: false
        }
      ]
    };
  },
  methods: {
    toggleAnswer(index) {
      this.faqs[index].isOpen = !this.faqs[index].isOpen;
    }
  }
};
</script>

