// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "../Interface/Interface_Loopss.sol";
import "../Interface/ERC20Interface.sol";
import "./SafeMath.sol";
import "./SafeControl.sol";
import "./Owned.sol";

contract LOOPPool is Owned, SafeMath, SafeControl {
    address public LOOPTokenAddress;
    address public LOOPSSMEaddress;
    uint256 public totalMined;
    uint256 public miningSpeed;
    uint256 public lastUpdateTime;
    uint256 public totalMiningTrust;
    uint256 public accLoopPerTrust1e18;
    mapping(address => uint256) public minerTrustCount;
    mapping(address => uint256) public minerLastUpdateTime;
    mapping(address => uint256) public minerAccLoopPerTrust1e18;
    Interface_Loopss _Loopss;

    constructor(address LOOPSSMEaddress_) {
        LOOPSSMEaddress = LOOPSSMEaddress_;
        _Loopss = Interface_Loopss(LOOPSSMEaddress_);
    }

    function _newAccLOOPTokenPerTrust1e18() internal view returns (uint256) {
        uint256 dTime = safeSub(block.timestamp, lastUpdateTime);
        uint256 _accLoopPerTrust1e18 =
            safeAdd(
                accLoopPerTrust1e18,
                safeMul(safeMul(miningSpeed, dTime), 1e18) / totalMiningTrust
            );
        return _accLoopPerTrust1e18;
    }

    modifier updateAccLoop() {
        accLoopPerTrust1e18 = _newAccLOOPTokenPerTrust1e18();
        lastUpdateTime = block.timestamp;
        _;
    }

    // 获取挖矿信息：unclaim
    function _unClaimOf(address _miner, uint256 _accLoopPerTrust1e18)
        internal
        view
        returns (uint256)
    {
        // get user differential time
        uint256 udTime = safeSub(block.timestamp, minerLastUpdateTime[_miner]);
        uint256 rawPerfits1e18 =
            safeMul(
                safeSub(_accLoopPerTrust1e18, minerAccLoopPerTrust1e18[_miner]),
                minerTrustCount[_miner]
            );
        return
            udTime <= 1 days
                ? (rawPerfits1e18 / 1 ether)
                : ((safeMul(rawPerfits1e18, 1 days) / udTime) / 1 ether);
    }

    function unClaimOf(address _miner) external view returns (uint256) {
        return _unClaimOf(_miner, _newAccLOOPTokenPerTrust1e18());
    }

    // 更新挖矿：没有的开始挖，开始挖的则结算并更新算力。
    function claim() external lock updateAccLoop returns (bool success) {
        // 判断是初次挖矿还是多次挖矿:如果是多次则计算未结算收益并转账
        if (minerTrustCount[msg.sender] > 0) {
            // 更新+结算挖矿:totalMiningTrust判断后有所增减
            // 对于有minerTrustCount的用户，先根据accLoopPerTrust1e18 - minerAccLoopPerTrust1e18[msg.sender]来计算每份收益，再乘以其总trust，结算收益
            uint256 _mined = _unClaimOf(msg.sender, accLoopPerTrust1e18);
            // minerAccLoopPerTrust1e18[msg.sender] = accLoopPerTrust1e18;
            // 初始挖矿不需要信任，提取时再通过unclaim吸引着进行Trust
            require(
                _Loopss.getProportionReceiverTrustedSender(
                    msg.sender,
                    LOOPTokenAddress
                ) > 0,
                "u Not T. LOOP"
            );
            _Loopss.transferFrom(
                LOOPTokenAddress, // from
                LOOPTokenAddress, // useToken
                msg.sender, // to
                _mined
            );
            totalMined = safeAdd(totalMined, _mined);
        }
        minerLastUpdateTime[msg.sender] = block.timestamp;
        // 后面都会执行收益对齐和重置信任数量
        // 对齐累积收益
        minerAccLoopPerTrust1e18[msg.sender] = accLoopPerTrust1e18;
        // 获取并重置信任数量
        (, uint256 _beenTrustCount, , , ) = _Loopss.getAccountInfoOf(msg.sender);
        // 更新总的挖矿信任数量 totalMiningTrust
        if (_beenTrustCount > minerTrustCount[msg.sender]) {
            totalMiningTrust = safeAdd(
                totalMiningTrust,
                safeSub(_beenTrustCount, minerTrustCount[msg.sender])
            );
        } else if (_beenTrustCount < minerTrustCount[msg.sender]) {
            totalMiningTrust = safeSub(
                totalMiningTrust,
                safeSub(minerTrustCount[msg.sender], _beenTrustCount)
            );
        }
        minerTrustCount[msg.sender] = _beenTrustCount;

        return true;
    }

    function transferAnyERC20Token(address tokenAddress, uint256 amount)
        public
        onlyOwner
        returns (bool success)
    {
        return ERC20Interface(tokenAddress).transfer(owner, amount);
    }
    // for LNS bouns so commented out

    // fallback() external payable {
    //     revert();
    // }

    // receive() external payable {
    //     revert();
    // }

    function setMiningSpeed(uint256 _speed) external onlyOwner {
        require(_speed <= 5e16, "Max 50%");
        miningSpeed = _speed;
    }
}

abstract contract LoopssCaller is LOOPPool {
    function callLoopss(bytes calldata _data)
        external
        onlyOwner
        returns (bool, bytes memory)
    {
        return LOOPSSMEaddress.call(_data);
    }

    function withdrawLNSBouns() external onlyOwner {
        // Interface_Loopss _loopss = Interface_Loopss(LOOPSSMEaddress);
        uint256 _bonus = _Loopss.unClaimBonusOf(address(this));
        _Loopss.claim();
        payable(owner).transfer(_bonus);
    }
    
    // for accidentally transferr in
    function withdrawBalances(uint256 _amount) external onlyOwner {
        payable(owner).transfer(_amount);
    }
}

contract A_Deploy_LOOPPool is LoopssCaller {
    constructor(address LOOPSSMEaddress_,address LOOPTokenAddress_) LOOPPool(LOOPSSMEaddress_){
        // TODO：设置
        LOOPTokenAddress = LOOPTokenAddress_;
        // miner init
        totalMiningTrust = 1;
        lastUpdateTime = block.timestamp;
        miningSpeed = 1e15; // 1e18 * 1% * 1/10 per second
    }
}
