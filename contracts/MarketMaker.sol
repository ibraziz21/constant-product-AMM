// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MarketMaker {
    IERC20 immutable tokenA;
    IERC20 immutable tokenB;

    uint private reserve1;
    uint private reserve2;

    uint private totalShares;
    mapping (address => uint) balanceOf;

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    //function to mint shares
    function mintShares(address to, uint amount) internal{
        if(to==address(0)) revert ZeroAddress();
        if (amount==0 ) revert InvalidInput();

        balanceOf[to]+=amount;
        totalShares+=amount;

    }
    // function to burn shares
    function burnShares(address _address, uint amount) internal {
        if(_address==address(0)) revert ZeroAddress();
        if (amount==0 ) revert InvalidInput();

        balanceOf[_address]-=amount;
        totalShares-=amount;

    }
}