// SPDX-License-Identifier: MIT

pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenineSwap is Ownable, AccessControl {
    using SafeMath for uint256;
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public rate = 10; 
    uint256 public feerate = 3;
    address public  feeTo;
    address public  payTo;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    
    constructor(
        address _tokenA,
        address _tokenB,
        address _payTo,
        address _feeTo
    ) public {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        payTo = _payTo;
        feeTo = _feeTo;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
    }

    function swap(uint256 _amount) public {
        require(_amount > 100000000000000000, "amount to small");
        uint256 _payback = _amount.mul(rate);
        uint256 _payfee = _amount.mul(feerate).div(100);

        // contract must have funds to keep this commitment
        require(tokenB.balanceOf(address(this)) > _payback, "insufficient contract bal");

        require(tokenA.transferFrom(msg.sender, address(this), _amount), "transfer failed");
        require(tokenB.transfer(msg.sender, _payback), "transfer failed");
        if (feerate > 0) {
            require(tokenA.transfer(feeTo, _payfee), "transfer failed");
         }

    }
    function setFeeTo(address _feeTo) public  {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a administrator");
        feeTo = _feeTo;
    }

    function setRate(uint256 _rate) public  {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a administrator");
        rate = _rate;
    }

    function aBalance() public view returns (uint256) {
        return tokenA.balanceOf(address(this));
    }

    function bBalance() public view returns (uint256) {
        return tokenB.balanceOf(address(this));
    }
    
    function ownerReclaimA() public  {
        require(msg.sender != payTo, "Caller is not a Payee");
        tokenA.transfer(msg.sender, tokenA.balanceOf(address(this)));
    }

    function ownerReclaimB() public  {
        require(msg.sender != payTo, "Caller is not a Payee");
        tokenB.transfer(msg.sender, tokenB.balanceOf(address(this)));
    }
    function flushBNB() public  {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a administrator");
        uint256 bal = address(this).balance.sub(1);
        msg.sender.transfer(bal);
    }

}