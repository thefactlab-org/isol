// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ITransferAuthorize
/// @notice Interface for EIP-712 based transfer/burn authorizations (signed approvals)
/// @dev Events and function signatures used by TransferAuthorize/implementations
interface ITransferAuthorize {
    /// @notice Emitted when an authorization (nonce) has been consumed for an authorizer
    /// @param authorizer the account that signed the authorization
    /// @param nonce unique nonce used by the authorization
    event AuthorizeUsed(address authorizer, bytes32 nonce);

    /// @notice Emitted when a transfer with authorization is executed
    event TransferWithAuthorize(address sender, address from, address to, uint256 value, uint256 createTime, uint256 expireTime, bytes32 nonce, bytes auth);

    /// @notice Emitted when a burn with authorization is executed
    event BurnWithAuthorize(address sender, address from, uint256 value, uint256 createTime, uint256 expireTime, bytes32 nonce, bytes auth);

    /// @notice Returns whether a nonce has been used for a given authorizer
    /// @param authorizer the account that signed the authorization
    /// @param nonce the nonce to check
    /// @return true if the nonce was already used/consumed, false otherwise
    function authorizeState(
        address authorizer,
        bytes32 nonce
    ) external view returns (bool);

    /// @notice Execute a "transfer with authorization" - typically any relayer may submit
    function transferWithAuthorize(
        address from,
        address to,
        uint256 value,
        uint256 createTime,
        uint256 expireTime,
        bytes32 nonce,
        bytes calldata auth
    ) external;

    /// @notice Execute a "approve with authorization" - typically any relayer may submit
    function burnWithAuthorize(
        address from,
        // address to,
        uint256 value,
        uint256 validAfter,
        uint256 validBefore,
        bytes32 nonce,
        bytes calldata signature
    ) external;
}
