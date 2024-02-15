// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Token {
    string tokenName;
    string tokenSymbol;
    uint256 tokenTotalSupply;
    address owner;

    mapping(address => uint256) private balances; //This maps the address of token holders to the amount of token they hold;

    mapping(address => mapping(address => uint256)) amountAllowed; // This maps the amount of tokens a user can mint on bhalf of the token holder

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) {
        tokenName = _name;
        tokenSymbol = _symbol;
        tokenTotalSupply = _totalSupply * (10 ** 18);
        balances[msg.sender] = _totalSupply;
        _mint(msg.sender, _totalSupply);
        // owner = msg.sender;
    }

    event Transfer(
        address indexed owner,
        address indexed receiver,
        uint256 amount
    );
    event Allow(
        address indexed owner,
        address indexed _withdrawer,
        uint256 amount
    );
    event TransferFrom(
        address indexed owner,
        address indexed _withdrawer,
        uint256 amount
    );

    //The code written below is an implementation of the six mandatory functions of an ERC-20 token

    function name() public view returns (string memory) {
        return tokenName;
    }

    function symbol() public view returns (string memory) {
        return tokenSymbol;
    }

    function decimal() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view returns (uint256) {
        return tokenTotalSupply;
    }

    function balanceOf(address _userAccount) public view returns (uint256) {
        return balances[_userAccount];
    }

    function transfer(
        address _receiver,
        uint256 _amount
    ) public returns (bool) {
        require(
            _amount <= balances[msg.sender],
            "You cannot transfer more than the current supply"
        );
        require(_receiver != address(0), "Wrong address");

        uint256 transferFee = (_amount * 10) / 100;

        balances[msg.sender] = balances[msg.sender] - (_amount + transferFee);
        balances[_receiver] = balances[_receiver] + _amount;
        _burn(msg.sender, (transferFee));

        emit Transfer(msg.sender, _receiver, _amount);

        return true;
    }
    
    function approve(
        address _owner,
        address _withdrawer,
        uint256 _amount
    ) public returns (bool) {
        _owner = msg.sender;
        amountAllowed[_owner][_withdrawer] = _amount;
        emit Allow(_owner, _withdrawer, _amount);
        return true;
    }

    function allowance(
        address _owner,
        address _withdrawer
    ) public view returns (uint256) {
        return amountAllowed[_owner][_withdrawer];
    }

    function transferFrom(
        address _owner,
        address _receiver,
        uint256 _amount
    ) public returns (bool) {
        require(
            _amount <= balances[msg.sender],
            "You cannot transfer more than the current supply"
        );
        require(_receiver != address(0), "Wrong address");

        uint256 transferFee = (_amount * 10) / 100;

        balances[_owner] = balances[_owner] - (_amount + transferFee);

        amountAllowed[_owner][msg.sender] =
            amountAllowed[_owner][msg.sender] -
            _amount;

        balances[_receiver] = balances[_receiver] + _amount;

        _burn(_owner, (transferFee));

        emit TransferFrom(msg.sender, _receiver, _amount);

        return true;
    }

    function _burn(address _owner, uint256 _amount) internal {
        tokenTotalSupply = tokenTotalSupply - _amount;

        emit Transfer(_owner, address(0), _amount);
    }

    function _mint(address _owner, uint256 _amount) internal {
        require(owner != address(0), "Wrong address");
        tokenTotalSupply = _amount * (10 ** 18);
        balances[msg.sender] = _amount * (10 ** 18);

        emit Transfer(address(0), _owner, _amount * (10 ** 18));
    }
}
