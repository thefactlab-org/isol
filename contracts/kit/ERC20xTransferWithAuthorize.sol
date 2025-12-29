// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "../TransferAuthorize.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ERC20xTransferWithAuthorize (Kit)
 * @notice ERC20 extension for fast, secure, and flexible off-chain authorized transfers and burns (EIP-712).
 * @dev Adds `transferWithAuthorize` and `burnWithAuthorize` for meta-transactions and relayer support.
 *      Enables gasless transfers and advanced flows using signatures. Integrates OpenZeppelin ERC20, ReentrancyGuard, and Ownable.
 * 
 * docs: https://isol.thefactlab.org/contracts/kit/ERC20xTransferWithAuthorize
 *
 * Arguments:
 * - name (string): Token name
 * - symbol (string): Token symbol
 * - initialSupply (uint256): Initial token supply (Integer number)
 * - domainName (string): EIP-712 domain name
 * - domainVersion (string): EIP-712 domain version
 *
 * Example:
 * import "isol/contracts/kit/ERC20xTransferWithAuthorize.sol";
 *
 * contract MyToken is ERC20xTransferWithAuthorize {
 *     constructor() 
 *         ERC20xTransferWithAuthorize(
 *          "MyToken",
 *          "MTK",
 *          1000000,
 *          "MyToken",
 *          "1"
 *         ) 
 *     {}
 * }
 */
abstract contract ERC20xTransferWithAuthorize is ERC20, ERC20Burnable, TransferAuthorize, ReentrancyGuard, Ownable {
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        string memory domainName,
        string memory domainVersion
    )
        ERC20(name, symbol)
        TransferAuthorize(domainName, domainVersion)
        Ownable(msg.sender)
    {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    /// @notice Relayer-triggered transfer using an off-chain signature by `from`.
    /// @dev This allows anyone (a relayer) to submit the signed authorization on-chain.
    function transferWithAuthorize(
        address from,
        address to,
        uint256 value,
        uint256 createTime,
        uint256 expireTime,
        bytes32 nonce,
        bytes calldata auth
    ) external override nonReentrant {
        address signer = _verifyTransfer(
            from,
            to,
            value,
            createTime,
            expireTime,
            nonce,
            auth
        );
        require(signer == from, "transferWithAuthorize: invalid signature");
        _useAuthorize(from, nonce);
        _transfer(from, to, value);
    }

    /// @notice Relayer-triggered transfer using an off-chain signature by `from`.
    /// @dev This allows anyone (a relayer) to submit the signed authorization on-chain.
    function burnWithAuthorize(
        address from,
        uint256 value,
        uint256 createTime,
        uint256 expireTime,
        bytes32 nonce,
        bytes calldata auth
    ) external override nonReentrant {
        address signer = _verifyBurn(
            from,
            value,
            createTime,
            expireTime,
            nonce,
            auth
        );
        require(signer == from, "burnWithAuthorize: invalid signature");
        _useAuthorize(from, nonce);
        _burn(from, value);
    }
}
