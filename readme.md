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
sMATIC deployed to 0xB97efbB5e3Ac72b8e3502CB7dC9bb8C7F334848B
sWBTC deployed to 0x085dE71C2F983b4Fb701467A2d1497447Eecd241
sMIOTA deployed to 0x874A73429C90e57Ef07F6632B7575CDB0EF8f76F
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
Call the function of unWrap(bytes32 to, bytes32 symbol, uint256 amount) in the contract of BridgeWrap, sMIOT's contract address is 0x874A73429C90e57Ef07F6632B7575CDB0EF8f76F.
```
'to' is the Ed25519 Address of atoi network. 
The Ed25519 Address is 'b1037d303dd8046df74b56d5c38e8a196f304c76414330cd8b14c17fcb830dc8' for the address of 'atoi1qzcsxlfs8hvqgm0hfdtdtsuw3gvk7vzvweq5xvxd3v2vzl7tsvxusahd7gv'.
symbol = 0x41544f4900000000000000000000000000000000000000000000000000000000
min amount is 1120000
```
### sMATIC => MATIC
Call the function of unWrap(bytes32 to, bytes32 symbol, uint256 amount) in the contract of BridgeWrap, sMATIC's contract address is 0xB97efbB5e3Ac72b8e3502CB7dC9bb8C7F334848B.
```
to =     0x0000000000000000000000005Fe47F00dBdD8c38E0606E136Db60076786f7718
symbol = 0x4554480000000000000000000000000000000000000000000000000000000000
```
### sWBTC => WBTC
Call the function of unWrap(bytes32 to, bytes32 symbol, uint256 amount) in the contract of BridgeWrap, sWBTC's contract address is 0x085dE71C2F983b4Fb701467A2d1497447Eecd241.
```
to =     0x0000000000000000000000005Fe47F00dBdD8c38E0606E136Db60076786f7718
symbol = 0x5742544300000000000000000000000000000000000000000000000000000000
```

## Bridge test beta
### multisigners
```js
    const signers = ["0xEAFeeDe1634C730767f8BB52B228409A97e20834", "0x520da6bE41DdD56719b96685aa8a16f97c6907cA","0xbC6FBA88AD1F470494095C793cEcB5AcF956f09a", "0x458a8E1cc5da9a205AFa66C3A6Fba40abf974203", "0x0cd6770bec3a5984f518b6fb296b394ad27b2e14", "0xad123dddd5128e43b807faa816a88487f46700b4"];
    const requireNum = 4;
```
### Mumbai network :
```
WBTC deployed to 0x0eddA25a338e68E935112b23C6E8a30AC216AD74
MultiSignWallet deployed to 0x869A79ef105619e55a0b20FFAd091c2EFf8bf9eF
MultiSignERC20Wallet deployed to 0x2023D77Aea434afD7433fD9f8b4E1B61Df237Ec2
```
### Shimmer evm testnet :
```
sMATIC deployed to 0x1245028D6f762a37488e981d17ef5344556b5D7a
sWBTC deployed to 0xbE723f26ef2BD23361732f9a88D1366f47D72AdB
sMIOTA deployed to 0x7104ECfa69adCe72AeFFf6ff75d7bc738C45B112
```
