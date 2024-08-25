// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

// From Buttonwood
interface BondController {
    // -- State Variables --
    function collateralToken() external view returns (address);

    function creationDate() external view returns (uint);
    function maturityDate() external view returns (uint);
    function isMature() external view returns (bool);

    function totalDebt() external view returns (uint);
    function lastScaledCollateralBalance() external view returns (uint);

    function depositLimit() external view returns (uint);
    function feeBps() external view returns (uint);

    // -- Tranche Data
    struct TrancheData {
        address token;
        uint ratio;
    }

    function tranches(uint index)
        external
        view
        returns (address token, uint ratio);
    function trancheCount() external view returns (uint);
    function trancheTokenAddresses(address tranche_)
        external
        view
        returns (bool);

    // -- Public View Functions --
    function getTrancheName(
        string memory collateralSymbol,
        uint index,
        uint trancheCount_
    ) external view returns (string memory);

    function getTrancheSymbol(
        string memory collateralSymbol,
        uint index,
        uint trancheCount_
    ) external view returns (string memory);

    function collateralBalance() external view returns (uint);
}
