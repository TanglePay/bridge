// SPDX-License-Identifier: GPL-3.0

pragma solidity =0.8.17;

contract MultiSign {
    // All the signers
    address[] public signers;
    // the index+1 of  signer in the signers
    mapping(address => uint8) iSigner;
    // The required count of signers
    uint8 public requireCount;

    event SignerAddition(address indexed signer);
    event SignerRemoval(address indexed signer);
    event ChangeRequireCount(uint8 changeRequireCount);

    // signer only modifier.
    modifier onlySigner() {
        require(iSigner[msg.sender] > 0, "not signer");
        _;
    }

    constructor(address[] memory _signers, uint8 _requireCount) {
        for (uint8 i = 0; i < _signers.length; i++) {
            require(
                iSigner[_signers[i]] == 0 && _signers[i] != address(0),
                "invalid or duplicated signer"
            );
            iSigner[_signers[i]] = i + 1;
        }
        signers = _signers;
        require(_requireCount > signers.length / 2, "too small requireCount");
        requireCount = _requireCount;
    }

    uint256 public constant overTime = 86400;
    // the signers changed proposal
    struct SignerProposal {
        int8 d; // 1 means adding signer; -1 means removing signer;
        address signer; // the signer to deal
        uint8 agreedCount;
        uint256 overTime;
    }
    mapping(uint256 => SignerProposal) public signerProposals;
    mapping(uint256 => mapping(address => bool)) public isSignerProposalAgreed; // number of proposal => signer => true

    function submitSignerProposal(
        int8 d,
        address signer
    ) external onlySigner returns (uint256) {
        require(signerProposals[block.number].d == 0, "exist proposal");
        if (d == -1) {
            require(iSigner[signer] > 0, "address not exist");
            require(requireCount < signers.length, "requireCount error");
        } else if (d == 1) {
            require(iSigner[signer] == 0, "address exist");
        }
        signerProposals[block.number] = SignerProposal(
            d,
            signer,
            1,
            block.timestamp + overTime
        );
        isSignerProposalAgreed[block.number][msg.sender] = true;
        return block.number;
    }

    function agreeSignerProposal(
        uint256 number,
        int8 d,
        address signer
    ) external onlySigner {
        require(
            signerProposals[number].d == d &&
                signerProposals[number].signer == signer &&
                signerProposals[number].overTime >= block.timestamp,
            "mismatch"
        );

        if (!isSignerProposalAgreed[number][msg.sender]) {
            isSignerProposalAgreed[number][msg.sender] = true;
            signerProposals[number].agreedCount++;
        }

        if (signerProposals[number].agreedCount >= requireCount) {
            if (d == 1) {
                signers.push(signer);
                iSigner[signer] = uint8(signers.length);
                emit SignerAddition(signer);
            } else if (d == -1) {
                uint8 index = iSigner[signer];
                address lastSigner = signers[signers.length - 1];
                signers[index - 1] = lastSigner;
                iSigner[lastSigner] = index;
                delete iSigner[signer];
                signers.pop();
                emit SignerRemoval(signer);
            }
        }
    }

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
        require(countProposals[block.number].newCount == 0, "exist proposal");
        require(
            (newCount > signers.length / 2) && (newCount <= signers.length),
            "count error"
        );
        countProposals[block.number] = CountProposal(
            newCount,
            1,
            block.timestamp + overTime
        );
        isCountProposalAgreed[block.number][msg.sender] = true;
        return block.number;
    }

    function agreeCountProposal(
        uint256 number,
        uint8 newCount
    ) external onlySigner {
        require(
            countProposals[number].newCount == newCount &&
                countProposals[number].overTime >= block.timestamp,
            "mismatch"
        );

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
