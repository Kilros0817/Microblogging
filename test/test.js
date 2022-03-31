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
    console.log(`Credit of ${Owner.address}:`, MicrobloggingContract.users(owner.address));
    postID ++;
    let voteID = 0;
    await MicrobloggingContract.createVote(owner.address, postID, 1);
    voteID ++;
    await MicrobloggingContract.editVote(voteID, 5);

    await MicrobloggingContract.removeVote(voteID);

  });
});