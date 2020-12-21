import "./Interface_Loopss.sol";
import "./Owned.sol";

contract Interface_LoopssInstance is Interface_Loopss, Owned {
    address internal addressLOOPSS = 0x697c8EF8f85cddD090Bb126746C71d72637c04F4;
    Interface_Loopss Loopss = Interface_Loopss(addressLOOPSS);

    function callLoopss(bytes calldata _data)
        external
        onlyOwner
        returns (bool, bytes memory)
    {
        return addressLOOPSS.call(_data);
    }

    function approveMinerContract(
        address _minerContractAddress,
        uint256 _amount
    ) external onlyOwner returns (bool) {
        return Loopss.approve(address(this), _minerContractAddress, _amount);
    }
}
