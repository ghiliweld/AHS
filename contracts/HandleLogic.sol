pragma solidity ^0.4.19;


contract HandleLogic is Ownable {

    uint256 public price; // price in Wei

    mapping (bytes32 => address) public handleIndex; // hash of (base, handle) => address
    mapping (bytes32 => bool) public baseRegistred; // tracks if a base is registered or not
    mapping (bytes32 => address) public baseOwner; // tracks who owns a base

    event NewBase(bytes32 _base, address indexed _address);
    event NewHandle(bytes32 _base, bytes32 _handle, address indexed _address);
    event BaseTransfered(bytes32 _base, address indexed _to);

    function registerBase(bytes32 _base) public payable {
        require(msg.value >= price); // you have to pay the price
        require(!baseRegistred[_base]); // the base can't already be registered
        baseRegistred[_base] = true; // registers base
        baseOwner[_base] = msg.sender; // you now own the base
        NewBase(_base, msg.sender);
    }

    function registerHandle(bytes32 _base, bytes32 _handle, address _addr) public {
        require(baseRegistred[_base]); // the base must exist
        require(_addr != address(0)); // no uninitialized addresses
        require(msg.sender == baseOwner[_base]); // msg.sender must own the base
        handleIndex[keccak256(_base, _handle)] = _addr; // an address gets tied to your AHS handle
        NewHandle(_base, _handle, msg.sender);
    }

    function transferBase(bytes32 _base, address _newAddress) public {
        require(baseRegistred[_base]); // the base must exist
        require(_newAddress != address(0)); // no uninitialized addresses
        require(msg.sender == baseOwner[_base]); // .sender must own the base
        ownsBase[_base] = _newAddress; // base gets transfered to new address
        BaseTransfered(_base, msg.sender);
    }

    //get price of a base
    function getPrice() public view returns(uint256) {
        return price;
    }

    // search for an address in the handleIndex mapping
    function findAddress(bytes32 _base, bytes32 _handle) public view returns(address) {
        return handleIndex[keccak256(_base, _handle)];
    }

    // check if a base is registered
    function isRegistered(bytes32 _base) public view returns(bool) {
        return baseRegistred[_base];
    }

    // check if an address owns a base
    function getBaseOwner(bytes32 _base, address _addr) public view returns(address) {
        return baseOwner[_base];
    }
}
