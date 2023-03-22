// SPDX-License-Identifier: GPL-3.0

pragma solidity =0.8.19;

contract MultiSign {
    // All the signers
    address[] public signers;
    // the index+1 of  signer in the signers
    mapping(address => uint256) iSigner;
    // The required count of signers
    uint256 public requireCount;

    event SignerAddition(address indexed signer);
    event SignerRemoval(address indexed signer);
    event ChangeRequireCount(uint8 changeRequireCount);

    // signer only modifier.
    modifier onlySigner() {
        if (iSigner[msg.sender] == 0) revert("not signer");
        // require(iSigner[msg.sender] > 0, "not signer");
        _;
    }

    constructor(address[] memory _signers, uint256 _requireCount) {
        uint256 length = _signers.length;
        // unchecked is safe here
        // .length() return uint256, uint256 <> uint8 calc/conv require extra gas
        // uint256 = false = 0
        unchecked {
            for (uint256 i; i < length; i++) {
                if (iSigner[_signers[i]] != 0 && 
                    _signers[i] == address(0)) 
                        revert("invalid or duplicated signer");

            iSigner[_signers[i]] = i + 1;
        }
        signers = _signers;
        if (length / 2 >= _requireCount) revert("too small requireCount");
        // require(_requireCount > signers.length / 2, "too small requireCount");
        requireCount = _requireCount;
        }
    }

    uint256 public constant overTime = 86400;
    // the signers changed proposal

    // 3 slots
    struct SignerProposal {
        uint256 agreedCount;
        uint256 overTime;
        int8 d; // 1 means adding signer; -1 means removing signer;
        address signer; // the signer to deal
    }
    mapping(uint256 => SignerProposal) public signerProposals;
    mapping(uint256 => mapping(address => bool)) public isSignerProposalAgreed; // number of proposal => signer => true

    function submitSignerProposal(
        int8 d,
        address signer
    ) external onlySigner returns (uint256) {
        if (signerProposals[block.number].d != 0) revert("exist proposal");
        // require(signerProposals[block.number].d == 0, "exist proposal");
        if (d == -1) {
            if (iSigner[signer] == 0) revert("address not exist");
            // require(iSigner[signer] > 0, "address not exist");
        } else if (d == 1) {
            if (iSigner[signer] != 0) revert("address exist");
            // require(iSigner[signer] == 0, "address exist");
        }
        signerProposals[block.number] = SignerProposal(
            1,
            block.timestamp + overTime,
            d,
            signer
        );
        isSignerProposalAgreed[block.number][msg.sender] = true;
        return block.number;
    }

    function agreeSignerProposal(
        uint256 number,
        int8 d,
        address signer
    ) external onlySigner {
        if (signerProposals[number].d != d && 
                signerProposals[number].signer != signer &&
                block.timestamp > signerProposals[number].overTime)
                    revert("mismatch");
        /*            
        require(
            signerProposals[number].d == d &&
                signerProposals[number].signer == signer &&
                signerProposals[number].overTime >= block.timestamp,
            "mismatch"
        );
        */

        if (!isSignerProposalAgreed[number][msg.sender]) {
            isSignerProposalAgreed[number][msg.sender] = true;
            signerProposals[number].agreedCount++;
        }

        if (signerProposals[number].agreedCount >= requireCount) {
            uint256 length = signers.length;
            if (d == 1) {
                signers.push(signer);
                iSigner[signer] = length;
                emit SignerAddition(signer);
            } else if (d == -1) {
                uint256 index = iSigner[signer];
                address lastSigner = signers[length - 1];
                signers[index - 1] = lastSigner;
                iSigner[lastSigner] = index;
                delete iSigner[signer];
                signers.pop();
                emit SignerRemoval(signer);
            }
        }
    }

    // 2 slots
    struct CountProposal {
        uint8 newCount;
        uint8 agreedCount;
        uint256 overTime;
    }
    mapping(uint256 => CountProposal) public countProposals;
    mapping(uint256 => mapping(address => bool)) public isCountProposalAgreed; // number of proposal => signer => true

    function submitCountProposal(
        uint8 newCount
    ) external onlySigner returns (uint256) {
        if (countProposals[block.number].newCount != 0) revert("exist proposal");
        if (signers.length / 2 >= newCount) revert("count too small");
        // require(countProposals[block.number].newCount == 0, "exist proposal");
        // require(newCount > signers.length / 2, "count too small");
        countProposals[block.number] = CountProposal(
            1,
            newCount,
            block.timestamp + overTime
        );
        isCountProposalAgreed[block.number][msg.sender] = true;
        return block.number;
    }

    function agreeCountProposal(
        uint256 number,
        uint8 newCount
    ) external onlySigner {
        if (countProposals[number].newCount != newCount &&
                block.timestamp > countProposals[number].overTime) 
                    revert("mismatch");
        /*        
        require(
            countProposals[number].newCount == newCount &&
                countProposals[number].overTime >= block.timestamp,
            "mismatch"
        );
        */

        if (!isCountProposalAgreed[number][msg.sender]) {
            isCountProposalAgreed[number][msg.sender] = true;
            countProposals[number].agreedCount++;
        }

        if (countProposals[number].agreedCount >= requireCount) {
            requireCount = newCount;
            emit ChangeRequireCount(newCount);
        }
    }
}
