// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTMarketplace is ERC721URIStorage {
    uint256 private tokenIdCounter;
    uint256 public platformFee = 250; // 2.5% fee

    address public owner; // Variable to store the owner address
    bool public testingMode = true; // Toggle to enable low-cost functionality

    struct NFT {
        uint256 tokenId;
        uint256 price; // The price in AVAX for the NFT
        address creator;
        bool isListed;
    }

    mapping(uint256 => NFT) public nfts;
    mapping(address => uint256[]) public ownedTokens;

    event NFTMinted(uint256 tokenId, address creator, string tokenURI, uint256 price);
    event NFTPurchased(uint256 tokenId, address buyer, uint256 price);

    // Constructor to set the initial owner of the contract
    constructor() ERC721("NFT Art Marketplace", "NFTAM") {
        owner = msg.sender; // Set the deployer as the owner
    }

    // Modifier to restrict access to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Toggle testing mode
    function toggleTestingMode() public onlyOwner {
        testingMode = !testingMode;
    }

    // Mint NFT (Allowing anyone to mint)
    function mintNFT(string memory tokenURI, uint256 price) public {
        uint256 tokenId = tokenIdCounter++;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);

        nfts[tokenId] = NFT({
            tokenId: tokenId,
            price: price,
            creator: msg.sender,
            isListed: true
        });

        ownedTokens[msg.sender].push(tokenId);

        emit NFTMinted(tokenId, msg.sender, tokenURI, price);
    }

    // Purchase NFT
    function purchaseNFT(uint256 tokenId) public payable {
        NFT storage nft = nfts[tokenId];
        require(nft.isListed, "NFT not listed for sale");

        uint256 requiredPrice = nft.price;

        // Adjust price check for testing mode
        if (testingMode) {
            // Allow for small variation in price for testing purposes (e.g., 10% tolerance)
            require(msg.value >= requiredPrice / 10, "Incorrect value sent, too low");
            require(msg.value <= requiredPrice * 11 / 10, "Incorrect value sent, too high"); // 10% tolerance
        } else {
            require(msg.value == requiredPrice, "Incorrect value sent");
        }

        // Transfer platform fee
        uint256 fee = (msg.value * platformFee) / 10000;
        if (!testingMode) {
            payable(owner).transfer(fee);
        }

        // Transfer remaining funds to creator
        payable(nft.creator).transfer(msg.value - fee);

        // Transfer the NFT to buyer
        _transfer(ownerOf(tokenId), msg.sender, tokenId);

        nft.isListed = false;

        emit NFTPurchased(tokenId, msg.sender, nft.price);
    }

    // List an NFT for sale
    function listNFT(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner of this NFT");

        NFT storage nft = nfts[tokenId];
        nft.price = price;
        nft.isListed = true;
    }

    // Delist an NFT
    function delistNFT(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner of this NFT");

        NFT storage nft = nfts[tokenId];
        nft.isListed = false;
    }

    // Change the contract owner
    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
