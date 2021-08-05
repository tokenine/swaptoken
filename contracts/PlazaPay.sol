// SPDX-License-Identifier: MIT

pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PlazaPay is Ownable, AccessControl {
    using SafeMath for uint256;
    IERC20 public tokenA;
    uint256 public feerate = 10;
    address public  feeTo;
    address public  payTo;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MERCHANT_ROLE = keccak256("MERCHANT_ROLE");
    mapping(uint => uint256) public order;

    constructor(
        address _tokenA,
        address _payTo,
        address _feeTo,
        address _admin
    ) public {
        tokenA = IERC20(_tokenA);
        payTo = _payTo;
        feeTo = _feeTo;
        _setupRole(DEFAULT_ADMIN_ROLE, _admin);
        _setupRole(ADMIN_ROLE, _admin);
        _setupRole(MERCHANT_ROLE, _admin);
    }

    function pay(uint _orderid, uint256 _amount) public {
        require(_amount > 0, "amount to small");
        uint256 _payfee = _amount.mul(feerate).div(100);
        require(tokenA.transferFrom(msg.sender, address(this), _amount), "transfer failed");
        if (feerate > 0) {
            require(tokenA.transfer(feeTo, _payfee), "transfer failed");
         }
        order[_orderid] = _amount;
    }

    function isMerchant(address _merchant) public view returns (bool) {
        return hasRole(MERCHANT_ROLE, _merchant);
    }

    function setFeeTo(address _feeTo) public  {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a administrator");
        feeTo = _feeTo;
    }

    function setFeeRate(uint256 _feerate) public  {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a administrator");
        feerate = _feerate;
    }

    function aBalance() public view returns (uint256) {
        return tokenA.balanceOf(address(this));
    }

    function ownerReclaimA() public  {
        require(hasRole(MERCHANT_ROLE, msg.sender), "Caller is not a merchant");
        tokenA.transfer(msg.sender, tokenA.balanceOf(address(this)));
    }

    function ownerReclaimBNB() public  {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a administrator");
        uint256 bal = address(this).balance.sub(1);
        msg.sender.transfer(bal);
    }

}