pragma solidity ^0.4.19;


contract HandleLogic is Ownable {

    uint256 public price; // price in Wei

    mapping (bytes32 => mapping (bytes32 => address)) public handleIndex; // base => handle => address
    mapping (bytes32 => bool) public baseRegistred; // tracks if a base is registered or not
    mapping (address => mapping (bytes32 => bool)) public ownsBase; // tracks who owns a base and returns a bool

    event NewBase(bytes32 _base, address indexed _address);
    event NewHandle(bytes32 _base, bytes32 _handle, address indexed _address);
    event BaseTransfered(bytes32 _base, address indexed _to);

    function registerBase(bytes32 _base) public payable {
        require(msg.value >= price);
        require(_base.length > 0); // no empty bases
        require(!baseRegistred[_base]); // the base can't already be registered
        baseRegistred[_base] = true;
        ownsBase[msg.sender][_base] = true;
        NewBase(_base, msg.sender);
    }

    function registerHandle(bytes32 _base, bytes32 _handle, address _addr) public {
        require(baseRegistred[_base]); // the base must exist
        require(_addr != address(0));
        require(ownsBase[msg.sender][_base]);
        handleIndex[_base][_handle] = _addr;
        NewHandle(_base, _handle, msg.sender);
    }

    function transferBase(bytes32 _base, address _newAddress) public {
        require(baseRegistred[_base]);
        require(_newAddress != address(0));
        require(ownsBase[msg.sender][_base]);
        ownsBase[msg.sender][_base] = false;
        ownsBase[_newAddress][_base] = true;
        BaseTransfered(_base, msg.sender);
    }

    // search for an address in the handleIndex mapping
    function findAddress(bytes32 _base, bytes32 _handle) public view returns(address) {
        return handleIndex[_base][_handle];
    }

    // check if a base is registered
    function isRegistered(bytes32 _base) public view returns(bool) {
        return baseRegistred[_base];
    }

    // check if an address owns a base
    function doesOwnBase(bytes32 _base, address _addr) public view returns(bool) {
        return ownsBase[_addr][_base];
    }
}
