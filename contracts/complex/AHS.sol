pragma solidity ^0.4.19;

/*
@title Address Handle Service aka AHS
@author Ghilia Weldesselasie, founder of D-OZ and genius extraordinaire
@twitter: @ghiliweld, my DMs are open so slide through if you trynna chat ;)

This is a simple alternative to ENS I made cause ENS was too complicated
for me to understand which seemed odd since it should be simple in my opinion.
*/

contract AHS is Ownable {

    bytes32 public ethBase; // .eth extension
    ERC20 public dai = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359; // address of DAI token
    uint256 public price = 190000000000000000; // price in Wei 0.19 ETH roughly 100 USD
    uint256 public daiPrice = 100; // price in DAI 100 DAI so 100 USD

    mapping (bytes32 => mapping (bytes32 => address)) public handleIndex;
    mapping (bytes32 => bool) public ethHandleRegistred;
    mapping (bytes32 => bool) public baseRegistred;
    mapping (address => mapping (bytes32 => bool)) public ownsBase;

    event NewBase(bytes32 _base, address indexed _address);
    event NewHandle(bytes32 _base, bytes32 _handle, address indexed _address);
    event BaseTransfered(bytes32 _base, address indexed _to);

    function AHS(bytes32 _ethBase, bytes32 _weldBase) public {
        ethBase = _ethBase;
        baseRegistred[_ethBase] = true;
        baseRegistred[_weldBase] = true;
        ownsBase[msg.sender][_ethBase] = true;
        ownsBase[msg.sender][_weldBase] = true;
    }

    function registerBase(bytes32 _base) public payable {
        require(msg.value >= price || dai.balanceOf(msg.sender) >= daiPrice);
        require(_base.length > 0);
        require(!baseRegistred[_base]);
        baseRegistred[_base] = true;
        ownsBase[msg.sender][_base] = true;
        if (msg.value <= price && dai.balanceOf(msg.sender) >= daiPrice) {
            dai.transfer(owner, daiPrice);
        }
        NewBase(_base, msg.sender);
    }

    function registerHandle(bytes32 _base, bytes32 _handle, address _addr) public {
        require(baseRegistred[_base]);
        require(_addr != address(0));
        require(ownsBase[msg.sender][_base]);
        handleIndex[_base][_handle] = _addr;
        NewHandle(_base, _handle, msg.sender);
    }

    function registerEthHandle(bytes32 _handle, address _addr) public {
        require(_addr != address(0));
        require(!ethHandleRegistred[_handle]);
        ethHandleRegistred[_handle] = true;
        handleIndex[ethBase][_handle] = _addr;
        NewHandle(ethBase, _handle, msg.sender);
    }

    function transferBase(bytes32 _base, address _newAddress) public {
        require(baseRegistred[_base]);
        require(_newAddress != address(0));
        require(ownsBase[msg.sender][_base]);
        ownsBase[msg.sender][_base] = false;
        ownsBase[_newAddress][_base] = true;
        BaseTransfered(_base, msg.sender);
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

    function findAddress(bytes32 _base, bytes32 _handle) public view returns(address) {
        return handleIndex[_base][_handle];
    }

    function isRegistered(bytes32 _base) public view returns(bool) {
        return baseRegistred[_base];
    }

    function ethHandleIsRegistered(bytes32 _handle) public view returns(bool) {
        return ethHandleRegistred[_handle];
    }

    function doesOwn(bytes32 _base, address _addr) public view returns(bool) {
        return ownsBase[_addr][_base];
    }
}
