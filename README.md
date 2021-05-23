# Synthetix Badges

![Screenshot](https://github.com/sarasioux/synthetix-badges/blob/master/public/screenshot.png?raw=true)

This project is a response to:
https://gitcoin.co/issue/snxgrants/open-defi-hackathon/6/100025687

You can see the live dApp here:
https://synthetixbadges.netlify.app/

This solution required an API, which is hosted here:
https://synthetixbadges.glitch.me/

The github for the API is here:
https://github.com/sarasioux/synthetix-badges-api

## Overview

To get access to the historical data required for this project, I needed to query The Graph, but that was impossible to do from the contract so I created an API. The API's job is to query The Graph and figure out if an address has any qualifying badges.

Using this method, new badges can be added to the system at any time, and the token contract can remain untouched. The assets are currently hosted on the dApp but could easily be moved to IPFS before production launch.

* Qualifying Badges is reading historic data from Mainnet
* Claimed Badges is minting NFTs on Kovan
* You can lookup and claim for any address (I did that for testing)
* API requests are fulfilled using Chainlink.
* NFTs are minted with OpenSea standards, so their metadata will show up as a collectible in most NFT sites.
* 5 badges currently exist: 90, 180, and 365 day staker, and top 100 and 1000 holders.
* The dApp is just for demonstration purposes, I would combine the functionality with the Spartan NFT game.

## Flowchart

The system can be understood with this very professional flowchart.

![Flowchart](https://github.com/sarasioux/synthetix-badges/blob/master/public/flowchart.png?raw=true)

The API's job is to figure out all potential badges for an address using The Graph's historic data, and compare those to already claimed badges using the contract's query methods.  The result is a set of "qualifying badges" which can be used by the contract or the dApp to provide a user experience.

## dApp

I didn't go too far on building out the dApp for this system as I feel its unnecessary.  The real user interface should live on your main member site, or potentially inside the Spartan NFT game.  This dApp was provided for demonstration purposes to show that the system is working and allow you to lookup potential badges for any address for fun.

## Badges

The badges themselves are minted using the OpenSea NFT metadata definition standard.  I added appropriate attributes to the two classes, so if you list your NFTs in an NFT-viewer like OpenSea it will display the attributes.

The badge imagery is a placeholder, I would recommend contracting out for hand-drawn or designed images.  Currently there are 5 different badges so I used 5 different images of 300 the movie.

## API

The API has two method URLs:
* ``/badge/ADDRESS``
 * Returns a single ID of a qualifying badge, or 0 if there are none.
* ``/badges/ADDRESS``
 * Returns an array of badge URLs of qualifying badges.

## Project setup

The token contract needs to be funded with LINK in order to work.

```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

### Compiles and minifies for production
```
npm run build
```

### Lints and fixes files
```
npm run lint
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).
