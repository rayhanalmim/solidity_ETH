// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

contract SampleContract {
    string public myString = "Hello World";

    event StringUpdated(string oldString, string newString);
    event RefundIssued(address recipient, uint256 amount);

    function updateString(string memory _newString) public payable {
        if(msg.value == 10 ether) {
            emit StringUpdated(myString, _newString);
            myString = _newString;
        } else {
            emit RefundIssued(msg.sender, msg.value);
            payable(msg.sender).transfer(msg.value);
        }
    }
}
