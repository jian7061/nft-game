// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const gameContractFactory = await hre.ethers.getContractFactory("MyEpicGame");
  const gameContract = await gameContractFactory.deploy(
    ["Leo", "Aang", "Pikachu"], // Names
    [
      "https://i.imgur.com/pKd5Sdk.png", // Images
      "https://i.imgur.com/xVu4vFL.png",
      "https://i.imgur.com/WMB6g9u.png",
    ],
    [100, 200, 300], // HP values
    [100, 50, 25], // Attack damage values
    "Elon Musk", // Boss name
    "https://i.imgur.com/AksR0tt.png", // Boss image
    10000, // Boss hp
    50 // Boss attack damage
  );

  await gameContract.deployed();

  console.log("Game contract deployed to:", gameContract.address);

  let txn;
  // txn = await gameContract.mintCharacterNFT(0);
  // await txn.wait();
  // console.log("Minted NFT #1");

  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait();
  console.log("Minted NFT #2");

  // txn = await gameContract.mintCharacterNFT(2);
  // await txn.wait();
  // console.log("Minted NFT #3");

  txn = await gameContract.attackBoss();
  await txn.wait();

  txn = await gameContract.attackBoss();
  await txn.wait();

  // let returnedTokenUri = await gameContract.getTokenUri(1);
  // console.log(returnedTokenUri);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
