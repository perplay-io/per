// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./PerBase.sol";

contract Per is PerBase {
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _cap
    )
    PerBase(
    _name,
    _symbol,
    _cap
    )
    {}
}