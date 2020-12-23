// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

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

contract LoopssWrapper is ERC20Interface, Owned, SafeMath {
    string public symbol;
    string public name;
    uint8 public decimals = 18;
    uint256 internal _totalSupply;
    address public wrapMinter;
    address internal addressLOOPSS = 0x8E4DfCF7fa2425eC9950f9789D2EB92142bb0C86;
    Interface_Loopss Loopss = Interface_Loopss(addressLOOPSS);

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    function approveSelf() public {
        Loopss.approve(wrapMinter, address(this), uint256(-1));
    }

    function _mint(address _to, uint256 _amount) internal {
        // increase totalSupply
        _totalSupply = safeAdd(_totalSupply, _amount);
        // add amount for _to balance
        balances[_to] = safeAdd(balances[_to], _amount);

        emit Transfer(addressLOOPSS, _to, _amount);
    }

    function _burn(address _from, uint256 _amount) internal {
        // decrease totalSupply
        _totalSupply = safeSub(_totalSupply, _amount);
        // sub amount for _from balance
        balances[_from] = safeSub(balances[_from], _amount);

        emit Transfer(_from, addressLOOPSS, _amount);
    }

    function wrap(uint256 amount) external returns (bool success) {
        // 交互Loopss合约转入到本合约
        if (
            Loopss.transferFrom(msg.sender, wrapMinter, address(this), amount)
        ) {
            _mint(msg.sender, amount);
        }
        return true;
    }

    function unwrap(uint256 amount) external returns (bool success) {
        // 交互Loopss合约从本合约转出到Msg.sender
        if (
            Loopss.transferFrom(address(this), wrapMinter, msg.sender, amount)
        ) {
            _burn(msg.sender, amount);
        }

        return true;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address tokenOwner)
        public
        view
        override
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
        view
        override
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
