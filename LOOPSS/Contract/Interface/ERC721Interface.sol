pragma solidity ^0.7.6;
// borrow from decentraland
interface IERC721Base {
  function totalSupply() external view returns (uint256);

  // function exists(uint256 assetId) external view returns (bool);
  function ownerOf(uint256 assetId) external view returns (address);

  function balanceOf(address holder) external view returns (uint256);
// _isContract(to) and call contract.onERC721Received
  function safeTransferFrom(address from, address to, uint256 assetId) external;
  function safeTransferFrom(address from, address to, uint256 assetId, bytes calldata userData) external;

  function transferFrom(address from, address to, uint256 assetId) external;

  function approve(address operator, uint256 assetId) external;
  // _isAuthorized 中会判断两种授权方式来通过或者驳回执行 transferfrom
  function setApprovalForAll(address operator, bool authorized) external;

  function getApprovedAddress(uint256 assetId) external view returns (address);
  function isApprovedForAll(address assetHolder, address operator) external view returns (bool);

  function isAuthorized(address operator, uint256 assetId) external view returns (bool);

  /**
  * @dev Deprecated transfer event. Now we use the standard with three parameters
  * It is only used in the ABI to get old transfer events. Do not remove
  */
  event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed assetId,
    address operator,
    bytes userData,
    bytes operatorData
  );
  /**
   * @dev Deprecated transfer event. Now we use the standard with three parameters
   * It is only used in the ABI to get old transfer events. Do not remove
   */
  event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed assetId,
    address operator,
    bytes userData
  );
  event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed assetId
  );
  event ApprovalForAll(
    address indexed holder,
    address indexed operator,
    bool authorized
  );
  event Approval(
    address indexed owner,
    address indexed operator,
    uint256 indexed assetId
  );
}