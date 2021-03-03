// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "../Interface/Interface_Loopss.sol";
import "./Owned.sol";

abstract contract LoopssCaller is Owned {
    address public LOOPSSMEaddress;
    Interface_Loopss _Loopss;
    constructor(address LOOPSSMEaddress_) {
        LOOPSSMEaddress = LOOPSSMEaddress_;
        _Loopss = Interface_Loopss(LOOPSSMEaddress_);
    }
    function callLoopss(bytes calldata _data)
        external
        onlyOwner
        returns (bool, bytes memory)
    {
        return LOOPSSMEaddress.call(_data);
    }

    function withdrawLNSBouns() external onlyOwner {
        // Interface_Loopss _loopss = Interface_Loopss(_LOOPSSMEaddress);
        uint256 _bonus = _Loopss.unClaimBonusOf(address(this));
        _Loopss.claim();
        payable(owner).transfer(_bonus);
    }

    // for accidentally transferr in
    function withdrawBalances(uint256 _amount) external onlyOwner {
        payable(owner).transfer(_amount);
    }

    function approveMinePoolContract(
        address _minerContractAddress,
        uint256 _amount
    ) external onlyOwner returns (bool) {
        return _Loopss.approve(address(this), _minerContractAddress, _amount);
    }
}
