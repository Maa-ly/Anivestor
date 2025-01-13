// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;



/**@author Lydia && Nobel(kaleel)
 */
contract WhiteList {
 

 /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
   
    address public owner;

    mapping(uint256 => WhiteListStruct) public publicWhitelist;
    mapping(uint256 => WhiteListStruct) public privateWhitelist;

     /*//////////////////////////////////////////////////////////////
                          EVENTS
    //////////////////////////////////////////////////////////////*/

    event AddressAdded(address indexed Address);
    event AddressRemoved(address indexed Address);



    struct WhiteListStruct {
        address owner;
        address[] contacts;
    }


    
     /*//////////////////////////////////////////////////////////////
                           MODIFIER
    //////////////////////////////////////////////////////////////*/

    modifier onlyFarmer() {
        require(owner == msg.sender, "revert__only_farmer");
        _;
    }

<<<<<<< HEAD

     /*//////////////////////////////////////////////////////////////
                           FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor(address _owner) {
        owner = _owner;
=======
    constructor() {
        owner = msg.sender;
>>>>>>> b7b83c9798ecf5ccc377fe91c9a1ea89fcb0a6ae
    }

    /**
 * @notice Creates a public whitelist entry for a specific livestock ID.
 * @dev This function is called by the livestock owner to specify the public whitelist for the livestock.
 * @param _livestockId The ID of the livestock for which the public whitelist is being created.
 * @param _owner The address that will be the owner of the whitelist for this livestock.
 */

    function createPublicWhitelist(uint256 _livestockId, address _owner) external {
        publicWhitelist[_livestockId] = WhiteListStruct({owner: _owner, contacts: new address[](0)});
    }

    /**
 * @notice Creates a private whitelist entry for a specific livestock ID.
 * @dev This function is called by the livestock owner to specify the private whitelist for the livestock.
 * @param _livestockId The ID of the livestock for which the private whitelist is being created.
 * @param _owner The address that will be the owner of the whitelist for this livestock.
 */
    function createPrivateWhitelist(uint256 _livestockId, address _owner) external {
        privateWhitelist[_livestockId] = WhiteListStruct({owner: _owner, contacts: new address[](0)});
    }


    /**
 * @notice Adds an address to the public whitelist for a specific livestock ID.
 * @dev The function requires that the caller is the owner of the public whitelist for that livestock.
 * @param _livestockId The ID of the livestock.
 * @param Add The address to be added to the public whitelist.
 */
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


    /**
 * @notice Adds an address to the private whitelist for a specific livestock ID.
 * @dev The function requires that the caller is the owner of the private whitelist for that livestock.
 * @param _livestockId The ID of the livestock.
 * @param Add The address to be added to the private whitelist.
 */
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

    /**
 * @notice Removes an address from the public whitelist for a specific livestock ID.
 * @dev This function allows the owner of the public whitelist for the livestock to remove an address.
 * @param _livestockId The ID of the livestock.
 * @param Add The address to be removed from the public whitelist.
 */

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

    /**
 * @notice Removes an address from the private whitelist for a specific livestock ID.
 * @dev This function allows the owner of the private whitelist for the livestock to remove an address.
 * @param _livestockId The ID of the livestock.
 * @param Add The address to be removed from the private whitelist.
 */

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
