pragma solidity 0.8.13;

// SPDX-License-Identifier: MIT

contract Microblogging {
    
    struct Post {
        uint256 ID;
        string Caption;
        uint256 Timestamp;
        address Author;
    }

    struct Vote {
        uint256 ID;
        uint256 PostID;
        uint256 Timestamp;
        uint8 Rating;
        address Voter;   
    }

    struct CreditInfo {
        uint256 Lastreset;
        uint8 Creditsused;
    }

    uint256 cnt_post;
    uint256 num_vote;

    mapping(uint8 => uint8) public ratings;
    mapping(uint256 => Post) public posts;
    mapping(uint256 => Vote) public votes;
    mapping(address => CreditInfo) public users;
    mapping(uint256 => address) public voteByOwner;

    constructor () {

    }

    function createPost(address author, string memory caption) public {
        require(author == msg.sender, "You are not author.");
        cnt_post++;
        Post memory post = Post(cnt_post, caption, block.timestamp, author);
        posts[cnt_post] = post;
    }

    function createVote(address voter, uint256 postId, uint8 rating) public {
        require(voter == msg.sender, "You are not voter.");
        
        if(users[voter].Lastreset == 0) {
            CreditInfo memory creditInfo = CreditInfo(block.timestamp, 0);
            users[voter] = creditInfo;
        }
        if(block.timestamp - users[voter].Lastreset <= 1 days) {
            require(users[voter].Creditsused + ratings[rating] <= 40, "There isn't enough credits.");
        } else {
            users[voter].Lastreset = block.timestamp;
            users[voter].Creditsused = 0;
        }
        users[voter].Creditsused += ratings[rating];
        num_vote++;
        Vote memory vote = Vote(num_vote, postId, block.timestamp, rating, voter);
        votes[num_vote] = vote;
        voteByOwner[num_vote] = voter;
    }

    function editVote(uint256 voteId, uint8 rating) public {
        require(votes[voteId].ID != 0, "Invalid vote");
        require(voteByOwner[voteId] == msg.sender, "You are not the voter.");
        if(block.timestamp - users[msg.sender].Lastreset <= 1 days) {
            require(users[msg.sender].Creditsused - ratings[votes[voteId].Rating] + ratings[rating] <= 40, "There isn't enough credits.");
            users[msg.sender].Creditsused = users[msg.sender].Creditsused - ratings[votes[voteId].Rating] + ratings[rating];
    
        } else {
            users[msg.sender].Creditsused = ratings[rating];
            users[msg.sender].Lastreset = block.timestamp;
        }
        votes[voteId].Rating = rating;
    }

    function removeVote(uint256 voteId) public {
        require(votes[voteId].ID != 0, "Invalid vote");
        require(voteByOwner[voteId] == msg.sender, "You are not the voter.");

        delete votes[voteId];
        delete voteByOwner[voteId];
    }
}