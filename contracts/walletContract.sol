// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract Wallet {
    // Mapping to store user balances
    mapping(address => uint256) public balances;

    // Event declarations
    event Deposit(address indexed sender, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    // Function to deposit Ether into the contract
    function deposit() public payable {
        require(msg.value > 0, "Must send some ether");
        balances[msg.sender] += msg.value;  // Add the deposit amount to the user's balance
        emit Deposit(msg.sender, msg.value);
    }

    // Function to withdraw Ether from the contract (up to user's balance)
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");  // Check if the user has enough balance
        balances[msg.sender] -= amount;  // Reduce the user's balance
        (bool sent, ) = payable(msg.sender).call{value: amount}("");  // Transfer Ether to the user
        require(sent, "Transfer failed");
        emit Withdrawal(msg.sender, amount);
    }

    // Function to get the user's balance
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // Function to get the contract's balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
