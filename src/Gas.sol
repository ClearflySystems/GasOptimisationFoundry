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
    
    mapping(address => uint256) private _balances;
    mapping(address => uint256) public whitelist;
    mapping(uint256 => address) public administrators;
    mapping(address => ImportantStruct) internal whiteListStruct;
    

    constructor(address[] memory _admins, uint256 _totalSupply) {
        administrators[0] = _admins[0];
        administrators[1] = _admins[1];
        administrators[2] = _admins[2];
        administrators[3] = _admins[3];
        administrators[4] = _admins[4];
        _balances[msg.sender] = totalSupply = _totalSupply;
    }

    function balances(address _user) public view returns (uint256)
    {
        return _balances[_user];
    }

    function balanceOf(address _user) public view returns (uint256) 
    {
        return _balances[_user];
    }

    function transfer(address _recipient, uint256 _amount, string calldata _name) public 
    {
        if(_balances[msg.sender] < _amount || bytes(_name).length > 8) {
            revert ("");
        }
        adjustBalances(_amount, msg.sender, _recipient);
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) public
    {   
        if (!isAdministrator(msg.sender) || _tier > 254) {
            revert("");
        }
        whitelist[_userAddrs] = _tier > 3 ? 3 : _tier;
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(address _recipient, uint256 _amount) public 
    {    
        if (_balances[msg.sender] < _amount || _amount < 4) {
            revert ("");
        }
        whiteListStruct[msg.sender] = ImportantStruct(_amount, true);
        adjustBalances(_amount - whitelist[msg.sender], msg.sender, _recipient);
        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(address _sender) public view returns (bool, uint256) 
    {        
        return(whiteListStruct[_sender].paymentStatus, whiteListStruct[_sender].amount);
    }

    function adjustBalances(uint _amount, address _sender, address _recipient) private {
        _balances[_sender] -= _amount;
        _balances[_recipient] += _amount;
    }

    function isAdministrator(address _user) public view returns (bool) 
    {
        for (uint8 i = 0; i < 5; i++) {
            if (administrators[i] == _user) {
                return true;
            }
        }
        return false;
    }

}