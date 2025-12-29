// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./ITransferAuthorize.sol";

/// @title TransferAuthorize
/// @notice Abstract helper implementing EIP-712 verification and nonce tracking for off-chain signed authorizations
/// @dev Implementations should call `_verify` and `_useAuthorize` before performing state changes
abstract contract TransferAuthorize is ITransferAuthorize, EIP712 {
    using ECDSA for bytes32;

    /// @dev mapping to track used nonces per authorizer: authorizer => nonce => used
    mapping(address => mapping(bytes32 => bool)) private _authorizeState;

    bytes32 public constant TRANSFER_TYPEHASH =
        keccak256("TransferWithAuthorize(address from,address to,uint256 value,uint256 createTime,uint256 expireTime,bytes32 nonce)");

    bytes32 public constant BURN_TYPEHASH =
        keccak256("BurnWithAuthorize(address from,uint256 value,uint256 createTime,uint256 expireTime,bytes32 nonce)");

    /// @param name EIP-712 domain name
    /// @param version EIP-712 domain version
    constructor(string memory name, string memory version) EIP712(name, version) {}

    /// @notice Check whether a nonce has been used for an authorizer
    /// @param authorizer signer address
    /// @param nonce nonce value
    /// @return true if used
    function authorizeState(address authorizer, bytes32 nonce)
        public
        view
        override
        returns (bool)
    {
        return _authorizeState[authorizer][nonce];
    }

    /// @dev Mark an authorization (authorizer + nonce) as used. Emits AuthorizeUsed.
    /// @param authorizer the signer of the authorization
    /// @param nonce the nonce used in the signed authorization
    function _useAuthorize(address authorizer, bytes32 nonce) internal {
        require(!_authorizeState[authorizer][nonce], "TransferAuthorize: authorization already used");
        _authorizeState[authorizer][nonce] = true;
        emit AuthorizeUsed(authorizer, nonce);
    }

    /// @dev Verify an EIP-712 typed signature (auth) for TransferWithAuthorize and return the recovered signer
    function _verifyTransfer(
        address from,
        address to,
        uint256 value,
        uint256 createTime,
        uint256 expireTime,
        bytes32 nonce,
        bytes calldata auth
    ) internal returns (address signer) {
        require(block.timestamp >= createTime, "TransferAuthorize: not yet created");
        require(block.timestamp <= expireTime, "TransferAuthorize: not yet expired");
        bytes32 structHash = keccak256(
            abi.encode(
                TRANSFER_TYPEHASH,
                from,
                to,
                value,
                createTime,
                expireTime,
                nonce
            )
        );
        signer = ECDSA.recover(_hashTypedDataV4(structHash), auth);
        emit TransferWithAuthorize(msg.sender, from, to, value, createTime, expireTime, nonce, auth);
    }

    /// @dev Verify an EIP-712 typed signature (auth) for BurnWithAuthorize and return the recovered signer
    function _verifyBurn(
        address from,
        uint256 value,
        uint256 createTime,
        uint256 expireTime,
        bytes32 nonce,
        bytes calldata auth
    ) internal returns (address signer) {
        require(block.timestamp >= createTime, "TransferAuthorize: not yet valid");
        require(block.timestamp <= expireTime, "TransferAuthorize: expired");
        bytes32 structHash = keccak256(
            abi.encode(
                BURN_TYPEHASH,
                from,
                value,
                createTime,
                expireTime,
                nonce
            )
        );
        signer = ECDSA.recover(_hashTypedDataV4(structHash), auth);
        emit BurnWithAuthorize(msg.sender, from, value, createTime, expireTime, nonce, auth);
    }
}
