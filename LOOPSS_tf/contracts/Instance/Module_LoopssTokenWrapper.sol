// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "../Interface/ERC20Interface.sol";
import "./SafeMath.sol";
import './Module_LoopssCaller.sol';
// contract Owned {
//     address public owner;
//     address public newOwner;

//     event OwnershipTransferred(address indexed _from, address indexed _to);

//     constructor() {
//         owner = msg.sender;
//     }

//     modifier onlyOwner {
//         require(msg.sender == owner);
//         _;
//     }

//     function transferOwnership(address _newOwner) public onlyOwner {
//         newOwner = _newOwner;
//     }

//     function acceptOwnership() public {
//         require(msg.sender == newOwner);
//         emit OwnershipTransferred(owner, newOwner);
//         owner = newOwner;
//         newOwner = address(0);
//     }
// }

abstract contract LoopssTokenWrapper is ERC20Interface, LoopssCaller, SafeMath {
    string public symbol;
    string public name;
    uint8 public decimals = 18;
    uint256 internal _totalSupply;
    address public wrapMinter;


    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    function approveSelf() public {
        _Loopss.approve(wrapMinter, address(this), uint256(-1));
    }

    function _mint(address _to, uint256 _amount) internal {
        // add amount for _to balance
        balances[_to] = safeAdd(balances[_to], _amount);
        // increase totalSupply
        _totalSupply = safeAdd(_totalSupply, _amount);
        emit Transfer(LOOPSSMEaddress, _to, _amount);
    }

    function _burn(address _from, uint256 _amount) internal {
        // sub amount for _from balance
        balances[_from] = safeSub(balances[_from], _amount);
        // decrease totalSupply
        _totalSupply = safeSub(_totalSupply, _amount);
        emit Transfer(_from, LOOPSSMEaddress, _amount);
    }

    function wrap(uint256 amount) external returns (bool success) {
        // 交互Loopss合约转入地址Token到本合约进行wrap
        if (
            _Loopss.transferFrom(msg.sender, wrapMinter, address(this), amount)
        ) {
            _mint(msg.sender, amount);
        }
        return true;
    }

    function unwrap(uint256 amount) external returns (bool success) {
        // 交互Loopss合约从本合约转出地址Token到Msg.sender进行拆包
        if (
            _Loopss.transferFrom(address(this), wrapMinter, msg.sender, amount)
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

}
