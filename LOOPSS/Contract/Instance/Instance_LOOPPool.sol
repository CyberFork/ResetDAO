// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
// kovan : 0x253296DE2E614A13De5FD97D58D42988b502985A
// Project:LOOPSS.me Love the world ♥
/**                                                                                                                                                                                                                                                                           
LLLLLLLLLLL                                                                                                                                                         
L:::::::::L                                                                                                                                                         
L:::::::::L                                                                                                                                                         
LL:::::::LL                                                                                                                                                         
  L:::::L                  ooooooooooo      ooooooooooo   ppppp   ppppppppp       ssssssssss       ssssssssss              mmmmmmm    mmmmmmm       eeeeeeeeeeee    
  L:::::L                oo:::::::::::oo  oo:::::::::::oo p::::ppp:::::::::p    ss::::::::::s    ss::::::::::s           mm:::::::m  m:::::::mm   ee::::::::::::ee  
  L:::::L               o:::::::::::::::oo:::::::::::::::op:::::::::::::::::p ss:::::::::::::s ss:::::::::::::s         m::::::::::mm::::::::::m e::::::eeeee:::::ee
  L:::::L               o:::::ooooo:::::oo:::::ooooo:::::opp::::::ppppp::::::ps::::::ssss:::::ss::::::ssss:::::s        m::::::::::::::::::::::me::::::e     e:::::e
  L:::::L               o::::o     o::::oo::::o     o::::o p:::::p     p:::::p s:::::s  ssssss  s:::::s  ssssss         m:::::mmm::::::mmm:::::me:::::::eeeee::::::e
  L:::::L               o::::o     o::::oo::::o     o::::o p:::::p     p:::::p   s::::::s         s::::::s              m::::m   m::::m   m::::me:::::::::::::::::e 
  L:::::L               o::::o     o::::oo::::o     o::::o p:::::p     p:::::p      s::::::s         s::::::s           m::::m   m::::m   m::::me::::::eeeeeeeeeee  
  L:::::L         LLLLLLo::::o     o::::oo::::o     o::::o p:::::p    p::::::pssssss   s:::::s ssssss   s:::::s         m::::m   m::::m   m::::me:::::::e           
LL:::::::LLLLLLLLL:::::Lo:::::ooooo:::::oo:::::ooooo:::::o p:::::ppppp:::::::ps:::::ssss::::::ss:::::ssss::::::s        m::::m   m::::m   m::::me::::::::e          
L::::::::::::::::::::::Lo:::::::::::::::oo:::::::::::::::o p::::::::::::::::p s::::::::::::::s s::::::::::::::s  ...... m::::m   m::::m   m::::m e::::::::eeeeeeee  
L::::::::::::::::::::::L oo:::::::::::oo  oo:::::::::::oo  p::::::::::::::pp   s:::::::::::ss   s:::::::::::ss   .::::. m::::m   m::::m   m::::m  ee:::::::::::::e  
LLLLLLLLLLLLLLLLLLLLLLLL   ooooooooooo      ooooooooooo    p::::::pppppppp      sssssssssss      sssssssssss     ...... mmmmmm   mmmmmm   mmmmmm    eeeeeeeeeeeeee  
                                                           p:::::p                                                                                                  
                                                           p:::::p                                                                                                  
                                                          p:::::::p                                                                                                 
                                                          p:::::::p                                                                                                 
                                                          p:::::::p                                                                                                 
                                                          ppppppppp                                                                                                                                                                                                                                                              
*/
// Power by:blog.CyberForker.com
/**
    ______      __              ______           __
  / ____/_  __/ /_  ___  _____/ ____/___  _____/ /_____  _____
 / /   / / / / __ \/ _ \/ ___/ /_  / __ \/ ___/ //_/ _ \/ ___/
/ /___/ /_/ / /_/ /  __/ /  / __/ / /_/ / /  / ,< /  __/ /
\____/\__, /_.___/\___/_/  /_/    \____/_/  /_/|_|\___/_/
     /____/
*/
// Incubator:ResetDAO.com
/**

 /$$$$$$$                                  /$$     /$$$$$$$   /$$$$$$   /$$$$$$ 
| $$__  $$                                | $$    | $$__  $$ /$$__  $$ /$$__  $$
| $$  \ $$  /$$$$$$   /$$$$$$$  /$$$$$$  /$$$$$$  | $$  \ $$| $$  \ $$| $$  \ $$
| $$$$$$$/ /$$__  $$ /$$_____/ /$$__  $$|_  $$_/  | $$  | $$| $$$$$$$$| $$  | $$
| $$__  $$| $$$$$$$$|  $$$$$$ | $$$$$$$$  | $$    | $$  | $$| $$__  $$| $$  | $$
| $$  \ $$| $$_____/ \____  $$| $$_____/  | $$ /$$| $$  | $$| $$  | $$| $$  | $$
| $$  | $$|  $$$$$$$ /$$$$$$$/|  $$$$$$$  |  $$$$/| $$$$$$$/| $$  | $$|  $$$$$$/
|__/  |__/ \_______/|_______/  \_______/   \___/  |_______/ |__/  |__/ \______/ 
                                                                                                                                                                                                                                      
 */

import "../Interface/Interface_Loopss.sol";
import "../Interface/ERC20Interface.sol";
import "./SafeMath.sol";
import "./SafeControl.sol";

contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract LOOPPool is Owned, SafeMath, SafeControl {
    address public LoopGeneTokenAddress;
    address internal addressLOOPSS = 0x8E4DfCF7fa2425eC9950f9789D2EB92142bb0C86;
    Interface_Loopss Loopss = Interface_Loopss(addressLOOPSS);

    function approveSelf() public {
        Loopss.approve(LoopGeneTokenAddress, address(this), uint256(-1));
    }

    uint256 miningSpeed;
    uint256 lastUpdateTime;
    uint256 totalMiningTrust;
    uint256 public accLoopPerTrust1e18;
    mapping(address => uint256) minerTrustCount;
    mapping(address => uint256) minerAccLoopPerTrust1e18;
    mapping(address => uint256) minerLastUpdateTime;

    // 更新挖矿：没有的开始挖，开始挖的则结算并更新算力。
    // 获取挖矿信息：unclaim
    modifier updateAccLoop() {
        uint256 dTime = safeSub(block.timestamp, lastUpdateTime);
        accLoopPerTrust1e18 = safeAdd(
            accLoopPerTrust1e18,
            safeMul(safeMul(miningSpeed, dTime), 1e18) / totalMiningTrust
        );
        lastUpdateTime = block.timestamp;
        _;
    }

    function _unClaimOf(address _miner, uint256 _accLoopPerTrust1e18)
        internal
        view
        returns (uint256)
    {
        uint256 udTime = safeSub(block.timestamp, minerLastUpdateTime[msg.sender]);
        uint256 rawPerfits1e18 =
            safeMul(
                safeSub(
                    _accLoopPerTrust1e18,
                    minerAccLoopPerTrust1e18[_miner]
                ),
                minerTrustCount[_miner]
            );
        return
            udTime <= 1 days
                ? (rawPerfits1e18 / 1 ether)
                : (safeMul(rawPerfits1e18, 1 days) / safeMul(udTime, 1 ether));
    }

    function unClaimOf(address _miner) external view returns (uint256) {
        uint256 dTime = safeSub(block.timestamp, lastUpdateTime);
        uint256 _accLoopPerTrust1e18 =
            safeAdd(
                accLoopPerTrust1e18,
                safeMul(safeMul(miningSpeed, dTime), 1e18) / totalMiningTrust
            );

        return _unClaimOf(_miner, _accLoopPerTrust1e18);
    }

    function claim() external lock updateAccLoop returns (bool success) {
        // 判断是初次挖矿还是多次挖矿:如果是多次则计算未结算收益并转账
        if (minerTrustCount[msg.sender] > 0) {
            // 更新+结算挖矿:totalMiningTrust判断后有所增减
            // 对于有minerTrustCount的用户，先根据accLoopPerTrust1e18 - minerAccLoopPerTrust1e18[msg.sender]来计算每份收益，再乘以其总trust，结算收益
            uint256 _perfits = _unClaimOf(msg.sender, accLoopPerTrust1e18);
            // minerAccLoopPerTrust1e18[msg.sender] = accLoopPerTrust1e18;
            // 初始挖矿不需要信任，提取时再通过unclaim吸引着进行Trust
            require(
                Loopss.getProportionReceiverTrustedSender(
                    msg.sender,
                    LoopGeneTokenAddress
                ) > 0,
                "u Not T. LOOP"
            );
            Loopss.transferFrom(
                LoopGeneTokenAddress, // from
                LoopGeneTokenAddress, // useToken
                msg.sender, // to
                _perfits
            );
        }
        minerLastUpdateTime[msg.sender] = block.timestamp;
        // 后面都会执行收益对齐和重置信任数量
        // 对齐累积收益
        minerAccLoopPerTrust1e18[msg.sender] = accLoopPerTrust1e18;
        // 获取并重置信任数量
        (, uint256 _beenTrustCount, , , ) = Loopss.getAccountInfoOf(msg.sender);
        minerTrustCount[msg.sender] = _beenTrustCount;
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
        
        return true;
    }

    function transferAnyERC20Token(address tokenAddress, uint256 amount)
        public
        onlyOwner
        returns (bool success)
    {
        return ERC20Interface(tokenAddress).transfer(owner, amount);
    }

    fallback() external payable {
        revert();
    }

    receive() external payable {
        revert();
    }

    function callLoopss(bytes calldata _data)
        external
        onlyOwner
        returns (bool, bytes memory)
    {
        return addressLOOPSS.call(_data);
    }


}
contract A_Deploy_LOOPPool is LOOPPool {
    constructor() {
        approveSelf();
        // TODO：设置
        LoopGeneTokenAddress = 0x880E7Df34378712107AcdaCF705c2257Bf42b1A5;
        // miner init
        totalMiningTrust = 1;
        lastUpdateTime = block.timestamp;
        miningSpeed = 1e15; // 1e18 * 1% * 1/10 per second
    }
}
