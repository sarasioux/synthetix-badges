// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract BadgeLookup {

    string constant apiUrl = "https://synthetixbadges.glitch.me/";               // api.synthetix.io
    string constant tokenUrl = "https://synthetixbadges.netlify.com/";               // api.synthetix.io

    // Badge Lookups
    uint256 public totalBadges;

    // Internals
    mapping (uint256 => string) public badgeUrl;

     /**
     * Simple lookup contract that can be replaced with new information.
     */
    constructor() payable {

        badgeUrl[1] = "https://synthetixbadges.netlify.com/badges/90_days.json";
        badgeUrl[2] = "https://synthetixbadges.netlify.com/badges/180_days.json";
        badgeUrl[3] = "https://synthetixbadges.netlify.com/badges/365_days.json";
        badgeUrl[4] = "https://synthetixbadges.netlify.com/badges/top_100.json";
        badgeUrl[5] = "https://synthetixbadges.netlify.com/badges/top_1000.json";

        totalBadges = 5;
    }

    /**
     * Token lookup for myself or someone else.
     */
    function getBadgeById(uint256 id) view public returns(string memory) {
        return badgeUrl[id];
    }

    /**
     * Get total badges.
     */
    function getTotalBadges() view public returns(uint256) {
        return totalBadges;
    }

}



