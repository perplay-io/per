// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract PerBase is ERC20Burnable, Pausable {
    uint256 public maximumSupply;
    uint256 public totalBurned;
    address public minter;
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _cap
    )
    ERC20(
        _name,
        _symbol
    )
    {
        require(_cap > 0, "ERC20Capped: cap is 0");
        minter = _msgSender();
        maximumSupply = _cap;
        totalBurned = 0;
        _transferOwnership(_msgSender());
    }

    modifier onlyOwner() {
        require(owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    modifier onlyMinter() {
        require(_msgSender() == minter, "caller is not minter");
        _;
    }

    function setMinter(address newMinter) external onlyOwner {
        minter = newMinter;
    }

    function mint(address to, uint amount) external onlyMinter {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(to, amount);
    }

    //  if burns, total cap decreased but maximumSupply remains
    function cap() public view virtual returns (uint256) {
        return maximumSupply - totalBurned;
    }

    function _burn(address account, uint256 amount) internal virtual override {
        super._burn(account, amount);
        totalBurned += amount;
    }

    function pause() external onlyOwner {
        super._pause();
    }

    function unpause() external onlyOwner {
        super._unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        require(!paused(), "ERC20Pausable: token transfer while paused");
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}