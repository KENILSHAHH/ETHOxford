// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721}from  "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "https://github.com/ava-labs/teleporter/blob/main/contracts/src/Teleporter/ITeleporterMessenger.sol";
import "https://github.com/ava-labs/teleporter/blob/main/contracts/src/Teleporter/ITeleporterReceiver.sol";

error Monkey__TokenUriNotFound();

contract Monkey is ERC721, Ownable,ITeleporterReceiver {
 ITeleporterMessenger public immutable teleporterMessenger = ITeleporterMessenger(0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf);

    string public lastMessage;

    function receiveTeleporterMessage(
        bytes32 originChainID,
        address originSenderAddress,
        bytes calldata message
    ) external {
        // Store the message.
        lastMessage = abi.decode(message, (string));
    }
   struct Message {
        address sender;
        string message;
    }
  
  	mapping(bytes32 => Message) private _messages;

    ITeleporterMessenger public immutable teleporterMessenger;

    // Errors
    error Unauthorized();

    constructor(address teleporterMessengerAddress) {
        teleporterMessenger = ITeleporterMessenger(teleporterMessengerAddress);
    }

    /**
     * @dev See {ITeleporterReceiver-receiveTeleporterMessage}.
     *
     * Receives a message from another chain.
     */
    function receiveTeleporterMessage(
        bytes32 originChainID,
        address originSenderAddress,
        bytes calldata message
    ) external {
      	// Only the Teleporter receiver can deliver a message.
        if (msg.sender != address(teleporterMessenger)) {
            revert Unauthorized();
        }
      
        string memory messageString = abi.decode(message, (string));
        _messages[originChainID] = Message(originSenderAddress, messageString);
    }
	// State variables
	string public baseUri =
		"ipfs://QmSAAC4YBnXnv4JiZzR6DXQpEveTgciq93hhmzr9hs5LCV/";
	string public uriSuffix = ".json";
	uint256 public s_tokenCounter;
	uint256 public s_maxSupply = 420;

	// Functions
	/**
	 * Starting from one to match hashlips art engine configuration
	 */
	constructor() ERC721("Monkey", "MNK") Ownable() {
		s_tokenCounter = 1;
	}

	/**
	 * Increment token counter after minting
	 */
	function mintNft(address recipient) public onlyOwner {
		_safeMint(recipient, s_tokenCounter);
		s_tokenCounter = s_tokenCounter + 1;
	}

	/**
	 * Concat baseUri, tokenId and uriSuffix to form the tokenURI
	 */
	function tokenURI(
		uint256 _tokenId
	) public view virtual override returns (string memory) {
		

		return
			string(
				abi.encodePacked(baseUri, Strings.toString(_tokenId), uriSuffix)
			);
	}

	/**
	 * Incase we need to change the baseUri after re-generating nft images & metadata
	 */
	function setBaseUri(string memory _baseUri) public onlyOwner {
		baseUri = _baseUri;
	}
function sendMessage(
        address destinationAddress,
        string calldata message
    ) external {
        teleporterMessenger.sendCrossChainMessage(
            TeleporterMessageInput({
                destinationBlockchainID: 0x9f3be606497285d0ffbb5ac9ba24aa60346a9b1812479ed66cb329f394a4b1c7,
                destinationAddress: destinationAddress,
                feeInfo: TeleporterFeeInfo({
                    feeTokenAddress: address(0),
                    amount: 0
                }),
                requiredGasLimit: 100000,
                allowedRelayerAddresses: new address[](0),
                message: abi.encode(message)
            })
        );

	function setMaxSupply(uint256 _maxSupply) public onlyOwner {
		s_maxSupply = _maxSupply;
	}
}
