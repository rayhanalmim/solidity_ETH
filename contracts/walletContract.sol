// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract Wallet {
    address public owner;

    event Deposit(address indexed sender, uint256 amount);
    event Withdrawal(address indexed owner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "Must send some ether");
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        (bool sent, ) = payable(owner).call{value: amount}("");
        require(sent, "Transfer failed");
        emit Withdrawal(owner, amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
