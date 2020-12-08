// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

contract MaxInfo {


  struct Info {
    address sender;
    uint256 sender_balance;
    uint256 block_number;
    
  }

  function getInfo() public view returns (Info memory) {
    return Info(msg.sender, msg.sender.balance, block.number);
  }


  
}

