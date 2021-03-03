// SPDX-License-Identifier: MIT
// kovan:0x880E7Df34378712107AcdaCF705c2257Bf42b1A5
pragma solidity ^0.7.6;

import "./Module_LoopssTokenWrapper.sol";

contract A_Deploy_LOOPToken is LoopssTokenWrapper {
    constructor(address LOOPSSMEaddress) LoopssCaller(LOOPSSMEaddress){
        wrapMinter = address(this);
        symbol = "LOOP"; // symbol of LOOPToken is LOOP
        name = "wraped LOOP";
        approveSelf();
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
}
