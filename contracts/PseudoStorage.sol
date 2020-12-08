// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;
/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract PseudoStorage {

    string public pseudo;

    /*
      @dev Store value in variable
      @param string value to store
     */
    function store(string memory _pseudo) public {
        pseudo = _pseudo;
    }

    /**
     * @dev Return value 
     * @return value of 'string'
     */
    function retrieve() public view returns (string memory){
        return pseudo;
    }
}
