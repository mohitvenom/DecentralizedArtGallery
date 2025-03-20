// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedArtGallery {
    struct Art {
        uint256 id;
        address artist;
        string metadata;
        uint256 price;
        bool isForSale;
    }

    mapping(uint256 => Art) public artworks;
    uint256 public nextArtId;
    
    event ArtRegistered(uint256 id, address artist, string metadata, uint256 price);
    event ArtSold(uint256 id, address buyer, uint256 price);

    function registerArt(string memory metadata, uint256 price) public {
        artworks[nextArtId] = Art(nextArtId, msg.sender, metadata, price, true);
        emit ArtRegistered(nextArtId, msg.sender, metadata, price);
        nextArtId++;
    }

    function buyArt(uint256 artId) public payable {
        require(artworks[artId].isForSale, "Art not for sale");
        require(msg.value == artworks[artId].price, "Incorrect price");

        address payable artist = payable(artworks[artId].artist);
        artist.transfer(msg.value);
        artworks[artId].isForSale = false;

        emit ArtSold(artId, msg.sender, msg.value);
    }
}
