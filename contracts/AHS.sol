pragma solidity ^0.4.19;

/*
@title Address Handle Service aka AHS
@author Ghilia Weldesselasie, founder of D-OZ and genius extraordinaire
@twitter: @ghiliweld, my DMs are open so slide through if you trynna chat ;)

This is a simple alternative to ENS I made.
*/

contract AHS is HandleLogic {

    function AHS(uint256 _price, bytes32 _ethBase, bytes32 _weldBase) public {
        price = _price;
        getBaseQuick(_ethBase);
        getBaseQuick(_weldBase);
    }

    function () public payable {} // donations are optional

    function getBaseQuick(bytes32 _base) public {
        require(msg.sender == owner); // Only I can call this function
        require(!baseRegistred[_base]); // the base can't be registered yet, stops me from snatching someone else's base
        baseRegistred[_base] = true; // I register the base
        ownsBase[owner][_base] = true; // the ownership gets passed on to me
        NewBase(_base, msg.sender);
    }

    function withdraw() public {
        require(msg.sender == owner); // Only I can call this function
        owner.transfer(this.balance);
    }

    function changePrice(uint256 _price) public {
        require(msg.sender == owner); // Only I can call this function
        price = _price;
    }

}
