pragma solidity ^0.4.19;


interface AHSInterface {
    function registerHandle(string _handle) public payable;
    function registerFor(string _handle, address _addr) public payable;
    function transferHandle(string _handle, address _newAddress) public;
    // This function is SUPER risky
    // Only share ownership of your handle to a contract you trust 100%
    function shareOwnership(string _handle, address _contract) public;
    function relinquishOwnership(string _handle) public;
    function pay(string _handle) public payable;
    function withdraw() public;
    function findAddress(string _handle) public view returns(address);
    function isRegistered(string _handle) public view returns(bool);
    function doesOwn(string _handle, address _addr) public view returns(bool);
}
