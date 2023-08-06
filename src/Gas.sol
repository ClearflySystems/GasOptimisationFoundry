// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

contract GasContract {

    event AddedToWhitelist(address userAddress, uint256 tier);

    event WhiteListTransfer(address indexed recipient);

    uint256 totalSupply; // cannot be updated

    struct ImportantStruct {
        uint256 amount;
        bool paymentStatus;
    }
    
    mapping(address => uint256) public balances;
    mapping(address => uint256) public whitelist;
    mapping(address => bool) internal isAdmin;
    mapping(address => ImportantStruct) internal whiteListStruct;

    address[5] public administrators;

    constructor(address[] memory _admins, uint256 _totalSupply) {
        totalSupply = _totalSupply;

        for (uint256 ii = 0; ii < 5;) {
            administrators[ii] = _admins[ii];
            isAdmin[_admins[ii]] = true;
            if (_admins[ii] == msg.sender) {
                balances[msg.sender] = _totalSupply;
            }
            unchecked { ++ii; }
        }
    }

    function balanceOf(address _user) public view returns (uint256 balance_) {
        balance_ = balances[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public {
        if(balances[msg.sender] < _amount) revert ("");
        if(bytes(_name).length > 8) revert ("");
        
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
    }

    function addToWhitelist(address _userAddrs, uint256 _tier)
        public
    {   
        if (!isAdmin[msg.sender]) {
            revert("");
        }

        if (_tier > 254) {
            revert("");
        } else if (_tier <= 3) {
            whitelist[_userAddrs] = _tier;
        } else {
            whitelist[_userAddrs] = 3;
        } 

        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount
    ) public {    
        uint256 usersTier = whitelist[msg.sender];
        if (usersTier == 0 || usersTier > 3) {
            revert ("");
        }
        whiteListStruct[msg.sender] = ImportantStruct(_amount, true);
        
        if (balances[msg.sender] < _amount) revert ("");
        if (_amount < 4) revert ("");

        uint balanceChange = _amount - usersTier;
        balances[msg.sender] -= balanceChange;
        balances[_recipient] += balanceChange;
        
        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(address sender) public view returns (bool _paymentStatus, uint256 _amount) {        
        _paymentStatus = whiteListStruct[sender].paymentStatus;
        _amount = whiteListStruct[sender].amount;
    }

}