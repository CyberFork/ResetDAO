// SPDX-License-Identifier: MIT
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
interface LoopssInterface {
    // ——————————————————————————————for ERC20 like methods
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

    function registerFee(string calldata _LNS) external pure returns (uint256);

    function registerLNS(string calldata _LNS, address _LnsOwner)
        external
        payable
        returns (bool); // locked

    function unClaimBonusOf(address _LNSer) external view returns (uint256);

    function claim() external; // locked

    function LoopNameSystem_Resolution(string calldata _name)
        external
        view
        returns (address);

    function LoopNameSystem_Reverse(address _account)
        external
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

    function setRatioMy1e18TokenForSender(
        uint256 _amountFor1e18Token, // ratio for 1e18 tokens
        address _sender // Trust receiver
    ) external returns (bool);

    function getProportionReceiverTrustedSender(
        address _receiver, // = trust sender
        address _sender // = trust receiver
    ) external view returns (uint256); // for Token _receiver and Token _sender

    function getRatioReceiver1e18TokenForSender(
        address _receiver, // = trust sender
        address _sender // = trust receiver
    ) external view returns (uint256); // If return 1e17, means 0.1 Token of sender can swap 1 Token of _receiver

    function getTrustStatesForAB(address _a, address _b)
        external
        view
        returns (
            uint256 aTb_portion, //(a → b: → means trust) = (a ← b: ← means token)
            uint256 aTb_ratio,
            uint256 bTa_portion,
            uint256 bTa_ratio
        );
    // refs for returns
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
        external
        view
        returns (uint256 balance);

    function loopAvailableAmount(
        address _startFrom,
        address[] calldata _loop,
        address _useMinterToken
    ) external view returns (uint256 input, uint256 output);

    function loopTransfer(
        address[] calldata _loop,
        uint256 _amountInput,
        uint256 _expectOutput,
        address _useMinterToken
    ) external returns (bool);
}
