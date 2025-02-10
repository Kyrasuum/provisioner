import { RouteRecordRaw } from 'vue-router';

const routes: RouteRecordRaw[] = [
    {
        path: import.meta.env.VITE_ASSET_URL + '/home/:catchAll(.*)*',
        name: "Home",
        component: () => import('/src/pages/home.vue'),
        meta: {
            requiresAuth: false,
            level: 0
        }
    },

    // Always leave this as last one,
    // but you can also remove it
    {
        path: '/:catchAll(.*)*',
        name: "Redirect",
        component: () => import('/src/pages/redirect.vue'),
        meta: {
            requiresAuth: false,
            level: 0
        }
    },
];

export default routes;
