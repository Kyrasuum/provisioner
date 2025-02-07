<template>
    <div class="fullscreen bg-primary text-white text-center q-pa-md flex flex-center">
        <div>
            <div style="font-size: 30vh">404</div>
            <div class="text-h2 text-white">Oops. Nothing here... Redirecting</div>
        </div>
    </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import router from 'src/router';

export default defineComponent({
    name: 'Redirect',

  	components: {},
	props: {},
	setup() {},
	data() {},
	computed: {},
	watch: {},
	created: function () {
	    setTimeout(async () => {
            await router.push({ path: import.meta.env.VITE_ASSET_URL+ "/home"});
            router.go(0);
	    }, 1000)
	},
	methods: {},
});
</script>
