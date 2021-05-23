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


## API

The API has two method URLs:
* ``/badge/ADDRESS``
 * Returns a single ID of a qualifying badge, or 0 if there are none.
* ``/badges/ADDRESS``
 * Returns an array of badge URLs of qualifying badges.

## Project setup
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
