// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";

contract NeoToken is ERC20Capped, ERC20Burnable, Ownable {
    constructor(
        address owner_,
        uint256 initialSupply,
        uint256 cap_
    ) public ERC20("NeoToken", "NTK") ERC20Capped(cap_) {
        transferOwnership(owner_);
        _mint(owner(), initialSupply);
    }

    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20Capped, ERC20) {
        super._beforeTokenTransfer(from, to, amount);
    }
}
