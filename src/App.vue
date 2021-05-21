<template>
    <SiteNav
            v-on:connect="connectWeb3"
            v-on:lookup="lookup"
            :isConnected="isConnected"
            :account="account"
    />
    <div class="container">
        <Badges
            v-if="isConnected && ready"
            :queryAddress="queryAddress"
            :account="account"
            :contract="contract"
        />
    </div>


</template>

<script>
    import SiteNav from './components/SiteNav.vue'
    import Badges from './components/Badges.vue'
    import SynthBadge from '../build/contracts/SynthBadge.json'
    import TruffleContract from '@truffle/contract'

    export default {
        name: 'App',
        data: () => {
            return {
                ready: false,
                isConnected: false,
                connectionInProgress: false,
                account: '',
                contract: {},
                queryAddress: '',
                nfts: []
            }
        },
        components: {
            SiteNav, Badges
        },
        mounted: function() {
        },
        methods: {
            connectWeb3: async function() {
                this.connectionInProgress = true;
                try {
                    // Request account access
                    const accounts = await this.$web3.currentProvider.send('eth_requestAccounts');
                    this.isConnected = true;
                    this.account = accounts.result[0];
                    //this.queryAddress = this.account;
                    this.queryAddress = '0x865973fc3b40aff4b16ff54beb5aaefe33dccf8d';
                    this.connectionInProgress = false;

                    this.initContracts();

                    //this.getNFTs();

                } catch (error) {
                    // User denied account access
                    console.log('did not receive accts', error);
                }
            },
            initContracts: async function() {
                let contract = TruffleContract(SynthBadge);
                console.log('current provider', this.$web3.currentProvider);
                contract.setProvider(this.$web3.currentProvider);
                contract.defaults({
                    from: this.account,
                    gasPrice: 1000000000
                });
                this.contract = await contract.deployed();
                this.ready = true;
            },
            lookup: async function(address) {
                this.queryAddress = address;
            },
            getNFTs: async function() {
                const url = 'https://api.opensea.io/api/v1/assets?limit=100&owner=' + this.account;
                console.log('url', url);
                const options = {method: 'GET'};
                const res = await fetch(url, options);
                const json = await res.json();
                this.nfts = json.assets;
                console.log(this.nfts);
            }
        }
    }
</script>

<style>
    #app {
        margin-top: 20px;
    }

</style>
