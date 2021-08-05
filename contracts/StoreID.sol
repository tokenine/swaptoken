// SPDX-License-Identifier: MIT

pragma solidity 0.6.6;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StoreID is Ownable, AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    mapping(uint => address) public store;

    constructor(
        address _admin
    ) public {
        _setupRole(DEFAULT_ADMIN_ROLE, _admin);
        _setupRole(ADMIN_ROLE, _admin);
    }

    function updatestore(uint _storeid, address _contract) public {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a administrator");
        store[_storeid] = _contract;
    }


}