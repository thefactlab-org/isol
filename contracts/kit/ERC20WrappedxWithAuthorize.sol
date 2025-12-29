// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Wrapper.sol";
import "../TransferAuthorize.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ERC20WrappedxWithAuthorize (Kit)
 * @notice ERC20 wrapper with EIP-712 based off-chain authorized transfers and burns.
 * @dev Wraps an existing ERC20 token, adding `transferWithAuthorize` and `burnWithAuthorize` functions.
 *      Enables gasless transfers and advanced flows using signatures. Integrates OpenZeppelin ERC20Wrapper, ReentrancyGuard, and Ownable.
 * 
 * docs: https://isol.thefactlab.org/contracts/kit/ERC20WrappedxWithAuthorize
 *
 * Arguments:
 * - underlyingToken (address): Address of the underlying ERC20 token to wrap
 * - name (string): Token name
 * - symbol (string): Token symbol
 * - domainName (string): EIP-712 domain name
 * - domainVersion (string): EIP-712 domain version
 *
 * Example:
 * import "isol/contracts/kit/ERC20WrappedxWithAuthorize.sol";
 *
 * contract MyWrappedToken is ERC20WrappedxWithAuthorize {
 *     constructor() 
 *         ERC20WrappedxWithAuthorize(
 *          0x123...abc,
 *          "MyWrappedToken", 
 *          "MWTK", 
 *          "MyWrappedToken",
 *          "1"
 *         ) 
 *     {}
 * }
 */
abstract contract ERC20WrappedxWithAuthorize is ERC20, ERC20Burnable, ERC20Wrapper, TransferAuthorize, ReentrancyGuard, Ownable {
    constructor(
        address _underlyingToken,
        string memory _name,
        string memory _symbol,
        string memory _domainName,
        string memory _domainVersion
    )
        ERC20(_name, _symbol)
        ERC20Wrapper(IERC20(_underlyingToken))
        TransferAuthorize(_domainName, _domainVersion)
        Ownable(msg.sender)
    {}

    /**
     * @notice Returns the token decimals
     * @dev Overrides both ERC20 and ERC20Wrapper decimals function
     * @return uint8 decimals of the token (usually matches underlying token)
     */
    function decimals()
        public
        view
        virtual
        override(ERC20, ERC20Wrapper)
        returns (uint8)
    {
        return super.decimals();
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
