// Project:LOOPSS.me Love the world ♥
/**
 ██▓     ▒█████   ▒█████   ██▓███    ██████   ██████ 
▓██▒    ▒██▒  ██▒▒██▒  ██▒▓██░  ██▒▒██    ▒ ▒██    ▒ 
▒██░    ▒██░  ██▒▒██░  ██▒▓██░ ██▓▒░ ▓██▄   ░ ▓██▄   
▒██░    ▒██   ██░▒██   ██░▒██▄█▓▒ ▒  ▒   ██▒  ▒   ██▒
░██████▒░ ████▓▒░░ ████▓▒░▒██▒ ░  ░▒██████▒▒▒██████▒▒
░ ▒░▓  ░░ ▒░▒░▒░ ░ ▒░▒░▒░ ▒▓▒░ ░  ░▒ ▒▓▒ ▒ ░▒ ▒▓▒ ▒ ░
░ ░ ▒  ░  ░ ▒ ▒░   ░ ▒ ▒░ ░▒ ░     ░ ░▒  ░ ░░ ░▒  ░ ░
  ░ ░   ░ ░ ░ ▒  ░ ░ ░ ▒  ░░       ░  ░  ░  ░  ░  ░  
    ░  ░    ░ ░      ░ ░                 ░        ░  
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
=======================================================================
=       ==================================       ======  =======    ===
=  ====  =================================  ====  ====    =====  ==  ==
=  ====  ========================  =======  ====  ===  ==  ===  ====  =
=  ===   ===   ====   ====   ===    ======  ====  ==  ====  ==  ====  =
=      ====  =  ==  =  ==  =  ===  =======  ====  ==  ====  ==  ====  =
=  ====  ==     ===  ====     ===  =======  ====  ==        ==  ====  =
=  ====  ==  =======  ===  ======  =======  ====  ==  ====  ==  ====  =
=  ====  ==  =  ==  =  ==  =  ===  ===  ==  ====  ==  ====  ===  ==  ==
=  ====  ===   ====   ====   ====   ==  ==       ===  ====  ====    ===
=======================================================================
 */
interface LoopssInterface {
    // ——————————————————————————————for ERC20 methods
    function totalSupply() external view returns (uint256); // return total minter

    function balanceOf(address tokenOwner)
        external
        view
        returns (uint256 balance);

    function allowance(
        address _tokenOwner,
        address _minter,
        address _spender
    ) external view returns (uint256 remaining);

    function transfer(address _to, uint256 _amount)
        external
        returns (bool success); // _amount < 1e18 for Command, which include Trust and Thin Message

    function approve(
        address _useMinterToken,
        address _spender,
        uint256 _amount
    ) external returns (bool success);

    function transferFrom(
        address _from,
        address _minter,
        address _to,
        uint256 _amount
    ) external returns (bool success);

    // for self minted
    event Transfer(address indexed from, address indexed to, uint256 tokens);
    // for other minter
    event TransferMinter(
        address indexed from,
        address indexed to,
        uint256 tokens,
        address indexed minter
    );
    // for self minted
    event Approval(
        address indexed tokenOwner,
        address indexed spender,
        uint256 tokens
    );
    // for other minter
    event ApprovalMinter(
        address indexed tokenOwner,
        address indexed spender,
        uint256 tokens,
        address indexed minter
    );
    // ——————————————————————————————for LOOPSS methods
    // ——————————————LNS
    event NewLNS(
        address indexed Owner,
        address indexed Inviter,
        string LNS,
        uint256 Inviter_Bonus,
        uint256 NowPerLNS_Profits1e18
    );

    function registerFee(string calldata _LNS) public pure returns (uint256);

    function registerLNS(string calldata _LNS, address _LnsOwner)
        external
        payable
        returns (bool); // locked

    function unClaimBonusOf(address _LNSer) external view returns (uint256);

    function claim() external; // locked

    function LoopNameSystem_Resolution(string calldata _name)
        public
        view
        returns (address);

    function LoopNameSystem_Reverse(address _account)
        public
        view
        returns (string memory);

    function getAccountInfoOf(address _account)
        external
        view
        returns (
            string memory userLNS_LNS,
            uint256 beenTrustCount,
            address inviter,
            uint256 realizedLNS_Profits1e18,
            uint256 lastUpdatePoint
        );

    // ——————————————MSG
    event SocialMessage(
        address indexed Sender,
        uint256 indexed Channel,
        string Title,
        string Content,
        address indexed Receiver
    );

    function sendSocialMessage(
        uint256 _channel,
        string calldata _title,
        string calldata _content,
        address _sendTo
    ) external returns (bool);

    // ——————————————Loopss
    event TrustEvent(
        address indexed TrustSender, //Trust sender; Token receiver
        address indexed BeenTrusted, //Token sender; Trust receiver
        uint256 indexed TrustType, // 0: deTrust, 1: Trust %, 2: Trust ratio
        uint256 TrustValue // 0:0, 1:xx%, 2: yy:1e18
    );

    function getProportionReceiverTrustedSender(
        address _receiver, // = trust sender
        address _sender // = trust receiver
    ) public view returns (uint256); // for Token _receiver and Token _sender

    function getRatioReceiver1e18TokenForSender(
        address _receiver, // = trust sender
        address _sender // = trust receiver
    ) public view returns (uint256); // If return 1e17, means 0.1 Token of sender can swap 1 Token of _receiver

    function getTrustStatesForAB(address _a, address _b)
        external
        view
        returns (
            uint256 aTb_portion, //a → b: → means trust,信任与token流动方向相反，从接收者出发指向发送者
            uint256 aTb_ratio,
            uint256 bTa_portion,
            uint256 bTa_ratio
        );
    // {
    //     return (
    //         getProportionReceiverTrustedSender(_a, _b),
    //         getRatioReceiver1e18TokenForSender(_a, _b),
    //         getProportionReceiverTrustedSender(_b, _a),
    //         getRatioReceiver1e18TokenForSender(_b, _a)
    //     );
    // }

    // not the Thin front-end balance. It's total balance include flowing balance and really decimals.
    function netBalanceOf(address _tokenOwner) external view returns (uint256);

    // The static balance include really decimals in _tokenOwner's wallet. Not include flowing balance.
    function minterBalanceOf(address _minter, address _tokenOwner)
        public
        view
        returns (uint256 balance);

    function loopAvailableAmount(
        address _startFrom,
        address[] calldata _loop,
        address _useMinterToken
    ) public view returns (uint256 input, uint256 output);

    function loopTransfer(
        address[] calldata _loop,
        uint256 _amountInput,
        uint256 _expectOutput,
        address _useMinterToken
    ) external lock returns (bool);
}
