// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LaunchpadGift is Ownable, AccessControl {
    using SafeMath for uint256;
    IERC20 public tokenA;
    IERC20 public tokenB;
    IERC20 public tokenC;
    IERC20 public tokenD;
    uint256 public rate = 10; 
    uint256 public feerate = 1;
    uint256 public giftrate = 1;
    uint256 public minTokenD = 1000;
    address public  feeTo;
    uint public debug = 1;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MERCHANT_ROLE = keccak256("MERCHANT_ROLE");
    
    constructor(
        address _tokenA,
        address _tokenB,
        address _tokenC,
        address _tokenD,
        address _merchant,
        address _feeTo,
        address _admin
    ) public {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        tokenC = IERC20(_tokenC);
        tokenD = IERC20(_tokenD);
        feeTo = _feeTo;
        _setupRole(DEFAULT_ADMIN_ROLE, _admin);
        _setupRole(ADMIN_ROLE, _admin);
        _setupRole(MERCHANT_ROLE, _merchant);
    }

    function swap(uint256 _amount) public {
        require(_amount > 100000000000000000, "amount to small");
        require(tokenD.balanceOf(address(msg.sender)) > minTokenD, "sender must hold Token");
        uint256 _payback = _amount.mul(rate);
        uint256 _payfee = _amount.mul(feerate).div(100);
        uint256 _paygift = _amount.mul(giftrate).div(100);


        // contract must have funds to keep this commitment
        require(tokenB.balanceOf(address(this)) > _payback, "insufficient contract bal");

        require(tokenA.transferFrom(msg.sender, address(this), _amount), "transfer failed");
        require(tokenB.transfer(msg.sender, _payback), "transfer failed");
        if (feerate > 0) {
            require(tokenA.transfer(feeTo, _payfee), "transfer failed");
         }
        if (_paygift > 0 && tokenC.balanceOf(address(this)) > _paygift){
            require(tokenC.transfer(msg.sender, _paygift), "transfer failed");
        }

    }

    function isMerchant(address _merchant) public view returns (bool) {
        return hasRole(MERCHANT_ROLE, _merchant);
    }

    function setminTokenD(uint256 _minTokenD) public  {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a administrator");
        minTokenD = _minTokenD;
    }

    function setGifRate(uint256 _giftrate) public  {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a administrator");
        giftrate = _giftrate;
    }

    function setFeeTo(address _feeTo) public  {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a administrator");
        feeTo = _feeTo;
    }

    function setFeeRate(uint256 _feerate) public  {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a administrator");
        feerate = _feerate;
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
        require(hasRole(MERCHANT_ROLE, msg.sender), "Caller is not a merchant");
        tokenA.transfer(msg.sender, tokenA.balanceOf(address(this)));
    }

    function ownerReclaimB() public  {
        require(hasRole(MERCHANT_ROLE, msg.sender), "Caller is not a merchant");
        tokenB.transfer(msg.sender, tokenB.balanceOf(address(this)));
    }

    function ownerReclaimC() public  {
        require(hasRole(MERCHANT_ROLE, msg.sender), "Caller is not a merchant");
        tokenC.transfer(msg.sender, tokenC.balanceOf(address(this)));
    }

    function flushBNB() public  {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a administrator");
        uint256 bal = address(this).balance.sub(1);
        msg.sender.transfer(bal);
    }

}