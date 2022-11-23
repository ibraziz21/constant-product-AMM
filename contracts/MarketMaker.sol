// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MarketMaker is Ownable {
    error ZeroAddress();
    error InvalidInput();
    error InvalidAddress();
    error PriceAffected();
    error ZeroShares();
    error ZeroTokens();

    IERC20 immutable tokenA;
    IERC20 immutable tokenB;

    uint private reserve1;
    uint private reserve2;

    uint private totalShares;
    mapping(address => uint) balanceOf;

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    //function to mint shares
    function mintShares(address to, uint amount) internal {
        if (to == address(0)) revert ZeroAddress();
        if (amount == 0) revert InvalidInput();

        balanceOf[to] += amount;
        totalShares += amount;
    }

    // function to burn shares
    function burnShares(address _address, uint amount) internal {
        if (_address == address(0)) revert ZeroAddress();
        if (amount == 0) revert InvalidInput();

        balanceOf[_address] -= amount;
        totalShares -= amount;
    }

    function _updateReserves(uint _reserveA, uint _reserveB) internal {
        reserve1 = _reserveA;
        reserve2 = _reserveB;
    }

    // square root internal function
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
        // else z = 0 (default value)
    }

    // find the minimum between 2 vals
    function minimum(uint x, uint y) internal pure returns (uint) {
        return x <= y ? x : y;
    }

    function swap(address tokenIn, uint amountIn)
        external
        returns (uint amountOut)
    {
        // check that address is either for token A or B
        if (tokenIn != address(tokenA) || tokenIn != address(tokenB))
            revert InvalidAddress();
        if (amountIn == 0) revert InvalidInput();

        bool isTokenA = tokenIn == address(tokenA);
        (
            IERC20 _tokenIn,
            IERC20 _tokenOut,
            uint _reserve1,
            uint _reserve2
        ) = isTokenA
                ? (tokenA, tokenB, reserve1, reserve2)
                : (tokenB, tokenA, reserve2, reserve1);

        //transfer from the tokenIn to the contract Address
        _tokenIn.transferFrom(_msgSender(), address(this), amountIn);

        //calculate tokenOut (with a 0.5% fee)
        // dy =  Ydx/ (X+dx)
        uint amountInwWithFees = (amountIn * 995) / 1000;
        amountOut =
            (_reserve1 * amountInwWithFees) /
            (_reserve2 + amountInwWithFees);

        _updateReserves(
            tokenA.balanceOf(address(this)),
            tokenB.balanceOf(address(this))
        );

        //transfer from the contract to the msgSender()
        _tokenOut.transfer(_msgSender(), amountOut);
    }

    function addLiquidity(uint amountA, uint amountB)
        external
        returns (uint shares)
    {
        //pull tokenA & tokenB
        tokenA.transferFrom(_msgSender(), address(this), amountA);
        tokenB.transferFrom(_msgSender(), address(this), amountB);

        if (reserve1 > 0 && reserve2 > 0) {
            //dy/dx = y/x or Xdy = Ydx
            if (amountA * reserve2 != amountB * reserve1)
                revert PriceAffected();
        }

        //mint shares -- f(x,y) = sqrt(xy) if new liquidity
        if (totalShares == 0) {
            shares = sqrt(amountA * amountB);
        } else {
            //S = dxT/X or dyT/Y
            uint A = (amountA * totalShares) / reserve1;
            uint B = (amountB * totalShares) / reserve2;

            shares = minimum(A, B);
        }
        if (shares == 0) revert ZeroShares();
        mintShares(_msgSender(), shares);
        //_updateReserves
        _updateReserves(
            tokenA.balanceOf(address(this)),
            tokenB.balanceOf(address(this))
        );
    }

    function removeLiquidity(uint _shares) external {
        // get amount of token A and token B for the shares provided
        //amount A out -- dx= X(S/T), dy = Y(S/T)
        uint balA = tokenA.balanceOf(address(this));
        uint balB = tokenB.balanceOf(address(this));
        uint dx = (_shares/totalShares)* balA;
        uint dy = (_shares/totalShares)* balB;

        if(dx==0 || dy ==0) revert ZeroTokens();

        // burn shares
    burnShares(_msgSender(),_shares);
        //_updateReserves
    _updateReserves((balA-dx),(balB-dy));


        tokenA.transfer(_msgSender(), dx);
        tokenB.transfer(_msgSender(),dy);
    }
}
