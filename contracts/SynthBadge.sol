// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/dev/Chainlink.sol";
import "@chainlink/contracts/src/v0.8/dev/ChainlinkClient.sol";
import "./BadgeLookup.sol";


contract SynthBadge is ERC721URIStorage, ChainlinkClient {
    using Counters for Counters.Counter;
    using Chainlink for Chainlink.Request;

    Counters.Counter private _tokenIds;

    string constant apiUrl = "https://synthetixbadges.glitch.me/badge/";               // api.synthetix.io

    // Badge Lookup and owner
    address public badgeLookup;
    address public owner;

    // Chainlink
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    // Internals
    mapping (bytes32=> address) public requestByAddress;
    mapping (address=> uint256[]) public badgesByUser;
    mapping (address=> uint256) public totalUserBadges;

    // Events
    event UrlRequested(string url);
    event ApiResponse(bytes32 requestId, uint256 badgeTotal);

    // Permits modifications only by the owner of the contract.
    modifier only_owner() {
        require(msg.sender == owner, "Only contract owner can call this function.");
        _;
    }

    // Permits modifications only by the oracle contract.
    modifier from_oracle() {
        require(msg.sender == address(oracle), "Only oracle contract can call this function.");
        _;
    }

     /**
     * Network: Kovan
     * Oracle: 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e
     * Job ID: 29fa9aa13bf1468788b7cc4a500a45b8
     * Fee: 0.1 LINK
     */
    constructor(address _badgeLookup) payable
    ERC721("SynthBadge", "sNFT")
    {
        // KOVAN settings
        setPublicChainlinkToken();
        oracle = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e;
        jobId = "29fa9aa13bf1468788b7cc4a500a45b8";
        fee = 0.1 * 10 ** 18; // (Varies by network and job)

        badgeLookup = _badgeLookup;
        owner = msg.sender;
    }

    /**
     * OWNER ONLY UPDATE FUNCTIONS IN CASE THINGS CHANGE.
     */

    /**
     * @dev Updates the oracle contract.
     */
    function updateOracle(address _oracle) only_owner public {
        oracle = _oracle;
    }

    /**
     * @dev Updates the oracle contract.
     */
    function updateLookup(address _lookup) only_owner public {
        badgeLookup = _lookup;
    }

    /**
     * @dev Updates the oracle contract.
     */
    function updateJob(bytes32 _job) only_owner public {
        jobId = _job;
    }

    /**
     * @dev Updates the oracle contract.
     */
    function updateFee(uint256 _fee) only_owner public {
        fee = _fee;
    }


    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function requestBadges() public returns (bytes32 requestId) {
        requestBadges(msg.sender);
    }

    function requestBadges(address _owner) public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        // Set the URL to perform the GET request on
        string memory url = string(abi.encodePacked(apiUrl, toString(_owner)));
        emit UrlRequested(url);
        request.add("get", url);

        // Sends the request
        bytes32 _requestId = sendChainlinkRequestTo(oracle, request, fee);
    }

    function checkUserBadge(address _owner, uint256 _id) public view returns(bool) {
        return badgesByUser[_owner][_id];
    }

    function getUserBadges(address _owner) public view returns(bool[] memory) {
        return badgesByUser[_owner];
    }

    /**
     * Receive the response in the form of uint256
     */
    function fulfill(bytes32 _requestId, uint256 _badgeId) from_oracle public {
        emit ApiResponse(_requestId, _badgeId);
        address badgeUser = requestByAddress[_requestId];
        bool badgeFound = false;
        for(uint256 i=0; i<totalUserBadges[badgeUser]; i++) {
            if(badgesByUser[badgeUser][i] == _badgeId) {
                badgeFound = true;
            }
        }
        if(!badgeFound) {
            string memory badgeUrl = BadgeLookup(badgeLookup).getBadgeById(_badgeId);
            mintNFT(badgeUser, badgeUrl);
            badgesByUser[badgeUser].push(_badgeId);
            totalUserBadges[badgeUser]++;
        }
    }

    /**
     * Mint the NFT.
     */
    function mintNFT(address _owner, string memory tokenURI) private {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _safeMint(_owner, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    /**
     * Token lookup for myself or someone else.
     */
    function getTokens() view public returns(uint256[] memory) {
        getTokens(msg.sender);
    }

    function getTokens(address _owner) view public returns(uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);
        if (tokenCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 totalTokens = _tokenIds.current();
            uint256 resultIndex = 0;
            for (uint256 t = 1; t <= totalTokens; t++) {
                if (_exists(t) && ownerOf(t) == _owner) {
                    result[resultIndex] = t;
                    resultIndex++;
                }
            }
            return result;
        }
    }

    /**
     * String functions necessary for appending address to a url.
     */

    function toString(address account) public pure returns(string memory) {
        return toString(abi.encodePacked(account));
    }

    function toString(uint256 value) public pure returns(string memory) {
        return toString(abi.encodePacked(value));
    }

    function toString(bytes32 value) public pure returns(string memory) {
        return toString(abi.encodePacked(value));
    }

    function toString(bytes memory data) public pure returns(string memory) {
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < data.length; i++) {
            str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }
}



