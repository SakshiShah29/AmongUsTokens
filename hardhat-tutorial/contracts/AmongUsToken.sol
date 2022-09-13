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
      mapping(uint256=>bool) public tokenIdsClaimmed;

      contrutor()

  }