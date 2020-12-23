// SPDX-License-Identifier: MIT
// kovan:0x8255dEf84A81A7C7E6BA5D35Cb6223AD30a572c3
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

import "./Module_LoopssWrapper.sol";

contract LoopssCaller is LoopssWrapper {
    function callLoopss(bytes calldata _data)
        external
        onlyOwner
        returns (bool, bytes memory)
    {
        return addressLOOPSS.call(_data);
    }

    function approveMinePoolContract(
        address _minerContractAddress,
        uint256 _amount
    ) external onlyOwner returns (bool) {
        return Loopss.approve(address(this), _minerContractAddress, _amount);
    }
}

contract A_Deploy_LoopMemeToken is LoopssCaller {
    constructor() {
        wrapMinter = address(this);
        symbol = "LOOP";// symbol of LoopMemeToken is LOOP
        name = "wraped LOOP";
        approveSelf();
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
}
