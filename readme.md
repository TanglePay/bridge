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
### IOTA mainnet :
```
address     : iota1qryydwght5fkguktsy9rfzarqt9gx3rvpzzkzfnpq2aalqn6mvnpq0d8wjm
public key  : 0x8786dc216e64b7f20c8ccb45ca0474d4e9819734cfe60e25c7aacae1bc8bcd6f
```
### SepoliaETH network :
```
WBTC deployed to 0x99Bd15Ca1F52633b2652C3F13F6D7026ce88b7bF as the test WBTC token
MultiSignWallet deployed to 0x54773f9c01B9A7E70e7B62EFf871BC5E310F1910 as the test ETH wallet
MultiSignERC20Wallet deployed to 0x1b562bf60d69E17e7F6C7BEec16FB8FFB419EB20 as the test WBTC wallet
```
### Shimmer evm mainnet :

```
sIOTA deployed to 0x99Bd15Ca1F52633b2652C3F13F6D7026ce88b7bF
sETH deployed to 0x54773f9c01B9A7E70e7B62EFf871BC5E310F1910
sWBTC deployed to 0x1b562bf60d69E17e7F6C7BEec16FB8FFB419EB20
```

## Example for bridge alpha
### IOTA <=> sIOTA
Send iota coin to the target address : iota1qryydwght5fkguktsy9rfzarqt9gx3rvpzzkzfnpq2aalqn6mvnpq0d8wjm. The metadata is as follows:
```json
{
    "to":"usr's evm address, 0x504dF97f0e5425Eae1D32ACBE5B2E7Dc1f1Dd9cf",
    "symbol":"sIOTA"
}
```
You can also add tag data to supply your platform in the tag, such as "Iotabee". For example, [this transaction was a wrap from SOON to sSOOn](https://explorer.shimmer.network/shimmer/block/0x6c8f0fd9b84d0f386ec5adb1eaf7d7346a5f294784a071bad0b9fa062ace5d47)

### ETH => sETH
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
### sIOTA => IOTA
Call the function of unWrap(bytes32 to, bytes32 symbol, uint256 amount) in the contract of BridgeWrap, sMIOT's contract address is 0x8AfDFfe813826e63AE96A55C86Fd4a48028F3d1a.
```
'to' is the Ed25519 Address of atoi network. 
The Ed25519 Address is 'b1037d303dd8046df74b56d5c38e8a196f304c76414330cd8b14c17fcb830dc8' for the address of 'atoi1qzcsxlfs8hvqgm0hfdtdtsuw3gvk7vzvweq5xvxd3v2vzl7tsvxusahd7gv'.
symbol = 0x41544f4900000000000000000000000000000000000000000000000000000000
min amount is 1120000
```
### sETH => ETH
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
    const signers = ["0xfb6e712F4f71D418A298EBe239889A2496f1359b", "0x380dF538Ab2587B11466d07ca5c671d33497d5Ca", "0x3Fdd4B2d69848F74E44765e6AD423198bdBD94fa", "0x5e80cf0C104D2D4f685A15deb65A319e95dd80dD", "0x9dcb974Cf7522F91F2Add8303e7BCB2221063c48", "0xeBbe638eF6dF4A3837435bB44527f8D9BA9CF981"];
    const requireNum = 4;
```
### IOTA network:
```
SMPC IOTA Address   : iota1qr3jf395mx0frslvndkzkhwe63gvwwqynh7997xm46h2lk6gv78dg5n27nc
SMPC public key     : 1bcd460eb168c5de3183eca59c9b960f8083fdd703aec23df6a2815bffac0254
```
### Eth mainnet
```
WBTC was deployed to 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599
MultiSignWallet ETH deployed to 0x7C32097EB6bA75Dc5eF370BEC9019FD09D96ab9d
MultiSignERC20Wallet WBTC deployed to 0x6c2F73072bD9bc9052D99983e36411f48fa6cDf0
```
### Shimmer L1
```
SOON Listen Address is smr1qqp86empn387atca6vvkl4flwaur9542xhphnzw0pk2m3v085szmy0p2pht
```
### Shimmer evm main
```
sIOTA deployed to 0x5dA63f4456A56a0c5Cb0B2104a3610D5CA3d48E8
sETH deployed to 0xa158A39d00C79019A01A6E86c56E96C461334Eb0
sBTC deployed to 0x1cDF3F46DbF8Cf099D218cF96A769cea82F75316
sSOON deployed to 0x3C844FB5AD27A078d945dDDA8076A4084A76E513
BridgeTxErrorRecord deployed to 0xD9B13709Ce4Ef82402c091f3fc8A93a9360A5c1e
```

## Platform Identification
* When anyone uses the bridges for wraping or unwraping, you can add a platform indentification to the transaction.
### Iota or Shimmer network
Add the platform to the Output Feature `Tag`, [the shimmer example](https://explorer.shimmer.network/shimmer/output/0xea637c81097e6928945aab16cfd43182350f84e109f44e179b8003e29c9cc1090000).
### Evm network
When calling the wrap or unwrap function in the multisign contract wallet, the platform indentification can be added to next position of `symbol`. For example, symbol = 0x735742544300496F746142656500000000000000000000000000000000000000. string `sWBTC` in bytes to hex is `7357425443`, add zero byte(`00`), then append the platform indentification as hex(`IotaBee` in bytes to hex is `496F7461426565`). Note, the length of symbol cann't be bigger than 32 bytes.



## Symbols
#### IOTA   : 0x494f544100000000000000000000000000000000000000000000000000000000
#### sIOTA  : 0x73494f5441000000000000000000000000000000000000000000000000000000
#### ETH    : 0x4554480000000000000000000000000000000000000000000000000000000000
#### sETH   : 0x7345544800000000000000000000000000000000000000000000000000000000
#### WBTC   : 0x5742544300000000000000000000000000000000000000000000000000000000
#### sBTC   : 0x7342544300000000000000000000000000000000000000000000000000000000