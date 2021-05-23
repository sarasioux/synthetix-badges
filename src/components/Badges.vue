<template>
    <nav class="panel" v-if="account">
        <p class="panel-heading">
            Badges for <span class="has-text-info">{{queryAddress}}</span>
        </p>
        <section v-if="!ready" class="section">
            <progress class="progress is-large is-info" max="100">60%</progress>
        </section>

        <div class="container" v-if="ready">
            <div class="columns">
                <div class="column">
                    <h3 class="title is-3">
                        Qualifying Badges
                        <button
                            class="button pull-right is-info"
                            v-if="badges.length > 0"
                            @click="claimBadges"
                            :disabled="claimInProgress"
                        >
                            <span class="icon">
                                <i class="fab fa-ethereum" v-if="!claimInProgress"></i>
                                <i class="fab fas fa-spinner fa-pulse" v-if="claimInProgress"></i>
                            </span>
                            <span>Claim</span>
                        </button>
                    </h3>
                    <div class="columns is-multiline">
                        <div class="column is-4" v-for="badge in badges" :key="badge">
                            <Badge
                                :badgeUrl="badge"
                            />
                        </div>
                    </div>
                </div>
                <div class="column">
                    <h3 class="title is-3">Claimed Badges</h3>
                    <div class="columns is-multiline">
                        <div class="column is-4" v-for="badge in claimedBadges" :key="badge.id">
                            <Badge
                                :id="badge.id"
                                :badgeUrl="badge.url"
                            />
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <div class="section has-text-centered">
            <code>This Contract: {{contract.address}}</code>
        </div>
    </nav>
</template>

<script>
    import Badge from './Badge.vue'

    export default {
        name: 'Badges',
        data: () => {
            return {
                ready: false,
                events: {},
                badges: [],
                claimed: 0,
                claimedBadges: [],
                claimInProgress: false,
                checkUserBadge: ''
            }
        },
        props: {
            account: String,
            queryAddress: String,
            contract: Object,
        },
        watch: {
            account: function () {
                this.loadData();
            }
        },
        components: {
            Badge
        },
        mounted: function() {
            this.loadData();
        },
        methods: {
            loadData: async function() {
                if(this.queryAddress) {
                    let badgeResponse = await fetch('https://synthetixbadges.glitch.me/badges/' + this.queryAddress);
                    let badgeJson = await badgeResponse.json();
                    this.badges = badgeJson;
                    this.claimed = await this.contract.balanceOf.call(this.queryAddress, {from: this.account});
                    let response = await this.contract.getUserBadges.call(this.queryAddress, {from: this.account});
                    this.claimedBadges = [];
                    let id;
                    let res;
                    for(let i=0; i<response.length; i++) {
                        id = parseInt(response[i]);
                        if(id > 0) {
                            try {
                                res = await this.contract.getTokenUrl(id, {from: this.account});
                                this.claimedBadges.push({id:id, url:res});
                            }
                            catch {
                                console.log('wtf');
                            }
                        }
                    }
                    this.ready = true;
                }
            },
            claimBadges: async function() {
                this.claimInProgress = true;
                await this.contract.requestBadges(this.queryAddress, {from: this.account});
                this.claimInProgress = false;
                this.loadData();
            }
        }
    }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
    .container {
        padding: 1.5em;
    }
    .pull-right {
        float: right;
    }
</style>
