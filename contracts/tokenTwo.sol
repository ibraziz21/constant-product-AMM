// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract tokenTwo is ERC20{

constructor(uint _initial) ERC20("TokenB", "TKB"){

    _mint(_msgSender(),_initial);


}




}
