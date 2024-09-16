// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";

contract MyCustomToken is ERC20, AccessControl, Pausable, ERC20Burnable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    uint256 public transactionFee = 1; // 1%
    address public feeCollector; // Wallet where fees are sent
    uint256 public lockTime; // Time-lock period

    mapping(address => uint256) private lockedUntil;

    constructor(
        string memory name, 
        string memory symbol, 
        address _feeCollector
    ) ERC20(name, symbol) {
        feeCollector = _feeCollector;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
    }

    // Mint function, only callable by Minter role
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    // Override the standard transfer function to include fee deduction and time-lock
    function _transfer(address sender, address recipient, uint256 amount) internal override {
        require(block.timestamp >= lockedUntil[sender], "Tokens are time-locked");
        require(!paused(), "Token transfers are paused");

        uint256 feeAmount = (amount * transactionFee) / 100;
        uint256 sendAmount = amount - feeAmount;

        super._transfer(sender, feeCollector, feeAmount);
        super._transfer(sender, recipient, sendAmount);
    }

    // Set time-lock for tokens for a specific address
    function setLock(address account, uint256 timeInSeconds) public onlyRole(DEFAULT_ADMIN_ROLE) {
        lockedUntil[account] = block.timestamp + timeInSeconds;
    }

    // Pause function, only callable by Pauser role
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    // Unpause function, only callable by Pauser role
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    // Update the transaction fee (only by admin)
    function setTransactionFee(uint256 newFee) public onlyRole(DEFAULT_ADMIN_ROLE) {
        transactionFee = newFee;
    }

    // Update the fee collector wallet (only by admin)
    function setFeeCollector(address newCollector) public onlyRole(DEFAULT_ADMIN_ROLE) {
        feeCollector = newCollector;
    }

    // Burn function is already inherited from ERC20Burnable
}
