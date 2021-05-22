// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract BadgeLookup {

    string constant public apiUrl = "https://synthetixbadges.glitch.me/badge/";               // api.synthetix.io

    // Badge Lookups
    uint256 public totalBadges;

    // Internals
    mapping (uint256 => string) public badgeUrl;

     /**
     * Simple lookup contract that can be replaced with new information.
     */
    constructor() {

        // Replace these with IPFS URLs
        uint256 id;
        id++;
        badgeUrl[id] = "https://synthetixbadges.netlify.com/badges/90_days.json";
        id++;
        badgeUrl[id] = "https://synthetixbadges.netlify.com/badges/180_days.json";
        id++;
        badgeUrl[id] = "https://synthetixbadges.netlify.com/badges/365_days.json";
        id++;
        badgeUrl[id] = "https://synthetixbadges.netlify.com/badges/top_100.json";
        id++;
        badgeUrl[id] = "https://synthetixbadges.netlify.com/badges/top_1000.json";
        totalBadges = id;
    }

    /**
     * Token lookup for myself or someone else.
     */
    function getBadgeById(uint256 id) view public returns(string memory url) {
        url = badgeUrl[id];
        return url;
    }

    /**
     * Get total badges.
     */
    function getTotalBadges() view public returns(uint256) {
        return totalBadges;
    }

}



