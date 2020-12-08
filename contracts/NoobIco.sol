// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;
import "./NoobToken.sol";

// NoobToken deployed at 0x3e34cf7C6347dA5CBa804188075F8D5CC6B6A73f ( address du deployer )
// price = 100000000000000000 wei d'ether (0.1 ether)
// NoobIco deployed at  0x83508Ca7F827c526DF8993f1d3b35880B9C6767B ( address du Noob )
contract NoobIco {
  // Declare a FirstErc20 contract
  NoobErc20 public Noob;

  // The price of 1 Noob in wei;
  uint256 public price;

  // Address of Noob seller
  address payable private _seller;

  uint256 private _ratio;

  uint256 private _decimal;

  constructor(
    uint256 _price, // price pour 1 Noob
    address payable seller,
    address erc20Address
  ) public {
    _price = price;
    _seller = seller;
    Noob = NoobErc20(erc20Address);
    _decimal = (10**uint256(Noob.decimals()));
  }

  function getCurrentPrice() public view returns (uint256) {
    return price;
  }

  function getPricePerNbNoobs(uint256 nbNoobs) public view returns (uint256) {
    uint256 buyPrice = (nbNoobs * price) / _decimal;
    require(buyPrice > 0, "NoobIco: Need a higher number of Noobs");
    return buyPrice;
  }

  function getNbNoobsPerPrice(uint256 _buyPrice)
    public
    view
    returns (uint256)
  {
    uint256 nbNoobs = (_buyPrice * _decimal) / price;
    require(
      nbNoobs > 0,
      "NoobIco: Need a higher amount of ether for buying Noobs"
    );
    return nbNoobs;
  }

  receive() external payable {
    buy(getNbNoobsPerPrice(msg.value));
  }

  // nbTokens en wei de NOOB
  function buy(uint256 nbNoobs) public payable returns (bool) {
    // check if ether > 0
    require(msg.value > 0, "ICO: purchase price can not be 0");
    // check if nbNoobs > 0
    require(nbNoobs > 0, "ICO: Can not purchase 0 Noob");
    // check if enough ethers for nbNoobs
    require(
      msg.value >= getPricePerNbNoobs(nbNoobs),
      "ICO: Not enough ethers for purchase"
    );
    uint256 _realPrice = getPricePerNbNoobs(nbNoobs);
    uint256 _remaining = msg.value - _realPrice;
    Noob.transferFrom(_seller, msg.sender, nbNoobs);
    _seller.transfer(_realPrice);
    if (_remaining > 0) {
      msg.sender.transfer(_remaining);
    }
    return true;
  }
}
