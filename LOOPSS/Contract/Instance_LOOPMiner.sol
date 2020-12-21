// SPDX-License-Identifier: MIT
// kovan : 0x253296DE2E614A13De5FD97D58D42988b502985A
pragma solidity >=0.6.0 <0.8.0;
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

import "./Interface_Loopss.sol";
import "./ERC20Interface.sol";
import "./SafeMath.sol";

contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
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

contract LoopMining is Owned, SafeMath {
    address public LoopGeneTokenAddress;
    address internal addressLOOPSS = 0x697c8EF8f85cddD090Bb126746C71d72637c04F4;
    Interface_Loopss Loopss = Interface_Loopss(addressLOOPSS);

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    function approveSelf() public {
        Loopss.approve(LoopGeneTokenAddress, address(this), uint256(-1));
    }

    /**
创建累积每份收益变量
通过Loopss调用获取挖矿人的trustcount作为算力
每次结算时将时间累积收益div总trustcount，之后更新到每份收益变量上，
通过直接转账本地址中的LoopToken给结算人
 */
    uint256 miningSpeed;
    uint256 lastUpdateTime;
    uint256 totalMiningTrust;
    uint256 public accLoopPerTrust1e18;
    mapping(address => uint256) miningTrustCount;
    mapping(address => uint256) miningAccLoopPerTrust1e18;

    function min(uint256 _a, uint256 _b) internal pure returns (uint256) {
        if (_a < _b) {
            return _a;
        }
        return _b;
    }

    // 更新挖矿：没有的开始挖，开始挖的则结算并更新算力。
    // 获取挖矿信息：unclaim
    modifier updateAccLoop() {
        uint256 dTime = min(safeSub(now, lastUpdateTime), 86400);
        accLoopPerTrust1e18 = safeAdd(
            accLoopPerTrust1e18,
            safeMul(safeMul(miningSpeed, dTime), 1e18) /
                totalMiningTrust
        );
        lastUpdateTime = now;
        _;
    }

    function unClaimOf(address _miner) external view returns (uint256) {
        uint256 dTime = min(safeSub(now, lastUpdateTime), 86400);
        uint256 _accLoopPerTrust1e18 =
            safeAdd(
                accLoopPerTrust1e18,
                safeMul(safeMul(miningSpeed, dTime), 1e18) / totalMiningTrust
            );

        return
            safeMul(
                safeSub(
                    _accLoopPerTrust1e18, 
                    miningAccLoopPerTrust1e18[_miner]
                ),
                miningTrustCount[_miner]
            ) / 1e18;
    }

    function perfits(address _miner) internal view returns (uint256) {
        return
            safeMul(
                safeSub(accLoopPerTrust1e18, miningAccLoopPerTrust1e18[_miner]),
                miningTrustCount[_miner]
            ) / 1e18;
    }

    function claim() external updateAccLoop returns (bool) {
        // 判断是初次挖矿还是多次挖矿:如果是多次则计算未结算收益并转账
        if (miningTrustCount[msg.sender] > 0) {
            // 更新+结算挖矿:totalMiningTrust判断后有所增减
            // 对于有miningTrustCount的用户，先根据accLoopPerTrust1e18 - miningAccLoopPerTrust1e18[msg.sender]来计算每份收益，再乘以其总trust，结算收益
            uint256 _perfits = perfits(msg.sender);
            // miningAccLoopPerTrust1e18[msg.sender] = accLoopPerTrust1e18;
            require(Loopss.getProportionReceiverTrustedSender(msg.sender,LoopGeneTokenAddress) > 0,'u Not T. LOOP');
            Loopss.transferFrom(
                LoopGeneTokenAddress,
                LoopGeneTokenAddress,
                msg.sender,
                _perfits
            );
            // 获取并设置信任数量：
        }
        // 后面都会执行收益对齐和重置信任数量
        // 对齐累积收益
        miningAccLoopPerTrust1e18[msg.sender] = accLoopPerTrust1e18;
        // 获取并重置信任数量
        (, uint256 _beenTrustCount, , , ) = Loopss.getAccountInfoOf(msg.sender);
        miningTrustCount[msg.sender] = _beenTrustCount;
        // 更新总的挖矿信任数量 totalMiningTrust
        if (_beenTrustCount > miningTrustCount[msg.sender]) {
            totalMiningTrust = safeAdd(
                totalMiningTrust,
                safeSub(_beenTrustCount, miningTrustCount[msg.sender])
            );
        } else if (_beenTrustCount < miningTrustCount[msg.sender]) {
            totalMiningTrust = safeSub(
                totalMiningTrust,
                safeSub(miningTrustCount[msg.sender], _beenTrustCount)
            );
        }
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

    constructor() public {
        approveSelf();
        // TODO：设置
        LoopGeneTokenAddress = 0x8255dEf84A81A7C7E6BA5D35Cb6223AD30a572c3;
        // miner
        totalMiningTrust = 1;
        lastUpdateTime = now;
        miningSpeed = 1e15; // 1e18 * 1% * 1/10 per second
    }
}
