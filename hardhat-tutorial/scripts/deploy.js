const {ethers}=require("hardhat");
require("dotenv").config({path:".env"});
const {AMONG_US_NFT_CONTRACT_ADDRESS}=require("../constants");

async function main(){
  // address of the the among us  contract
  const amongUsNFTContract=AMONG_US_NFT_CONTRACT_ADDRESS;
  
  /*
    A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
    so cryptoDevsTokenContract here is a factory for instances of our CryptoDevToken contract.
    */
   const amongUsTokenContract=await ethers.getContractFactory("AmongUsToken");

   //deploy the contract
   const deployedAmongUsTokenContract=await amongUsTokenContract.deploy(amongUsNFTContract);

   //print the address of the deployed contract
   console.log(
    "Among Us Token Contract Address:",
    deployedAmongUsTokenContract.address
   )
}
// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });