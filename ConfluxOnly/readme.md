## Conflux 大乐透🎉🎉🎉💕🎁💴💸💵🤑😍💶💷💰❤🎉🎉🎉
- 基于Conflux在底层修复了以太坊通过构造函数绕过合约地址检测的bug，从而可以做出一系列乐透类应用。
但可能还是无法绕过矿工作弊。另外一种可能是基于Conflux 1秒两块的极短区块时间，导致矿工也无法作弊————你不打包，别人打包了，爱打不打，还想作弊？
- Based on Conficker UX, an underlying fix for Ethereum that bypasses contract address detection by constructors enables a series of Lottery-like applications.
But there may still be no way around the miners' cheating.Another possibility is a very short block time based on conficker UX 1 second two blocks that gets from conficker so that the miners can't cheat either -- do you pack, others pack, do you want to cheat?


---
@Conflux TestNet:收集反馈意见
添加ERC20代币合约地址到钱包 | Add ERC20 token contract address to wallet 
# 0x8adaa28c47407a7f506515c0d5ad7c40c20457d0
核心玩法：
1. 传播空投：对于任意一个新地址to，转入tokens数量大于等于1个LOT🎉即可激活新用户to地址的空投，to地址将额外得到一个LOT🎉。仅限一次。
    
2. 抽奖中奖机制：转账大于1个LOT🎉来参加。小于1个LOT🎉为普通转账，不触发任何效果。
    1. 奖金来源：转账金额的10%，直接全部放入合约中，作为奖池。早期中奖时0地址会分发10LOT🎉奖励。
    2. 抽奖方法：一个整数的LOT🎉一次。3LOT🎉自动for循环抽奖3次，3.5LOT🎉也是抽奖3次。但是扣费都是10%。连抽模式带有round传入lotteryU(uint256 _round)作为新的nonce随机数，保证自动连抽结果不同。
    3. 默认1‰ 千分之一的中奖几率(抽奖函数见下方)，中奖之后将会把合约中所有LOT🎉转给中奖者。早期0地址余额充足的情况下附带由0地址发出的10LOT🎉奖励。

Core Gameplay:Transfer is greater than 1 LOT 🎉 to attend.Less than 1 LOT 🎉 for ordinary transfer, does not trigger any effect.
1. Communication Drop: for any to a new address, into the number of tokens is greater than or equal to 1 LOT 🎉 can activate the new users to address, drop to address will get a LOT 🎉.Only once.
2. Winning mechanism of lucky draw:
    1. Bonus source: 10% of the transfer amount shall be directly put into the contract as the jackpot.Early winning 0 address will distribute 10 lot 🎉 reward.
    2. Draw method: a LOT of integer 🎉 once.3 LOT 🎉 for loop automatically draw three times, 3.5 LOT 🎉 also draw three times.But the deduction is 10%.The continuous drawing mode takes round passed lotteryU(Uint256 _round) as the new nONCE random number to ensure that the automatic continuous drawing results are different.
    3. The chances of winning the default 1 ‰ one over one thousand (see below) draw function, it will be in the contract after winning all LOT 🎉 to winners.Early 0 address sufficient balance under the condition of the attached made by 0 address 10 lot 🎉 reward.

        ```
        uint256 lotteryValve = 10;
        ……
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
                if (lotteryValve > 1) {
                    lotteryValve--;
                }
                return (false);
            }
        }
        ```
