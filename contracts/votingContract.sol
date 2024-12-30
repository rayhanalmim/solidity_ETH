// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract Voting {
    address public owner;
    mapping(string => uint256) public votes;
    string[] public candidates;
    bool public votingEnded;

    event VoteCasted(string candidate, uint256 totalVotes);
    event VotingEnded(string winner, uint256 votes);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this");
        _;
    }

    constructor(string[] memory _candidates) {
        owner = msg.sender;
        candidates = _candidates;
    }

    function vote(string memory candidate) public {
        require(!votingEnded, "Voting has ended");
        votes[candidate]++;
        emit VoteCasted(candidate, votes[candidate]);
    }

    function endVoting() public onlyOwner {
        votingEnded = true;
        string memory winner;
        uint256 highestVotes;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (votes[candidates[i]] > highestVotes) {
                highestVotes = votes[candidates[i]];
                winner = candidates[i];
            }
        }

        emit VotingEnded(winner, highestVotes);
    }
}
