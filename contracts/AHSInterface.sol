pragma solidity ^0.4.19;


interface AHSInterface {
    function registerBase(bytes32 _base) public payable;
    function getBaseQuick(bytes32 _base) public;
    function registerHandle(bytes32 _base, bytes32 _handle, address _addr) public payable;
    function transferBase(bytes32 _base, address _newAddress) public;
    function findAddress(bytes32 _base, bytes32 _handle) public view returns(address);
    function isRegistered(bytes32 _base) public view returns(bool);
    function doesOwn(bytes32 _base, address _addr) public view returns(bool);
    function changePrice(uint256 _price) public;
}
