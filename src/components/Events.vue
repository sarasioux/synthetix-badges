<template>
    <nav class="panel">
        <p class="panel-heading">
            Contract Events
        </p>
        <p class="panel-block" v-for="event in events" :key="event">
            <code>{{event.args}}</code>
        </p>
    </nav>
</template>

<script>

  export default {
    name: 'Events',
    data: () => {
      return {
        events: {}
      }
    },
    props: {
      contract: Object,
      account: String,
    },
    mounted: function() {
      this.loadEvents();
    },
    methods: {
      loadEvents: async function() {
        this.contract.PlayerJoined(this.playerJoined);
      },
      eventReceived: function(err, res) {
        this.events[res.id] = event;
        console.log('eventReceived', res);
      },

      /*
      Known wallets
          const exchangeWalletsReq = await fetch('https://raw.githubusercontent.com/whjn011205/ScoreEngine/fe383336db49a7601f1793b8ad570a8d0a8fb6df/src/data/goodList.json');
    const exchangeWallets = await exchangeWalletsReq.json();

    const knownWallets = exchangeWallets.concat({ name: 'Synthetix: Foundation', exchange: '0x49BE88F0fcC3A8393a59d3688480d7D253C37D2A' }, { name: 'Uniswap SNX V1', exchange: '0x3958B4eC427F8fa24eB60F42821760e88d485f7F' }, { name: 'Synthetix: ArbRewarder', exchange: '0xA6B5E74466eDc95D0b6e65c5CBFcA0a676d893a4' }, {
      name: 'Kyber SNX Reserve', exchange: '0xa107dfa919c3f084a7893A260b99586981beb528'
    }, { name: 'Aave Lending Pool', exchange: '0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3' }, {
      name: 'Liquid', exchange: '0xedBB72E6b3Cf66a792bFF7FaaC5Ea769fe810517'
    }, { name: 'Unipool', exchange: '0x48D7f315feDcaD332F68aafa017c7C158BC54760' },
                                               {name: 'Synthetix: Airdropper', exchange: '0x3aa4907A38eE3ffA485CDEAa7bB1a2B7241F5dAA' }, {
      name: 'Eterbase', exchange: '0x8D76166C22658A144c0211d87Abf152e6a2d9D95'
    });
       */

    }
  }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
