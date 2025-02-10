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
import { until } from 'src/types/net';
import { url } from 'src/api/raw/raw';

export default defineComponent({
	name: "Dashboard",
  	components: {},
	props: {},
	setup() {},
	data() {
		return {};
	},
	computed: {},
	watch: {},
	created: function () {},
	methods: {},
});
</script>

<style lang="sass">
</style>
