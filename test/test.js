const { expect } = require("chai");

describe("My Test!", function() {
  it("Microblogging", async function() {
    const [owner] = await ethers.getSigners();

    const Microblogging = await ethers.getContractFactory("Microblogging");
    const MicrobloggingContract = await Microblogging.deploy();
    console.log("Microblogging deployed to:", MicrobloggingContract.address);
    await MicrobloggingContract.deployed();

    let postID = 0;
    await MicrobloggingContract.createPost(owner.address, "This is my test post!");
    let userCredit = await MicrobloggingContract.users(owner.address);
    console.log(`Credit of ${owner.address} before post - null credit:`, userCredit);
    postID ++;
    console.log(`Created post: ${postID}`, await MicrobloggingContract.posts(postID));
    let voteID = 0;
    await MicrobloggingContract.createVote(owner.address, postID, 1);
    voteID ++;
    userCredit = await MicrobloggingContract.users(owner.address);
    console.log(`Credit of ${owner.address} after create vote:`, userCredit);
    console.log(`Vote of ${owner.address}:`, await MicrobloggingContract.votes(voteID));
    await MicrobloggingContract.editVote(voteID, 5);
    userCredit = await MicrobloggingContract.users(owner.address);
    console.log(`Credit of ${owner.address} after edit vote:`, userCredit);
    console.log(`Vote of ${owner.address} - updated:`, await MicrobloggingContract.votes(voteID));

    await MicrobloggingContract.removeVote(voteID);
    console.log("vote removed - null:", await MicrobloggingContract.votes(voteID));
  });
});