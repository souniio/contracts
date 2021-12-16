// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SonTicket is Ownable, ERC20PresetFixedSupply {

    uint256 public limitTime = 1642251600;
    uint256 public openTime = 1642253400;
    uint256 public limitAmount = 10000 * 10 ** 18;

    mapping(address => bool) private _whitelists;

    constructor() ERC20PresetFixedSupply('Souni Token', 'SON', 10000000000 * 10 ** 18, msg.sender){}

    function _beforeTokenTransfer(address from_, address to_, uint256 amount_) internal override {
        if (block.timestamp < limitTime) {
            require(_whitelists[to_], "!whitelist");
        } else if (block.timestamp < openTime) {
            if (!_whitelists[to_]) {
                require(_whitelists[from_], "can not transfer before open-time");
                require(balanceOf(to_) + amount_ <= limitAmount, "receiver exceeded the maximum hold");
            }
        }
        super._beforeTokenTransfer(from_, to_, amount_);
    }

    function addWhiteList(address address_) external onlyOwner {
        _whitelists[address_] = true;
    }

    function setLimitTime(uint256 limitTime_) external onlyOwner {
        require(limitTime_ < openTime && limitTime_ < 1646092800, "invalid time");
        limitTime = limitTime_;
    }

    function setOpenTime(uint256 openTime_) external onlyOwner {
        require(openTime_ > limitTime && openTime_ < 1646092800, "invalid time");
        openTime = openTime_;
    }

    function setLimitAmount(uint256 limitAmount_) external onlyOwner {
        limitAmount = limitAmount_;
    }
}
