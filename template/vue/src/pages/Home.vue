<template>
	<q-layout view="hHh LpR fFf">
		<q-header elevated>
		</q-header>

		<q-page-container>
			<q-page class="row" :class="[$q.dark.isActive ? 'bg-black': '']">
			</q-page>
		</q-page-container>

		<q-footer elevated style="height: 0px; overflow: visible">
		</q-footer>
	</q-layout>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import { until } from 'src/types/Net';
import { url } from 'src/api/raw/apiRaw';

export default defineComponent({
	name: "Dashboard",
	components: { },

	data() {
		return {
			url,
		};
	},

	methods: {
	}
});
</script>

<style lang="sass">
</style>
