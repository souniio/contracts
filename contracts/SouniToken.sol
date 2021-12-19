// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;


import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SouniToken is Ownable, ERC20PresetFixedSupply {

    event SetWhiteList(address[] addresses, bool flag);
    event SetLimitTime(uint256 indexed limitTime);
    event SetOpenTime(uint256 indexed openTime);
    event SetLimitAmount(uint256 indexed limitAmount);

    uint256 public limitTime = 1642251600;
    uint256 public openTime = 1642253400;
    uint256 public limitAmount = 1000000 * 10 ** 18;

    mapping(address => bool) private _whitelists;

    constructor(address multiSigAddress) ERC20PresetFixedSupply('Souni Token', 'SON', 10000000000 * 10 ** 18, multiSigAddress){
        transferOwnership(multiSigAddress);
    }

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

    function setWhiteList(address[] calldata addresses_, bool flag) external onlyOwner {
        for (uint16 i = 0; i < addresses_.length; i ++) {
            _whitelists[addresses_[i]] = flag;
        }
        emit SetWhiteList(addresses_, flag);
    }

    function setLimitTime(uint256 limitTime_) external onlyOwner {
        require(limitTime_ < openTime && limitTime_ < 1646092800, "invalid time");
        limitTime = limitTime_;
        emit SetLimitTime(limitTime_);
    }

    function setOpenTime(uint256 openTime_) external onlyOwner {
        require(openTime_ > limitTime && openTime_ < 1646092800, "invalid time");
        openTime = openTime_;
        emit SetOpenTime(openTime_);
    }

    function setLimitAmount(uint256 limitAmount_) external onlyOwner {
        limitAmount = limitAmount_;
        emit SetLimitAmount(limitAmount_);
    }
}
