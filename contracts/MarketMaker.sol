// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";

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

function _updateReserves(uint _reserveA, uint _reserveB) internal {
        reserve1 = _reserveA;
        reserve2 = _reserveB;

}

    function swap(address tokenIn, uint amountIn) external returns(uint amountOut) {
// check that address is either for token A or B
    if(tokenIn != address(tokenA)|| tokenIn != address(tokenB)) revert InvalidAddress();
    if (amountIn==0) revert InvalidInput();

    bool isTokenA = tokenIn==address(tokenA);
    (IERC20 _tokenIn,IERC20 _tokenOut, uint _reserve1, uint _reserve2) = isTokenA
    ? (tokenA,tokenB, reserve1, reserve2)
    : (tokenB,tokenA, reserve2,reserve1);

//transfer from the tokenIn to the contract Address
    _tokenIn.transferFrom(_msgSender(), address(this),amountIn);
 

//calculate tokenOut (with a 0.5% fee)
// dy =  Ydx/ (X+dx)
uint amountInwWithFees = (amountIn* 995)/1000;
amountOut = (_reserve1*amountInwWithFees)/(_reserve2+amountInwWithFees);

_updateReserves(tokenA.balanceOf(address(this))
, tokenB.balanceOf(address(this)));



//transfer from the contract to the msgSender()
    _tokenOut.transfer(_msgSender(), amountOut);

    }
    function addLiquidity() external{

    }
    function removeLiquidity() external{}
}