digraph G {
  graph [ ratio = "auto", page = "40" ];
  "LOOPPool";
  "Owned";
  "SafeMath";
  "SafeControl";
  "LoopssCaller";
  "A_Deploy_LOOPPool";
  "Interface_Loopss";
  "ERC20Interface";
  "LOOPPool" -> "Owned";
  "LOOPPool" -> "SafeMath";
  "LOOPPool" -> "SafeControl";
  "LoopssCaller" -> "LOOPPool";
  "A_Deploy_LOOPPool" -> "LoopssCaller";
  "LoopssCaller" -> "Owned";
}
digraph G {
  graph [ ratio = "auto", page = "40" ];
  "A_Deploy_LOOPToken";
  "LoopssTokenWrapper";
  "LOOPPool";
  "Owned";
  "SafeMath";
  "SafeControl";
  "LoopssCaller";
  "A_Deploy_LOOPPool";
  "Interface_Loopss";
  "ERC20Interface";
  "A_Deploy_LOOPToken" -> "LoopssTokenWrapper";
  "LOOPPool" -> "Owned";
  "LOOPPool" -> "SafeMath";
  "LOOPPool" -> "SafeControl";
  "LoopssCaller" -> "LOOPPool";
  "A_Deploy_LOOPPool" -> "LoopssCaller";
  "LoopssCaller" -> "Owned";
  "LoopssTokenWrapper" -> "ERC20Interface";
  "LoopssTokenWrapper" -> "LoopssCaller";
  "LoopssTokenWrapper" -> "SafeMath";
}


# ResetDAO
- Module_LoopssWrapper.sol → Instance_LoopMemeToken.sol
- Module_LoopssWrapper.sol → Instance_TokenWrapper.sol
- Instance_LOOPPool.sol