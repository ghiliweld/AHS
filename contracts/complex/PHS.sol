pragma solidity ^0.4.19;

// Personal Handle Service PHS
// A service on top of the AHS for registering your own handle on top of the .eth base for free
// donations are optional

contract PHS is AHS {


    mapping (bytes32 => bool) public ethHandleRegistred;
    mapping (address => mapping (bytes32 => bool)) public ownsEthHandle;


    event HandleTransfered(bytes32 _handle, address indexed _to);

    function registerEthHandle(bytes32 _handle, address _addr) public payable {
        require(_addr != address(0));
        if (ethHandleRegistred[_handle] && ownsEthHandle[msg.sender][_handle]) {
            handleIndex[ethBase][_handle] = _addr;
        }
        ethHandleRegistred[_handle] = true;
        ownsEthHandle[msg.sender][_handle] = true;
        handleIndex[ethBase][_handle] = _addr;
        NewHandle(ethBase, _handle, msg.sender);
    }

    function transferEthHandleOwnership(bytes32 _handle, address _addr) public {
        require(ownsEthHandle[msg.sender][_handle]);
        ownsEthHandle[msg.sender][_handle] = false;
        ownsEthHandle[_addr][_handle] = true;
        HandleTransfered(_handle, _addr);
    }

}
