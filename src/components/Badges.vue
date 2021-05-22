<template>
    <nav class="panel" v-if="account">
        <p class="panel-heading">
            Badges for <span class="has-text-info">{{queryAddress}}</span>
        </p>
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
            <code>{{contract.address}}</code>
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
                    let badgeResponse = await fetch('http://localhost:3000/badges/' + this.queryAddress);
                    let badgeJson = await badgeResponse.json();
                    this.badges = badgeJson;
                    this.claimed = await this.contract.balanceOf.call(this.queryAddress, {from: this.account});
                    let response = await this.contract.getUserBadges.call(this.queryAddress, {from: this.account});
                    this.claimedBadges = [];
                    let id;
                    for(let i=0; i<response.length; i++) {
                        id = parseInt(response[i]);
                        if(id > 0) {
                            try {
                                response = await this.contract.tokenURI(id, {from: this.account});
                                console.log('token uri response', response);
                                this.claimedBadges.push({id:id, url:response});
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
                console.log('requesting badges for, from', this.queryAddress, this.account);
                let response = await this.contract.requestBadges(this.queryAddress, {from: this.account});
                console.log('response', response);
                this.claimInProgress = false;
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
