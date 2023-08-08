// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

contract GasContract {

    event AddedToWhitelist(address userAddress, uint256 tier);

    event WhiteListTransfer(address indexed recipient);

    mapping(address => uint256) internal whitetransfers;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) public administrators;
    mapping(address => uint256) public whitelist;
    

    constructor(address[] memory _admins, uint256 _totalSupply) {
        administrators[0] = _admins[0];
        administrators[1] = _admins[1];
        administrators[2] = _admins[2];
        administrators[3] = _admins[3];
        administrators[4] = _admins[4];
        _balances[msg.sender] = _totalSupply;
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
        adjustBalances(_amount, msg.sender, _recipient);
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) public
    {   
        if (_tier > 254  || !isAdministrator(msg.sender)) {
            revert("");
        }
        whitelist[_userAddrs] = _tier > 3 ? 3 : _tier;
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(address _recipient, uint256 _amount) public 
    {    
        whitetransfers[msg.sender] = _amount;
        adjustBalances(_amount - whitelist[msg.sender], msg.sender, _recipient);
        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(address _sender) public view returns (bool, uint256) 
    {        
        return(true, whitetransfers[_sender]);
    }

    function adjustBalances(uint _amount, address _sender, address _recipient) private {
        if (_balances[_sender] <  _amount) {
            revert("Sender does Not have enough balance");
        }
        _balances[_sender] -= _amount;
        _balances[_recipient] += _amount;
    }

    function isAdministrator(address _user) public view returns (bool) 
    {
        for (uint256 i = 0; i < 5;) {
            if (administrators[i] == _user) {
                return true;
            }
            unchecked {i++;}
        }
        return false;
    }

}