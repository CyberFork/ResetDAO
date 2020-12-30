contract ConfluxOnly {
    function isContract(address _addre) public pure returns (bool) {
        return uint160(_addre) > (uint160(-1) / 2) ? true : false;
    }
}