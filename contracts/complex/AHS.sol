pragma solidity ^0.4.19;

// Handle Center

contract AHS is HandleLogic {

    function AHS(bytes32 _ethBase, bytes32 _weldBase, bytes32 _comBase) public {
        ethBase = _ethBase;
        baseRegistred[_ethBase] = true;
        baseRegistred[_weldBase] = true;
        baseRegistred[_comBase] = true;
        ownsBase[msg.sender][_ethBase] = true;
        ownsBase[msg.sender][_weldBase] = true;
        ownsBase[msg.sender][_comBase] = true;
    }

    function () public payable {} // donations are optional

    function getBaseQuick(bytes32 _base) public {
        require(msg.sender == owner);
        require(!baseRegistred[_base]);
        baseRegistred[_base] = true;
        ownsBase[owner][_base] = true;
        NewBase(_base, msg.sender);
    }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function changePrice(uint256 _price, uint256 _daiPrice) public {
        require(msg.sender == owner);
        price = _price;
        daiPrice = _daiPrice;
    }

}
