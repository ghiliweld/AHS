pragma solidity ^0.4.19;


interface AHSInterface {
    function registerBase(bytes32 _base) public payable;
    function registerHandle(bytes32 _base, bytes32 _handle, address _addr) public payable;
    function transferBase(bytes32 _base, address _newAddress) public;
    function getPrice() public view returns(uint256);
    function findAddress(bytes32 _base, bytes32 _handle) public view returns(address);
    function isRegistered(bytes32 _base) public view returns(bool);
    function getBaseOwner(bytes32 _base, address _addr) public view returns(address);
}
