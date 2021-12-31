// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract testERC20 is ERC20 {
  constructor() ERC20("test-Token", "testToken") {
    _mint(msg.sender,10000000000000000000000 );
  }
}