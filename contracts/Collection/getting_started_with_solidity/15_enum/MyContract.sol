// SPDX-License-Identifier: MIT
//
// https://cryptomarketpool.com/enum

pragma solidity ^0.8.0;

contract MyContract {
    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }

    Status public status;

    function ship() public {
        require(status == Status.Pending, "error: cannot ship item");
        status = Status.Shipped;
    }
}
