# Bridge IOTA And ETH <=> Shimmer EVM
## Summary
* The IOTAMPC Bridge allows for the exchange of digital assets between the Shimmer EVM, IOTA, and other EVM networks using a combination of Multi-Party Computation (MPC) and multi-signature contract technologies. The bridge currently supports various transaction pairs between different networks, including the wrapping and unwrapping of IOTA's atoi onto the Shimmer EVM testnet and ETH & WBTC from the Polygon testnet (Mumbai) onto the Shimmer EVM testnet.
* During the Shimmer testnet period, two versions of the bridge are available: Alpha and Beta. The Alpha version is intended for user testing, while the Beta version is designed for more advanced testing with the validators running in production environments.
Overall, the IOTAMPC Bridge provides a secure, flexible, and robust solution for exchanging digital assets between the Shimmer EVM and other networks, making it a valuable tool for businesses and individuals looking to take advantage of the unique features and capabilities of these networks.

## SMPC for iota
For more details on SMPC, to see [Secure_multi-party_computation](https://en.wikipedia.org/wiki/Secure_multi-party_computation). To learn about multisignature wallets, see the [introduction](https://101blockchains.com/multisignature-wallets/). All networks like Ethereum that support EVM can create a Multisig Wallet using contract code. The IOTA net doesn't support multisig and evm yet, so we should use SMPC as the Multisig Wallet.

## Bridge test alpha
### multisigners
```js
    const signers = ["0x273a0D884aA94EB1cD8735D7B1F1451fC70a1131","0xfC0F8F40eCc0C180A707FdCe7c6FB8138705c785","0xC4607f0F8337Ac925D4353ECf8e57f8057f6ce90"];
    const requireNum = 2;
```
### Mumbai network :
```
WBTC deployed to 0x0eddA25a338e68E935112b23C6E8a30AC216AD74 as the test WBTC token
MultiSignWallet deployed to 0xb0cD1c4522c5dd243a530555562839De3A0B42d3 as the test MATIC wallet
MultiSignERC20Wallet deployed to 0x108f44932E5817eD8131261E1967233385cE39e9 as the test WBTC wallet
```
### Shimmer evm testnet :

```
sMATIC deployed to 0x3Cf63EB3afE4b4717e78eAe99d632321fc5Ce519
sWBTC deployed to 0x388b395BceB2EDB4636873A3F630565323BB53a1
sMIOTA deployed to 0xdcC4E969F081C3E967581Aa9175EF6F0a337Ae88
```

## Example for bridge alpha
### ATOI => sMIOTA
Send atoi coin to the target address : atoi1qryydwght5fkguktsy9rfzarqt9gx3rvpzzkzfnpq2aalqn6mvnpqgrk0gk. The payload data is as follows:
```json
{
    "to":"usr's evm address, 0x5Fe47F00dBdD8c38E0606E136Db60076786f7718",
    "symbol":"sMIOTA"
}
```
### MATIC => sMATIC
Send MATIC to the contract of MultiSignWallet, whose address is 0xb0cD1c4522c5dd243a530555562839De3A0B42d3, by calling the function of wrap(address to, bytes32 symbol) 
```
convert sMATIC as bytes to hex string is 734d41544943
symbol = 0x734d415449430000000000000000000000000000000000000000000000000000
```
### WBTC => sWBTC
1. Approve user's token of WBTC to the contract of MultiSignERC20Wallet, whose address is 0x108f44932E5817eD8131261E1967233385cE39e9.
2. Call the function of wrap(address to, bytes32 symbol, uint256 amount) to wrap WBTC to sWBTC to shimmer evm.
3. User can get WBTC test token from the faucet function of contract WBTC in 0x0eddA25a338e68E935112b23C6E8a30AC216AD74.
```
convert sWBTC as bytes to hex string is 7357425443
symbol = 0x7357425443000000000000000000000000000000000000000000000000000000
```
### sMIOTA => ATOI
Call the function of unWrap(bytes32 to, bytes32 symbol, uint256 amount) in the contract of BridgeWrap, sMIOT's contract address is 0x8AfDFfe813826e63AE96A55C86Fd4a48028F3d1a.
```
'to' is the Ed25519 Address of atoi network. 
The Ed25519 Address is 'b1037d303dd8046df74b56d5c38e8a196f304c76414330cd8b14c17fcb830dc8' for the address of 'atoi1qzcsxlfs8hvqgm0hfdtdtsuw3gvk7vzvweq5xvxd3v2vzl7tsvxusahd7gv'.
symbol = 0x41544f4900000000000000000000000000000000000000000000000000000000
min amount is 1120000
```
### sMATIC => MATIC
Call the function of unWrap(bytes32 to, bytes32 symbol, uint256 amount) in the contract of BridgeWrap, sMATIC's contract address is 0x3Cf63EB3afE4b4717e78eAe99d632321fc5Ce519.
```
to =     0x0000000000000000000000005Fe47F00dBdD8c38E0606E136Db60076786f7718
symbol = 0x4554480000000000000000000000000000000000000000000000000000000000
```
### sWBTC => WBTC
Call the function of unWrap(bytes32 to, bytes32 symbol, uint256 amount) in the contract of BridgeWrap, sWBTC's contract address is 0x864d8CBc426b9dC6898fECBcB5d01AeB7FbcBc1F.
```
to =     0x0000000000000000000000005Fe47F00dBdD8c38E0606E136Db60076786f7718
symbol = 0x5742544300000000000000000000000000000000000000000000000000000000
```

## Bridge test beta
### multisigners
```js
    const signers = ["0x380dF538Ab2587B11466d07ca5c671d33497d5Ca", "0x3Fdd4B2d69848F74E44765e6AD423198bdBD94fa", "0xfb6e712F4f71D418A298EBe239889A2496f1359b", "0x5e80cf0C104D2D4f685A15deb65A319e95dd80dD", "0x9dcb974Cf7522F91F2Add8303e7BCB2221063c48", "0xeBbe638eF6dF4A3837435bB44527f8D9BA9CF981"];
    const requireNum = 4;
```
### ATOI network:
```
SMPC IOTA Address : atoi1qzx5ut3qj6q3rycpkn0e2glg4vr3cr8tq2dq63wyg36hpdsz2chnckpdr8e(b477a4b11a54a6a1a3aa792878f50b49e21536bf0bfdd0876ec99fae4e4bdb08)
```

### Mumbai network :
```
WBTC deployed to 0x0eddA25a338e68E935112b23C6E8a30AC216AD74
MultiSignWallet deployed to 0x0F326747787Ec6894e9be2Af691d7451ea596660
MultiSignERC20Wallet deployed to 0xBF2F528b7d6b30Ede64a7a2D6C4819802831551b
```
### Shimmer evm testnet :
```
sMIOTA deployed to 0x1f7A07357e1E3e74A564fDeE8030f06F296AD540
sMATIC deployed to 0xB6D0FBe198bf48c7E7dad8b457994a0dBac795Ef
sWBTC deployed to 0x69499Cf6b0244AD7CEA28F6eeeb4EF4d8cd1Bc33
``` 

## Bridge Online Version
### multisigners
```js
    const signers = ["0x380dF538Ab2587B11466d07ca5c671d33497d5Ca", "0x3Fdd4B2d69848F74E44765e6AD423198bdBD94fa", "0xfb6e712F4f71D418A298EBe239889A2496f1359b", "0x5e80cf0C104D2D4f685A15deb65A319e95dd80dD", "0x9dcb974Cf7522F91F2Add8303e7BCB2221063c48", "0xeBbe638eF6dF4A3837435bB44527f8D9BA9CF981"];
    const requireNum = 4;
```
### Shimmer evm main
```
sETH was deployed to 0x7C32097EB6bA75Dc5eF370BEC9019FD09D96ab9d
sBTC was deployed to 0x6c2F73072bD9bc9052D99983e36411f48fa6cDf0
BridgeTxErrorRecord deployed to 0x3C71B92D6f54473a6c66010dF5Aa139cD42c34b0
```
### Eth mainnet
```
WBTC was deployed to 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599
MultiSignWallet ETH deployed to 0x7C32097EB6bA75Dc5eF370BEC9019FD09D96ab9d
MultiSignERC20Wallet WBTC deployed to 0x6c2F73072bD9bc9052D99983e36411f48fa6cDf0
```

19999874490903728
23051939122391348
3052064631487620
