pragma solidity ^0.4.19;

// Handle Center

contract HandleCenter is AHS, PHS {

    function HandleCenter(bytes32 _ethBase, bytes32 _weldBase) public {
        ethBase = _ethBase;
        baseRegistred[_ethBase] = true;
        baseRegistred[_weldBase] = true;
        ownsBase[msg.sender][_ethBase] = true;
        ownsBase[msg.sender][_weldBase] = true;
    }

    function () public payable {} // donations are optional

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function changePrice(uint256 _price, uint256 _daiPrice) public {
        require(msg.sender == owner);
        price = _price;
        daiPrice = _daiPrice;
    }

    function findAddress(bytes32 _base, bytes32 _handle) public view returns(address) {
        return handleIndex[_base][_handle];
    }

    function isRegistered(bytes32 _base) public view returns(bool) {
        return baseRegistred[_base];
    }

    // PHS function
    function ethHandleIsRegistered(bytes32 _handle) public view returns(bool) {
        return ethHandleRegistred[_handle];
    }

    function doesOwnBase(bytes32 _base, address _addr) public view returns(bool) {
        return ownsBase[_addr][_base];
    }

    // PHS function
    function doesOwnEthHandle(bytes32 _handle, address _addr) public view returns(bool) {
        return ownsEthHandle[_addr][_handle];
    }

}
