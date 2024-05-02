// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ArtToken is ERC721URIStorage {
    uint256 private _nextTokenId = 1;

    struct ArtworkInfo {
        string artistName;
        string creationDate;
        string medium;
        string dimensions;
        string description;
        uint256 price;
    }

    mapping(uint256 => ArtworkInfo) public artworks;

    constructor() ERC721("ArtToken", "AAT") {}

    // Function to register new artwork by the creator
    function registerArtwork(
        string memory artistName,
        string memory creationDate,
        string memory medium,
        string memory dimensions,
        string memory description,
        uint256 price,
        string memory tokenURI
    ) public returns (uint256) {
        uint256 newArtworkId = _nextTokenId++;
        ArtworkInfo memory newArtwork = ArtworkInfo({
            artistName: artistName,
            creationDate: creationDate,
            medium: medium,
            dimensions: dimensions,
            description: description,
            price: price
        });
        artworks[newArtworkId] = newArtwork;
        _mint(msg.sender, newArtworkId);
        _setTokenURI(newArtworkId, tokenURI);
        return newArtworkId;
    }

    // Function to purchase artwork
    function purchaseArtwork(uint256 tokenId) public payable {
        require(msg.value == artworks[tokenId].price, "Incorrect price");
        address owner = ownerOf(tokenId);
        payable(owner).transfer(msg.value);
        _transfer(owner, msg.sender, tokenId);
    }

    // Override to return the base URI for token metadata
    function _baseURI() internal view override returns (string memory) {
        return "https://api.example.com/artwork/";
    }
}
