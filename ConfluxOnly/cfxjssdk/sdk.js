// Loopss主合约:0x868957d1dfdcdc5ebd44b891c3fa5d6b0405e475
// LOOPToken:0x8adeed9ba5656855622877825f7971fd475fe1b3
// LOOPPool:0x81c9d190af86325421e5500baab4d23b1bf350a8
const { Conflux } = require('js-conflux-sdk')
const conflux = new Conflux({ url: 'http://testnet.cfxchain.xyz:12537' })
conflux.getStatus().then((res) => { console.log(res) })
conflux.getAccount('0x1Da44905Ca2445cb0485939AbdD408D531998f8b').then((res) => { console.log(res) })
conflux.getAdmin('0x868957d1dfdcdc5ebd44b891c3fa5d6b0405e475').then((res) => { console.log(res) })
conflux.getEpochNumber().then((res) => { console.log(res) })
// event Topics:
// TrustEvent:0x43ddf297c46b24e4d81e6e92366f02ba5a94fc0f217f71fb15419bd34e3bb3cd
// Transfer:0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef
// NewLNS:0xc7185829b865a675a2839dbcecdfc51cbd4b6e70519e86ca432df4ceb5e1608c
// SocialMessage:0xc00fbc8d98f0e20e22259c4fed01aef03cdc6c794ab6f3b7e7142730050cb4f8
var loopssDeployEpoch = 9125510;
async function getLogs() {
    let epoch = await conflux.getEpochNumber();
    console.log(epoch);
    try {
        let logs = await conflux.getLogs({
            address: '0x868957d1dfdcdc5ebd44b891c3fa5d6b0405e475',
            fromEpoch: epoch - 20000,
            toEpoch: epoch - 2,
            limit: 100,
            topics: ['0x43ddf297c46b24e4d81e6e92366f02ba5a94fc0f217f71fb15419bd34e3bb3cd'],
        })
        console.log(logs)
    } catch (error) {
        console.log(error)
    }
}
getLogs()