# MyCustomToken

This is a customizable ERC-20 token with additional features such as minting, burning, pausing, transaction fees, time-locking, and access control.

## Features included
1. `Minting` – Allows tokens to be created by an authorized entity.

2. `Burning` – Allows token holders to destroy their tokens.

3. `Pausing` – Pauses all token transfers when needed.
Access Control – Role-based access for minting, burning, and pausing.

4. `Governance` – Includes role management for governance actions.

5. `Transaction Fees` – Fee charged on every transfer.

6. `Time Locking` – Tokens are locked for a specific time before they can be transferred.

7. `Tax Mechanism` – Deducts a tax and sends it to a specified wallet on every transfer.

## Setup and Deployment

****Prerequisites****

- Node.js and npm installed on your system.
- **Hardhat installed globally** : `npm install --save-dev hardhat.`
- **OpenZeppelin Contracts** : This contract uses OpenZeppelin's ERC-20, AccessControl, and Pausable extensions.
## 1.Clone or Download the repository

``` 
git clone <repository-url> cd <repository-folder> 
```
## 2.Install Dependencies

``` 
npm install 
```
## 3.Compile the Contract
```
npx hardhat compile
```
## 4.Set Up the Hardhat Environment
``` 
npx hardhat
```
## 5.Deploy the Contract
Create a new file deploy.js in the scripts folder with the following deployment script: 
``` 
async function main() {
    const MyCustomToken = await ethers.getContractFactory("MyCustomToken");
    const token = await MyCustomToken.deploy("Custom Token", "CTKN", "0xYourFeeCollectorAddressHere");
    await token.deployed();
    console.log("Token deployed to:", token.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
```

**Then run**:
```
npx hardhat run scripts/deploy.js --network localhost
```
## 6.Testing
**Minting**

Mint tokens to a specific address (only callable by minters):
```
token.mint("0xRecipientAddress", 1000); 
```
**Burning**

Burn tokens from your account:
```
token.burn(1000);
``` 
**Pausing**

Pause the contract to stop transfers:
``` 
token.pause();
``` 
**Time-Locking**

Lock tokens for a specific address for a given period:
```
token.setLock("0xRecipientAddress", 3600); // 1 hour
```
**Transaction Fees**

A fee of 1% is deducted from every transfer and sent to the fee collector: 
``` 
token.transfer("0xRecipientAddress", 100); 
```
## 7. Roles Management
- **Admin** : Manages the roles, fees, and other settings.
- **Minter** : Allowed to mint new tokens.
- **Pauser** : Allowed to pause/unpause token transfers.

To grant roles:
```
token.grantRole(MINTER_ROLE, "0xMinterAddress");
token.grantRole(PAUSER_ROLE, "0xPauserAddress");
```
## 8. Future Enhancements
- **Governance**: Implement voting mechanisms for community-driven changes.
- **Staking**: Add staking functionality to earn rewards.
