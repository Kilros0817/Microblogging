async function main() {

    const Microblogging = await ethers.getContractFactory("Microblogging");
    const MicrobloggingContract = await Microblogging.deploy();
    console.log("Microblogging deployed to:", MicrobloggingContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });