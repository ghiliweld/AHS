pragma solidity ^0.4.19;

/*
@title Address Handle Service aka AHS
@author Ghilia Weldesselasie, founder of D-OZ and genius extraordinaire
@twitter: @ghiliweld, my DMs are open so slide through if you trynna chat ;)

This is a simple alternative to ENS I made cause ENS was too complicated
for me to understand which seemed odd since it should be simple in my opinion.

Please donate if you like it, all the proceeds go towards funding D-OZ, my project.
*/

contract AHS {

    address public owner;

    mapping (bytes32 => address) public handleToAddresses;
    mapping (bytes32 => bool) public handleRegistred;
    mapping (address => mapping (bytes32 => bool)) public ownsHandle;

    event HandleRegistered(string _handle, address indexed _address);
    event HandleTransfered(string _handle, address indexed _to);

    function AHS(string _handle) public {
        owner = msg.sender;
        registerHandle(_handle);
    }

    function registerHandle(string _handle) public payable {
        require(handleRegistred[keccak256(_handle)] == false);
        handleToAddresses[keccak256(_handle)] = msg.sender;
        handleRegistred[keccak256(_handle)] = true;
        ownsHandle[msg.sender][keccak256(_handle)] = true;
        HandleRegistered(_handle, msg.sender);
    }

    function registerFor(string _handle, address _addr) public payable {
        require(handleRegistred[keccak256(_handle)] == false);
        handleToAddresses[keccak256(_handle)] = _addr;
        handleRegistred[keccak256(_handle)] = true;
        ownsHandle[msg.sender][keccak256(_handle)] = true;
        HandleRegistered(_handle, msg.sender);
    }

    function transferHandle(string _handle, address _newAddress) public {
        require(handleRegistred[keccak256(_handle)]);
        require(_newAddress != address(0));
        require(ownsHandle[msg.sender][keccak256(_handle)]);
        handleToAddresses[keccak256(_handle)] = _newAddress;
        HandleTransfered(_handle, msg.sender);
    }

    // This function is SUPER risky
    // Only share ownership of your handle to a contract you trust 100%
    function shareOwnership(string _handle, address _contract) public {
        require(_contract != address(0));
        require(ownsHandle[msg.sender][keccak256(_handle)]);
        ownsHandle[_contract][keccak256(_handle)] = true;
    }

    function relinquishOwnership(string _handle) public {
        require(ownsHandle[msg.sender][keccak256(_handle)]);
        ownsHandle[msg.sender][keccak256(_handle)] = false;
    }

    function pay(string _handle) public payable {
        require(handleRegistred[keccak256(_handle)]);
        require(msg.value >= 0);
        address to = handleToAddresses[keccak256(_handle)];
        to.transfer(msg.value);
    }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function findAddress(string _handle) public view returns(address) {
        return handleToAddresses[keccak256(_handle)];
    }

    function isRegistered(string _handle) public view returns(bool) {
        return handleRegistred[keccak256(_handle)];
    }

    function doesOwn(string _handle, address _addr) public view returns(bool) {
        return ownsHandle[_addr][keccak256(_handle)];
    }
}
