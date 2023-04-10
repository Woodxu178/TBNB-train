// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProxyContract {
    address public logicContractAddress;

    constructor(address _logicContractAddress) {
        logicContractAddress = _logicContractAddress;
    }

    function setLogicContractAddress(address _logicContractAddress) public {
        logicContractAddress = _logicContractAddress;
    }

    fallback() external payable {
        address _impl = logicContractAddress;
        require(_impl != address(0));

        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }

    receive() external payable {
        // This function enables the contract to receive ether.
    }
}
