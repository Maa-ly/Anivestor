// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract WhiteList {
    mapping(uint256 => WhiteListStruct) public publicWhitelist;
    mapping(uint256 => WhiteListStruct) public privateWhitelist;

    struct WhiteListStruct {
        address owner;
        address[] contacts;
    }

    address public owner;

    event AddressAdded(address indexed Address);
    event AddressRemoved(address indexed Address);

    modifier onlyFarmer() {
        require(owner == msg.sender, "revert__only_farmer");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    function createPublicWhitelist(uint256 _livestockId, address _owner) external {
        publicWhitelist[_livestockId] = WhiteListStruct({
         owner: _owner,
         contacts: new address[](0)
        });
    }

    function createPrivateWhitelist(uint256 _livestockId, address _owner) external {
        privateWhitelist[_livestockId] = WhiteListStruct({
         owner: _owner,
         contacts: new address[](0)
        });
    }

    function addToPublicWhiteList(uint256 _livestockId, address Add) external {
        require(publicWhitelist[_livestockId].owner == msg.sender, "revert_Must_be_owner");
        require(Add != address(0), "revert___Must_Not_Be_Zero_Address");
        //   require(publicWhitelist[_livestockId].contract == false, "revert__Already_in_PublicWhitelist");
        address[] memory contacts = publicWhitelist[_livestockId].contacts;
        for (uint256 i = 0; i < contacts.length; i++) {
            require(contacts[i] != Add, "revert__Already_in_PublicWhitelist");
        }
        publicWhitelist[_livestockId].contacts.push(Add);
    }

    function addToPrivateWhiteList(uint256 _livestockId, address Add) external {
        require(privateWhitelist[_livestockId].owner == msg.sender, "revert_Must_be_owner");
        require(Add != address(0), "revert___Must_Not_Be_Zero_Address");
        //   require(publicWhitelist[_livestockId].contract == false, "revert__Already_in_PublicWhitelist");
        address[] memory contacts = privateWhitelist[_livestockId].contacts;
        for (uint256 i = 0; i < contacts.length; i++) {
            require(contacts[i] != Add, "revert__Already_in_PublicWhitelist");
        }
        privateWhitelist[_livestockId].contacts.push(Add);
    }

    //  function verifyWhiteList(address Add) external view returns (bool) {
    //      require(
    //          privateWhitelist[Add] == true || publicWhitelist[Add] == true, "revert_not_in_public_or_private_whitelist"
    //      );
    //      return true;
    //  }

    function isPublicWhiteList(uint256 _livestockId, address Add) external view returns (bool) {
        address[] memory contacts = publicWhitelist[_livestockId].contacts;
        for (uint256 i = 0; i < contacts.length; i++) {
            if (contacts[i] == Add) {
                return true;
            }
        }
        return false;
    }

    function isPrivateWhiteList(uint256 _livestockId, address Add) external view returns (bool) {
        address[] memory contacts = privateWhitelist[_livestockId].contacts;
        for (uint256 i = 0; i < contacts.length; i++) {
            if (contacts[i] == Add) {
                return true;
            }
        }
        return false;
    }

    //  function addToPrivateWhitelist(address Add) external onlyFarmer {
    //       require(WhiteList[_livestockId].owner == msg.sender, "revert_Must_be_owner");
    //      require(Add != address(0), "revert___Must_Not_Be_Zero_Address");
    //      require(privateWhitelist[Add] == false, "revert__Already_in_PrivateWhitelist");
    //      privateWhitelist[Add] = true;
    //  }

    function removeFromPublicWhitelist(uint256 _livestockId, address Add) external {
        require(publicWhitelist[_livestockId].owner == msg.sender, "revert_Must_be_owner");
        require(Add != address(0), "revert___Must_Not_Be_Zero_Address");
        address[] memory contacts = publicWhitelist[_livestockId].contacts;
        for (uint256 i = 0; i < contacts.length; i++) {
            if (contacts[i] == Add) {
                delete publicWhitelist[_livestockId].contacts[i];
            }
        }
    }

    function removeFromPrivateWhitelist(uint256 _livestockId, address Add) external {
        require(privateWhitelist[_livestockId].owner == msg.sender, "revert_Must_be_owner");
        require(Add != address(0), "revert___Must_Not_Be_Zero_Address");
        address[] memory contacts = privateWhitelist[_livestockId].contacts;
        for (uint256 i = 0; i < contacts.length; i++) {
            if (contacts[i] == Add) {
                delete publicWhitelist[_livestockId].contacts[i];
            }
        }
    }
}
