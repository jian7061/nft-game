//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

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

    struct BigBoss {
        string name;
        string imageUri;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }
    BigBoss public bigBoss;

    mapping (uint256 => CharacterAttributes) tokenIdToAttributes;

    mapping (address => uint256) ownerToTokenId;

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg,
        string memory bossName,
        string memory bossImageURI,
        uint bossHp,
        uint bossAttackDamage
    )
    ERC721("Heroes","HERO")
     {
         //initialize the boss.
         bigBoss = BigBoss ({
         name: bossName,
         imageUri: bossImageURI,
         hp: bossHp,
         maxHp: bossHp,
         attackDamage: bossAttackDamage
    });
    console.log("Done Initializing boss %s w/ HP %s, img %s", bigBoss.name, bigBoss.hp, bigBoss.imageUri);
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

    function getTokenUri(uint256 _tokenId) public view returns(string memory) {
        CharacterAttributes memory charAttributes = tokenIdToAttributes[_tokenId];

        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strMaxHp = Strings.toString(charAttributes.maxHp);
        string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);

        string memory json = Base64.encode(
    abi.encodePacked(
      '{"name": "',
      charAttributes.name,
      ' -- NFT #: ',
      Strings.toString(_tokenId),
      '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image": "',
      charAttributes.imageURI,
      '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":',strMaxHp,'}, { "trait_type": "Attack Damage", "value": ',
      strAttackDamage,'} ]}'
    )
  );

        string memory output = string(
    abi.encodePacked("data:application/json;base64,", json)
  );
  
        return output;

    }
    function attackBoss() public {
        uint256 tokenIdOfPlayer = ownerToTokenId[msg.sender];
        // If we were to use memory instead of storage it would create a local copy of the variable 
        // within the scope of the function. That means if we did player.hp = 0 
        // it would only be that way within the function and wouldn't change the global value.
        CharacterAttributes storage player = tokenIdToAttributes[tokenIdOfPlayer];
        console.log("Player name: %s, hp: %s, attackDamage: %s", player.name, player.hp, player.attackDamage);
        console.log("Boss name: %s, hp: %s, attackDamage: %s", bigBoss.name, bigBoss.hp, bigBoss.attackDamage);

        require(player.hp > 0,"Error: character must have HP to attack boss");
        require(bigBoss.hp > 0,"Error: boss must have HP");

        // player attack boss
        if(bigBoss.hp < player.attackDamage) {
            bigBoss.hp = 0;
        } else {
            bigBoss.hp = bigBoss.hp - player.attackDamage;
        }
        
        // boss attack player
        if(player.hp < bigBoss.attackDamage) {
            player.hp = 0;
        } else {
            player.hp = player.hp - bigBoss.attackDamage;
        }

        console.log("Player attack boss. New boss hp: %s", bigBoss.hp);
        console.log("Boss attack player. New player hp: %s", player.hp);
    }

}
