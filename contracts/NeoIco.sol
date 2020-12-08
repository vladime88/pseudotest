// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;
import "./NeoToken.sol";

// NewToken deployed at 0x579fb12F1fE5682B0E81B37800D484b5ABf56c02
// price = 100000000000000000 wei d'ether (0.1 ether)
// NewIco deployed at 0xacBC986A8BEA22b8756577C77848197E29E5fa93
contract NewIco {
    // Declare a FirstErc20 contract
    NeoToken public token;

    // The price of 1 token in wei;
    uint256 public price;

    // Address of token seller
    address payable private _seller;

    uint256 private _decimal;

    constructor(
        uint256 _price, // price pour 1 New 0.1 Ether 100000000000000000
        address payable seller, // 
        address erc20Address
    ) public {
        price = _price;
        _seller = seller;
        token = NeoToken(erc20Address);
        _decimal = (10**uint256(token.decimals()));
    }

    function getCurrentPrice() public view returns (uint256) {
        return price;
    }

    function getPricePerNbTokens(uint256 nbTokens) public view returns (uint256) {
        uint256 buyPrice = (nbTokens * price) / _decimal;
        require(buyPrice > 0, "NewIco: Need a higher number of tokens");
        return buyPrice;
    }

    function getNbTokensPerPrice(uint256 _buyPrice) public view returns (uint256) {
        uint256 nbTokens = (_buyPrice * _decimal) / price;
        require(nbTokens > 0, "NewIco: Need a higher amount of ether for buying tokens");
        return nbTokens;
    }

    receive() external payable {
        buy(getNbTokensPerPrice(msg.value));
    }

    // nbTokens en wei de New
    function buy(uint256 nbTokens) public payable returns (bool) {
        // check if ether > 0
        require(msg.value > 0, "ICO: purchase price can not be 0");
        // check if nbTokens > 0
        require(nbTokens > 0, "ICO: Can not purchase 0 tokens");
        // check if enough ethers for nbTokens
        require(msg.value >= getPricePerNbTokens(nbTokens), "ICO: Not enough ethers for purchase");
        uint256 _realPrice = getPricePerNbTokens(nbTokens);
        uint256 _remaining = msg.value - _realPrice;
        token.transferFrom(_seller, msg.sender, nbTokens);
        _seller.transfer(_realPrice);
        if (_remaining > 0) {
            msg.sender.transfer(_remaining);
        }
        return true;
    }
}
