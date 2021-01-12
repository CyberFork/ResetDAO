// SPDX-License-Identifier: MIT
// cfx testnet :0x8d187e3f3f697f1cd49ddc0b3138cadcde1a4abc
pragma solidity >=0.6.0 <0.8.0;

// Transfer is Lottery
// $$\                 $$\     $$\
// $$ |                $$ |    $$ |
// $$ |      $$$$$$\ $$$$$$\ $$$$$$\    $$$$$$\   $$$$$$\  $$\   $$\
// $$ |     $$  __$$\\_$$  _|\_$$  _|  $$  __$$\ $$  __$$\ $$ |  $$ |
// $$ |     $$ /  $$ | $$ |    $$ |    $$$$$$$$ |$$ |  \__|$$ |  $$ |
// $$ |     $$ |  $$ | $$ |$$\ $$ |$$\ $$   ____|$$ |      $$ |  $$ |
// $$$$$$$$\\$$$$$$  | \$$$$  |\$$$$  |\$$$$$$$\ $$ |      \$$$$$$$ |
// \________|\______/   \____/  \____/  \_______|\__|       \____$$ |
//                                                         $$\   $$ |
//                                                         \$$$$$$  |
//                                                          \______/
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
// Running on Conflux
// :'######:::'#######::'##::: ##:'########:'##:::::::'##::::'##:'##::::'##:
// '##... ##:'##.... ##: ###:: ##: ##.....:: ##::::::: ##:::: ##:. ##::'##::
//  ##:::..:: ##:::: ##: ####: ##: ##::::::: ##::::::: ##:::: ##::. ##'##:::
//  ##::::::: ##:::: ##: ## ## ##: ######::: ##::::::: ##:::: ##:::. ###::::
//  ##::::::: ##:::: ##: ##. ####: ##...:::: ##::::::: ##:::: ##::: ## ##:::
//  ##::: ##: ##:::: ##: ##:. ###: ##::::::: ##::::::: ##:::: ##:: ##:. ##::
// . ######::. #######:: ##::. ##: ##::::::: ########:. #######:: ##:::. ##:
// :......::::.......:::..::::..::..::::::::........:::.......:::..:::::..::

contract SafeMath {
    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        require(c >= a);
    }

    function safeSub(uint256 a, uint256 b) internal pure returns (uint256 c) {
        require(b <= a);
        c = a - b;
    }

    function safeMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function maxMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a * b;
        if (!(a == 0 || c / a == b)) {
            c = uint256(-1);
        }
    }

    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
        require(b > 0);
        c = a / b;
    }
}

// contract test160{
//     uint160 public x = uint160(address(0x8000000000000000000000000000000000000000));
// x = 730750818665451459101842416358141509827966271488
//     uint160 public y = uint160(-1);
// y = 1461501637330902918203684832716283019655932542975
//     uint160 public z = uint160(-1) / 2;
// z = 730750818665451459101842416358141509827966271487
// }
contract ConfluxOnly {
    function isContract(address _addre) public pure returns (bool) {
        return uint160(_addre) > (uint160(-1) / 2) ? true : false;
    }
}

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

contract LotteryToken is Owned, SafeMath, ConfluxOnly {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint256 _totalSupply;
    uint256 public lotteryFee = 10; // %
    uint256 public lotteryValve = 100; // steam?
    uint256 public initLotteryValve = 100; // 10 = 1‰
    // lottery record
    address public lastWinner;
    uint256 public accBonus;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    mapping(address => bool) public airDropTag;

    event Transfer(address indexed _from, address indexed _to, uint256 tokens);
    event Approval(
        address indexed tokenOwner,
        address indexed spender,
        uint256 tokens
    );

    constructor() public {
        symbol = "LOT🎉";
        name = "佛客给晨沨夏做的 Lottery Token🐶";
        decimals = 18;
        _totalSupply = 10000 ether;
        uint256 _devSupply = 600 ether;
        balances[msg.sender] = _devSupply;
        balances[address(0)] = _totalSupply - _devSupply;
        emit Transfer(address(0), msg.sender, _devSupply);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply - balances[address(0)];
    }


    function balanceOf(address tokenOwner) public view returns (uint256) {
        return balances[tokenOwner];
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _tokens
    ) internal {
        balances[_from] = safeSub(balances[_from], _tokens);
        balances[_to] = safeAdd(balances[_to], _tokens);
        emit Transfer(_from, _to, _tokens);
    }

    function isInteger(uint256 _num) internal pure returns(bool){
        return _num == (_num / 1 ether) * 1 ether;
    }
    function transfer(address _to, uint256 _tokens)
        public
        returns (bool success)
    {
        // 最开始转账即挖矿我是拒绝的。
        if (isContract(msg.sender) || isContract(_to) || _tokens < 1 ether || !isInteger(_tokens)) {
            // 收发方任意一方为合约则正常转账不参与分发和抽奖
            _transfer(msg.sender, _to, _tokens);
            return true;
        } else {
            // 空投
            if (!airDropTag[_to]) {
                // 每个地址的空投函数
                airDropTag[_to] = true;
                if (balances[address(0)] > 1 ether) {
                    // 地址传播空投
                    _transfer(address(0), _to, 1 ether);
                }
            }
            // 抽奖函数
            // 到了后面你跟我说转账即抽奖？ 罗老师……！ 别这样，别这样。
            // 只有EOA _to EOA的时候可以静下来抽奖
            _transfer(msg.sender, _to, safeMul(_tokens, 9) / 10);
            // 收取10%的lottery费用入奖池
            _transfer(msg.sender, address(this), _tokens / 10);
            // 十连抽 ： clone _from 米腾游
            uint256 _round = _tokens / 1 ether;
            for (uint256 i = 0; i < _round; i++) {
                if (lotteryU(i + 1)) {
                    _transfer(
                        address(this),
                        msg.sender,
                        balances[address(this)]
                    );
                    if (balances[address(0)] > 10 ether) {
                        //初始中奖空投
                        _transfer(address(0), msg.sender, 10 ether);
                    }
                    return true;
                }
            }
        }
        return true;
    }

    function setInitLotteryValve(uint256 _initLotteryValve) external onlyOwner {
        require(initLotteryValve < 10000);
        initLotteryValve = _initLotteryValve;
    }

    function lotteryU(uint256 _round) private returns (bool) {
        uint256 seed =
            uint256(
                keccak256(
                    abi.encodePacked(
                        _round +
                            (block.timestamp) +
                            (block.difficulty) +
                            ((
                                uint256(
                                    keccak256(abi.encodePacked(block.coinbase))
                                )
                            ) / (now)) +
                            (block.gaslimit) +
                            ((
                                uint256(keccak256(abi.encodePacked(msg.sender)))
                            ) / (now)) +
                            (block.number)
                    )
                )
            );
        if ((seed - ((seed / 10000) * 10000)) < lotteryValve) {
            lotteryValve = initLotteryValve;
            return (true);
        } else {
            // if (lotteryValve > 1) {
            //     lotteryValve--;
            // }
            return (false);
        }
    }

    function approve(address spender, uint256 _tokens)
        public
        returns (bool success)
    {
        allowed[msg.sender][spender] = _tokens;
        emit Approval(msg.sender, spender, _tokens);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokens
    ) public returns (bool success) {
        allowed[_from][msg.sender] = safeSub(
            allowed[_from][msg.sender],
            _tokens
        );
        _transfer(_from, _to, _tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender)
        public
        view
        returns (uint256 remaining)
    {
        return allowed[tokenOwner][spender];
    }
}
