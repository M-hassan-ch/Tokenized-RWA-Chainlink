// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {OwnerIsCreator} from "@chainlink/contracts-ccip/src/v0.8/shared/access/OwnerIsCreator.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract ERC1155Core is ERC1155, ERC1155Burnable, ERC1155Supply,OwnerIsCreator {
    address internal s_issuer;

    mapping(uint256 tokenId => string) private _tokenURIs;

    event SetIssuer(address indexed issuer);

    error ERC1155Core_CallerIsNotIssuerOrItself(address msgSender);

    modifier onlyIssuerOrItself() {
        if (msg.sender != address(this) && msg.sender != s_issuer) {
            revert ERC1155Core_CallerIsNotIssuerOrItself(msg.sender);
        }
        _;
    }

    constructor() ERC1155(""){}

    function setIssuer(address _issuer) external onlyOwner {
        s_issuer = _issuer;

        emit SetIssuer(_issuer);
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(address account, uint256 id, uint256 amount, string memory _tokenUri)
        public
        onlyIssuerOrItself
    {
        _mint(account, id, amount, "");
        _tokenURIs[id] = _tokenUri;
    }

    function mintBatch(
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        bytes memory _data,
        string[] memory _tokenUris
    ) public onlyIssuerOrItself {
        _mintBatch(_to, _ids, _amounts, _data);
        for (uint256 i = 0; i < _ids.length; ++i) {
            _tokenURIs[_ids[i]] = _tokenUris[i];
        }
    }

    function burn(address account, uint256 id, uint256 amount) override  public onlyIssuerOrItself {
        if (account != _msgSender() && !isApprovedForAll(account, _msgSender())) {
            revert ERC1155MissingApprovalForAll(_msgSender(), account);
        }

        _burn(account, id, amount);
    }

    function burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) override public onlyIssuerOrItself {
        if (account != _msgSender() && !isApprovedForAll(account, _msgSender())) {
            revert ERC1155MissingApprovalForAll(_msgSender(), account);
        }

        _burnBatch(account, ids, amounts);
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        string memory tokenURI = _tokenURIs[tokenId];

        return bytes(tokenURI).length > 0 ? tokenURI : super.uri(tokenId);
    }

    function _setURI(uint256 tokenId, string memory tokenURI) internal {
        _tokenURIs[tokenId] = tokenURI;
        emit URI(uri(tokenId), tokenId);
    }

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }
}
