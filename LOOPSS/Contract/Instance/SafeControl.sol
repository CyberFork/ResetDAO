// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
contract SafeControl{
    /// @dev 代码安全锁，放在函数修饰符位置即可避免重入,执行完后才解锁 Borrow from UniswapV2Pair.sol
    uint256 private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, "Loop: LOCKED");
        unlocked = 0;
        _;
        unlocked = 1;
    }
}