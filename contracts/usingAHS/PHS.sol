pragma solidity ^0.4.19;

// Registrar Service
// An example of a service built on top of the AHS for registering your own handle on top of a base for
// donations are optional

contract Registrar is Ownable {

    AHSInterface public ahs;
    bytes32 public base;
    uint256 public price; // owners can chose to charge for handle registration

    mapping (bytes32 => bool) public handleRegistred;
    mapping (bytes32 => address) public handleOwner; // tracks who owns a base


    event HandleTransfered(bytes32 _handle, address indexed _to);

    function Registrar(AHSInterface _ahs, bytes32 _base, uint256 _price) public {
        ahs = _ahs;
        base = _base;
        price = _price;
    }

    function registerHandle(bytes32 _handle, address _addr) public payable {
        require(_addr != address(0));
        if (handleRegistered[_handle] && msg.sender == handleOwner[_handle]) {
            ahs.registerHandle(base, _handle, _addr);
        }
        if (!handleRegistered[_handle]) {
            handleRegistered[_handle] = true;
            handleOwner[_handle] = msg.sender;
            ahs.registerHandle(base, _handle, _addr);
        } else {
            revert();
        }
    }

    function transferHandleOwnership(bytes32 _handle, address _addr) public {
        require(msg.sender == handleOwner[_handle]);
        handleOwner[_handle] = _addr;
        HandleTransfered(_handle, _addr);
    }

    function getBase() public view returns(bytes32) {
        return base;
    }

    function handleIsRegistered(bytes32 _handle) public view returns(bool) {
        return handleRegistered[_handle];
    }

    function findAddress(bytes32 _handle) public view returns(address) {
        address addr = ahs.findAddress(base, _handle);
        return addr;
    }

    function getHandleOwner(bytes32 _handle) public view returns(address) {
        return handleOwner[_handle];
    }

    function transferBaseOwnership() public {
        require(msg.sender == owner);
        ahs.transferBase(base, owner);
    }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

}
