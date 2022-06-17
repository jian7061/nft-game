//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract MyEpicGame is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }
    CharacterAttributes[] defaultCharacters;

    mapping (uint256 => CharacterAttributes) tokenIdToAttributes;

    mapping (address => uint256) ownerToTokenId;

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg
    )
    ERC721("Heroes","HERO")
     {
        for(uint i = 0; i < characterNames.length; i++) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex : i,
                name : characterNames[i],
                imageURI : characterImageURIs[i],
                hp : characterHp[i],
                maxHp : characterHp[i],
                attackDamage : characterAttackDmg[i]
            }));
            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done initializing %s w'HP %s, img %s", c.name, c.hp, c.imageURI);
        }
        _tokenIds.increment();
    }

    function mintCharacterNFT(uint _characterIndex) external {
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);

        tokenIdToAttributes[newItemId] = CharacterAttributes({
                characterIndex : _characterIndex,
                name : defaultCharacters[_characterIndex].name,
                imageURI : defaultCharacters[_characterIndex].imageURI,
                hp : defaultCharacters[_characterIndex].hp,
                maxHp : defaultCharacters[_characterIndex].maxHp,
                attackDamage : defaultCharacters[_characterIndex].attackDamage
            });
        console.log("Minted NFT with tokenId %s, characterIndex %s", newItemId, _characterIndex);

        ownerToTokenId[msg.sender] = newItemId;

        _tokenIds.increment();
    }
}
