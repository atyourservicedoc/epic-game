// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./libraries/Base64.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


import "hardhat/console.sol";

contract MyEpicGame is ERC721{

    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
        uint lvl;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    CharacterAttributes[] defaultCharacters;

    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;
    mapping(address => uint256) public nftHolders;
    mapping(uint256 => string) public lvlNameMap;

    struct BigBoss {
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    BigBoss public bigBoss;

    event CharacterNFTMinted(address sender, uint256 tokenId, uint256 characterIndex);
    event AttackComplete(uint newBossHp, uint newPlayerHp);

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg,
        uint[] memory characterLvl,
        string memory bossName,
        string memory bossImageURI,
        uint bossHp,
        uint bossAttackDamage
    ) ERC721("Digimon","DMON") {
        
        bigBoss = BigBoss({
            name: bossName,
            imageURI: bossImageURI,
            hp: bossHp,
            maxHp: bossHp,
            attackDamage: bossAttackDamage
        });

        console.log("Done initializing boss %s w/ HP %s, img %s", bigBoss.name, bigBoss.hp, bigBoss.imageURI);


        lvlNameMap[1] = "Baby";
        lvlNameMap[2] = "In-training";
        lvlNameMap[3] = "Rookie";
        lvlNameMap[4] = "Champion";
        lvlNameMap[5] = "Ultimate";
        lvlNameMap[6] = "Mega";
        for(uint i = 0; i < characterNames.length; i+= 1) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                hp: characterHp[i],
                maxHp: characterHp[i],
                attackDamage: characterAttackDmg[i],
                lvl: characterLvl[i]
            }));

            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done initializing %s w/ HP %s, img %s", c.name, c.hp, c.imageURI);
        }
        _tokenIds.increment();
    }

    function mintCharacterNFT(uint _characterIndex) external {
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);

        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].hp,
            attackDamage: defaultCharacters[_characterIndex].attackDamage,
            lvl: defaultCharacters[_characterIndex].lvl
        });
        console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);

        nftHolders[msg.sender] = newItemId;
        _tokenIds.increment();
        emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strMaxHp = Strings.toString(charAttributes.maxHp);
        string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);
        string memory strLvl = lvlNameMap[charAttributes.lvl];

        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                charAttributes.name,
                ' -- NFT #: ',
                Strings.toString(_tokenId),
                '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image":"',
                charAttributes.imageURI,
                '", "attributes": [{ "trait_type": "Health Points", "value": ', strHp, ', "max_value":', strMaxHp, 
                '},                {"trait_type": "Attack Damage", "value":' , strAttackDamage, '},{"trait_type": "Level", "value":"' , strLvl, '"}]}'
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,",json)
        );
        return output;
    }

    function attackBoss() public{
        uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
        CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
        console.log("\nPlayer w/ character %s about to attack. Has %s HP and %s AD", player.name, player.hp, player.attackDamage);
        console.log("Boss %s has %s HP and %s AD", bigBoss.name, bigBoss.hp, bigBoss.attackDamage);
        require (
            player.hp > 0,
            "Error: character must have HP to attack boss."
        );
        require (
            bigBoss.hp > 0,
            "Error: boss must have HP to attack player."
        );

        if (bigBoss.hp < player.attackDamage) {
            bigBoss.hp = 0;
        } else {
            bigBoss.hp = bigBoss.hp - player.attackDamage;
        }

        if (player.hp < bigBoss.attackDamage) {
            player.hp = 0;
        } else {
            player.hp = player.hp - bigBoss.attackDamage;
        }

        console.log("Player attacked boss. New boss hp: %s", bigBoss.hp);
        console.log("Boss attacked player. New player hp: %s\n", player.hp);
        emit AttackComplete(bigBoss.hp, player.hp);
    }

    function checkIfUserhasNFT() public view returns (CharacterAttributes memory) {
        // Get the tokenId of the user's character NFT
        uint256 userNftTokenId = nftHolders[msg.sender];

        if (userNftTokenId > 0) {
            return nftHolderAttributes[userNftTokenId];
        }

        else {
            CharacterAttributes memory emptyStruct;
            return emptyStruct;
        }
    }

    function getAllDefaultCharacters() public view returns (CharacterAttributes[] memory) {
        return defaultCharacters;
    }
 
    function getBigBoss() public view returns (BigBoss memory) {
        return bigBoss;
    }
}