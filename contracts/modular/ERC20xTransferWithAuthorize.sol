// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../TransferAuthorize.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title ERC20xTransferWithAuthorize (Modular)
 * @notice ERC20 extension for modular, off-chain authorized transfers and burns (EIP-712).
 * @dev Adds `transferWithAuthorize` and `burnWithAuthorize` for meta-transactions and relayer support.
 *      Enables gasless transfers and advanced flows using signatures. Integrates OpenZeppelin ERC20 and ReentrancyGuard.
 * 
 * docs: https://isol.thefactlab.org/contracts/modular/ERC20xTransferWithAuthorize
 *
 * Arguments:
 * - domainName (string): EIP-712 domain name
 * - domainVersion (string): EIP-712 domain version
 *
 * Example:
 * import "isol/contracts/base/BasexERC20.sol";
 * import "isol/contracts/modular/ERC20xTransferWithAuthorize.sol";
 *
 * contract MyToken is BasexERC20, ERC20xTransferWithAuthorize {
 *     constructor()
 *         BasexERC20("MyToken", "MTK", 1000000)
 *         ERC20xTransferWithAuthorize(
 *          "MyToken",
 *          "1"
 *         ) 
 *     {}
 * }
 */
abstract contract ERC20xTransferWithAuthorize is ERC20, TransferAuthorize, ReentrancyGuard {
    constructor(
        string memory domainName,
        string memory domainVersion
    )
        TransferAuthorize(domainName, domainVersion)
    {}

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
