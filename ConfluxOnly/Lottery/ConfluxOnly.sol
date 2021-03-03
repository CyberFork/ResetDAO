// contract test160{
//     uint160 public x = uint160(address(0x8000000000000000000000000000000000000000));
// x = 730750818665451459101842416358141509827966271488
//     uint160 public y = uint160(-1);
// y = 1461501637330902918203684832716283019655932542975
//     uint160 public z = uint160(-1) / 2;
// z = 730750818665451459101842416358141509827966271487
// }
// conflux特有合约判定大法
contract ConfluxOnly {
    function isContract(address _addre) public pure returns (bool) {
        return uint160(_addre) > (uint160(-1) / 2) ? true : false;
    }
}