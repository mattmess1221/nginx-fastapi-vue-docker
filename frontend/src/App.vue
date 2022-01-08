<template>
  <div id="app">
    <h1 v-if="loading">Loading from backend...</h1>
    <h1 v-else-if="error">{{ error }}</h1>
    <h1 v-else>{{ message }}</h1>
  </div>
</template>

<script>
export default {
  name: "App",
  data() {
    return {
      loading: true,
      error: null,
      message: null,
    };
  },
  async mounted() {
    this.loading = true;
    try {
      const result = await fetch("/api/hello");
      if (result.ok) {
        const { message } = await result.json();
        this.message = message;
      } else {
        const { detail } = await result.json();
        this.error = detail;
      }
    } catch (exc) {
      console.error(exc)
      this.error = exc.toString();
    } finally {
      this.loading = false;
    }
  },
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
