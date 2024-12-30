// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

contract SampleContract {
    address public owner;
    uint256 public totalDonations;

    event StringUpdated(string oldString, string newString);
    event DonationReceived(address donor, uint256 amount);
    event FundsWithdrawn(address owner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to allow users to donate ether to the contract
    function donate() public payable {
        require(msg.value > 0, "Donation must be greater than 0");
        totalDonations += msg.value;
        emit DonationReceived(msg.sender, msg.value);
    }

    // Function to withdraw all funds to the owner's address
    function withdraw() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds available to withdraw");
        (bool sent, ) = payable(owner).call{value: contractBalance}("");
        require(sent, "Transfer failed");
        emit FundsWithdrawn(owner, contractBalance);
    }
}
