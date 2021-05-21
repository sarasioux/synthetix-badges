<template>
    <div class="card">
        <div class="card-image">
            <figure class="image is-square">
                <img :src="badge.image" alt="Spartan Fighters">
            </figure>
            <div class="id-tag tags has-addons" v-if="id">
                <span class="tag">Token ID</span>
                <span class="tag is-danger">{{id}}</span>
            </div>
        </div>
        <div class="card-content">
            <div class="media">
                <p class="title is-4">{{badge.name}}</p>
            </div>

            <div class="content">
                {{badge.description}}
            </div>
        </div>
    </div>
</template>

<script>
    //import synthBadges from '../../configs/badges.js';
    export default {
        name: 'Badge',
        data: () => {
            return {
                badge: {}
            }
        },
        props: {
            badgeUrl: String,
            id: Number,
        },
        mounted: async function() {
            let response = await fetch(this.badgeUrl);
            let badge = await response.json();
            this.badge = badge;
        },
        methods: {
        }
    }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
