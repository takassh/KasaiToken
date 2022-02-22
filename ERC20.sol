// SPDX-License-Identifier: ISC
pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract KasaiToken is IERC20, IERC20Metadata {
    string private _name;
    string private _symbol;
    string private _decimal;
    uint256 private _totalSupply;
    
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    constructor(string memory name_,string memory symbol_,uint256 totalSupply_){
            _name = name_;
            _symbol = symbol_;
            _totalSupply = totalSupply_;
            
            _balances[msg.sender] = _totalSupply;
        }
    
    /**
     * @dev Returns the name of the token.
     */
    function name() external view override returns (string memory){
        return _name;
    }

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view override returns (string memory){
        return _symbol;
    }

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external pure override returns (uint8){
        return 18;
    }
    
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view override returns (uint256){
        return _totalSupply;
    }
    
    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view override returns (uint256){
        return _balances[account];
    }

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external override returns (bool){
        require(_balances[msg.sender] >= amount, "not enough balance");
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        
        // fire event
        emit Transfer(msg.sender, to, amount);
        
        return true;
    }

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view override returns (uint256){
        return _allowances[owner][spender];
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external override returns (bool){
        require(spender != msg.sender, "cannot self approve");
        _allowances[msg.sender][spender] = amount;
        
        emit Approval(msg.sender, spender, amount);
        
        return true;
    }

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external override returns (bool){
        require(_balances[from] >= amount, "not enough balance");
        uint256 _allowance = _allowances[from][msg.sender];
        require(_allowance >= amount, "not enough allowance");
        
        _allowances[from][msg.sender] -= amount;
        _balances[from] -= amount;
        _balances[to] += amount;
        
        emit Transfer(from, to, amount);
        return true;
    }
}

