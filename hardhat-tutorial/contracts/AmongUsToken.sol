//SPDX-license-Identifier:MIT

pragma solidity ^0.8.0;
 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
  import "@openzeppelin/contracts/access/Ownable.sol";
  import "./IAmongUs.sol";

  contract AmongUsToken is ERC20,Ownable{
    //price of one among us token
    uint256 public constant tokenPrice=0.001 ether;
    
          // Each NFT would give the user 10 tokens
      // It needs to be represented as 10 * (10 ** 18) as ERC20 tokens are represented by the smallest denomination possible for the token
      // By default, ERC20 tokens have the smallest denomination of 10^(-18). This means, having a balance of (1)
      // is actually equal to (10 ^ -18) tokens.
      // Owning 1 full token is equivalent to owning (10^18) tokens when you account for the decimal places.
      uint256 public constant tokensPerNFT=10*10**18;
      //Max total supply is 1000 for AmongUsTokens
      uint256 public constant maxTotalSupply=10000*10**18;
      //AmongUs contract instance
      IAmongUs AmongUsNFT;

      //mapping to keep the track of which tokenIds have been claimed
      mapping(uint256=>bool) public tokenIdsClaimed;

      constructor(address _amoungUsContract) ERC20("Crypto Dev Token", "CD") {
          AmongUsNFT = IAmongUs(_amoungUsContract);
      }


      //Mints `amount` number of AmongUsTokens
      //msg.value  should be equal or greater than amount*tokenprice
      function mint(uint256 amount) public payable{
        // the value of ether that should be equal or greater than tokenPrice * amount;
        uint256 _requiredAmount=tokenPrice*amount;
        require(msg.value>_requiredAmount,"Ether sent is incorrect!");
        //total tokens +amount <=10000,otherwise revert the transaction
        uint256 amountWithDecimals=amount*10**18;
        require(
          (totalSupply()+amountWithDecimals)<=maxTotalSupply,"Exceeds the max total supply available"
        );
        //call the internal function from openzepplins ERC20 contract
        _mint(msg.sender,amountWithDecimals);
      }
        /**
       * @dev Mints tokens based on the number of NFT's held by the sender
       * Requirements:
       * balance of Crypto Dev NFT's owned by the sender should be greater than 0
       * Tokens should have not been claimed for all the NFTs owned by the sender
       */

      function claim() public{
        address sender=msg.sender;
        //get the number of amoung us nfts held by the sender address
        uint256 balance=AmongUsNFT.balanceOf(sender);
        //If the balance is zero revert the transaction
        require(balance>0,"You dont own any Among Us NFTS");
        //amount keeps track of the number of unclaimed tokenids
        uint256 amount=0;
        //loop over the balance and get the token ID owned by "sender" at a given "index" of its token list
        for(uint256 i=0;i<balance;i++){
          uint256 tokenId=AmongUsNFT.tokenOfOwnerByIndex(sender,i);
          //if the tokenId has not been claimed,increase the amount
          if(!tokenIdsClaimed[tokenId]){
            amount+=1;
            tokenIdsClaimed[tokenId]=true;
          }
        }
        //if all the token ids have been claimed , revert the transaction
        require(amount>0,"You have already claimed all the tokens");
        //call the internal function from openzeppelins ERC20 contract
        //Mint (amount*10) tokens per nft
        _mint(msg.sender,amount*tokensPerNFT); 
      }

       /**
        * @dev withdraws all ETH and tokens sent to the contract
        * Requirements: 
        * wallet connected must be owner's address
        */
       function withdraw() public onlyOwner{
        address _owner=owner();
        uint256 amount = address(this).balance;
        (bool sent, )=_owner.call{value:amount}("");
        require(sent,"Failed to send Ether");
       }

      // Function to receive Ether. msg.data must be empty
      receive() external payable {}

      // Fallback function is called when msg.data is not empty
      fallback() external payable {}

       

  }