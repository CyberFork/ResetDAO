// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
// Project:LOOPSS.me Love the world ♥
/**
   ,--,                                                                  
,---.'|       ,----..       ,----..   ,-.----.                           
|   | :      /   /   \     /   /   \  \    /  \    .--.--.    .--.--.    
:   : |     /   .     :   /   .     : |   :    \  /  /    '. /  /    '.  
|   ' :    .   /   ;.  \ .   /   ;.  \|   |  .\ :|  :  /`. /|  :  /`. /  
;   ; '   .   ;   /  ` ;.   ;   /  ` ;.   :  |: |;  |  |--` ;  |  |--`   
'   | |__ ;   |  ; \ ; |;   |  ; \ ; ||   |   \ :|  :  ;_   |  :  ;_     
|   | :.'||   :  | ; | '|   :  | ; | '|   : .   / \  \    `. \  \    `.  
'   :    ;.   |  ' ' ' :.   |  ' ' ' :;   | |`-'   `----.   \ `----.   \ 
|   |  ./ '   ;  \; /  |'   ;  \; /  ||   | ;      __ \  \  | __ \  \  | 
;   : ;    \   \  ',  /  \   \  ',  / :   ' |     /  /`--'  //  /`--'  / 
|   ,/      ;   :    /    ;   :    /  :   : :    '--'.     /'--'.     /  
'---'        \   \ .'      \   \ .'   |   | :      `--'---'   `--'---'   
              `---`         `---`     `---'.|                            
                                        `---`                            
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

import "./LoopssInterface.sol";
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

contract LoopssWrapper is ERC20Interface, Owned, SafeMath {
    string public symbol;
    string public name;
    uint8 public decimals = 18;
    uint256 internal _totalSupply = 0;
    address public wrapMinter;
    address internal addressLOOPSS = 0x697c8EF8f85cddD090Bb126746C71d72637c04F4;
    LoopssInterface Loopss = LoopssInterface(addressLOOPSS);

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    constructor(address minterAddress) public {
        wrapMinter = minterAddress;
        symbol = _symbolOf(wrapMinter);
        name = "LOOPSS.me wrapper";
        approveSelf();
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function approveSelf() public {
        Loopss.approve(wrapMinter, address(this), uint256(-1));
    }

    function _symbolOf(address _minter) internal view returns (string memory) {
        bytes memory _ba = bytes("w");

        string memory _LNS = Loopss.LoopNameSystem_Reverse(_minter);
        //TODO:test make sure
        1 / bytes(_LNS).length; // require(keccak256(abi.encode(_LNS)) != keccak256(abi.encode("")), "No LNS for wrapper");

        bytes memory _bb = bytes(_LNS);
        string memory ret = new string(_ba.length + _bb.length);
        bytes memory bret = bytes(ret);
        uint256 k = 0;
        for (uint256 i = 0; i < _ba.length; i++) bret[k++] = _ba[i];
        for (uint256 i = 0; i < _bb.length; i++) bret[k++] = _bb[i];
        return string(ret);
    }

    function wrap(uint256 amount) external returns (bool) {
        // 交互Loopss合约转入到本合约
        if (
            Loopss.transferFrom(msg.sender, wrapMinter, address(this), amount)
        ) {
            // increase totalSupply
            _totalSupply = safeAdd(_totalSupply, amount);
            // add amount for msg.sender balance
            balances[msg.sender] = safeAdd(balances[msg.sender], amount);

            emit Transfer(addressLOOPSS, msg.sender, amount);
        }
    }

    function unwrap(uint256 amount) external returns (bool) {
        // 交互Loopss合约从本合约转出到Msg.sender
        if (
            Loopss.transferFrom(address(this), wrapMinter, msg.sender, amount)
        ) {
            // decrease totalSupply
            _totalSupply = safeSub(_totalSupply, amount);
            // sub amount for msg.sender balance
            balances[msg.sender] = safeSub(balances[msg.sender], amount);

            emit Transfer(msg.sender, addressLOOPSS, amount);
        }
    }

    function totalSupply() public override view returns (uint256) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address tokenOwner)
        public
        override
        view
        returns (uint256 balance)
    {
        return balances[tokenOwner];
    }

    function transfer(address to, uint256 amount)
        public
        override
        returns (bool success)
    {
        balances[msg.sender] = safeSub(balances[msg.sender], amount);
        balances[to] = safeAdd(balances[to], amount);
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool success)
    {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool success) {
        balances[from] = safeSub(balances[from], amount);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], amount);
        balances[to] = safeAdd(balances[to], amount);
        emit Transfer(from, to, amount);
        return true;
    }

    function allowance(address tokenOwner, address spender)
        public
        override
        view
        returns (uint256 remaining)
    {
        return allowed[tokenOwner][spender];
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
}
