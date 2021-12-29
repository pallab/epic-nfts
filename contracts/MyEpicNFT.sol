// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract MyEpicNFT is ERC721URIStorage {
    // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' style='enable-background:new 0 0 64 64' xml:space='preserve'><style>.st0{fill:#4f5d73}.st1{opacity:.2}.st2{fill:#231f20}.st3{fill:#c75c5c}</style><g id='Layer_1'><circle class='st0' cx='32' cy='32' r='32'/><g class='st1'><path class='st2' d='M32.1 39.7C30.5 41.2 26 52.2 26 52.2c-.7 1.2.3 2.1 2.6.9l8.1-4.4c4.4-2.4 5.2-3.1 5.2-8l-.8-5.9c-.3-2-1.8-2.4-3.3-.8l-5.7 5.7z'/></g><g class='st1'><path class='st2' d='M27.1 34.7c-1.6 1.6-12.5 6.1-12.5 6.1-1.2.7-2.1-.3-.9-2.6L18 30c2.4-4.4 3.1-5.2 8-5.2l5.9.8c2 .3 2.4 1.8.8 3.3l-5.6 5.8z'/></g><path class='st3' d='M32.1 37.7C30.5 39.2 26 50.2 26 50.2c-.7 1.2.3 2.1 2.6.9l8.1-4.4c4.4-2.4 5.2-3.1 5.2-8l-.8-5.9c-.3-2-1.8-2.4-3.3-.8l-5.7 5.7zm-5-5c-1.6 1.6-12.5 6.1-12.5 6.1-1.2.7-2.1-.3-.9-2.6L18 28c2.4-4.4 3.1-5.2 8-5.2l5.9.8c2 .3 2.4 1.8.8 3.3l-5.6 5.8z'/><g class='st1'><path class='st2' d='M21.2 39.5c5.1-5.1 9.3-3.5 9.3-3.5s1.5 4.3-3.5 9.3-13.3 8.8-13.9 8.1c-.6-.5 3.1-8.8 8.1-13.9z'/></g><path d='M21.2 37.5c5.1-5.1 9.3-3.5 9.3-3.5s1.5 4.3-3.5 9.3-13.3 8.8-13.9 8.1c-.6-.5 3.1-8.8 8.1-13.9z' style='fill:#e0995e'/><path d='M25.5 33.3c5.1-5.1 9.3-3.5 9.3-3.5s1.5 4.3-3.5 9.3-13.3 8.8-13.9 8.1c-.7-.6 3-8.8 8.1-13.9z' style='fill:#f5cf87'/><g class='st1'><path class='st2' d='M43.6 37.1c-7.8 7.8-19.8 5.7-19.8 5.7s-2.1-12 5.7-19.8 19.6-8.6 21.2-7.1c1.5 1.5.7 13.4-7.1 21.2z'/></g><path d='M43.6 35.1c-7.8 7.8-19.8 5.7-19.8 5.7s-2.1-12 5.7-19.8 19.6-8.6 21.2-7.1c1.5 1.5.7 13.4-7.1 21.2z' style='fill:#e0e0d1'/><g class='st1'><path class='st2' d='M21 47c-.8.8-1.3 1.5-2.1.7s-.1-1.3.7-2.1l9.9-12.7c.8-.8 4.2-1.5 4.9-.7.8.8.1 4.2-.7 4.9L21 47z'/></g><path class='st3' d='M21 45c-.8.8-1.3 1.5-2.1.7s-.1-1.3.7-2.1l9.9-12.7c.8-.8 4.2-1.5 4.9-.7.8.8.1 4.2-.7 4.9L21 45z'/><g class='st1'><circle class='st2' cx='39.6' cy='27.1' r='4'/></g><g class='st1'><circle class='st2' cx='45.3' cy='21.5' r='2'/></g><circle class='st0' cx='39.6' cy='25.1' r='4'/><circle class='st0' cx='45.3' cy='19.5' r='2'/></g><g id='Layer_2'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle' textLength='70' lengthAdjust='spacingAndGlyphs'>";
    string[] firstWords = ["Cool", "Loud", "Huge", "Boring", "Fing", "Big"];
    string[] secondWords = [
        "Rokcet",
        "Bus",
        "Train",
        "Ship",
        "Scooter",
        "Tanker"
    ];
    string[] thirdWords = [
        "Fly",
        "Crawl",
        "Boom",
        "Bust",
        "Dash"
    ];

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomWord(uint256 tokenId, uint256 wordPosition, string[] memory words) public pure returns (string memory){
        uint256 rand = random(
            string(abi.encodePacked(Strings.toString(wordPosition), Strings.toString(tokenId)))
        );
        rand = rand % words.length;
        return words[rand];
    }

    // We need to pass the name of our NFTs token and its symbol.
    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Woah!");
    }

    // A function our user will hit to get their NFT.
    function makeAnEpicNFT() public {
        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomWord(newItemId, 0, firstWords);
        string memory second = pickRandomWord(newItemId, 1, secondWords);
        string memory third = pickRandomWord(newItemId, 2, thirdWords);

        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));
        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);

        // Set the NFTs data.
        _setTokenURI(newItemId, tokenUri);

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender, 
            finalSvg
        );

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }

    string tokenUri =
        "data:application/json;base64,ewogICAgIm5hbWUiOiAiRXBpY0xvcmRIYW1idXJnZXIiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LENqeHpkbWNnZG1WeWMybHZiajBpTVM0eElpQjRiV3h1Y3owaWFIUjBjRG92TDNkM2R5NTNNeTV2Y21jdk1qQXdNQzl6ZG1jaUlIaHRiRzV6T25oc2FXNXJQU0pvZEhSd09pOHZkM2QzTG5jekxtOXlaeTh4T1RrNUwzaHNhVzVySWlCNFBTSXdjSGdpSUhrOUlqQndlQ0lLQ1NCMmFXVjNRbTk0UFNJd0lEQWdOalFnTmpRaUlITjBlV3hsUFNKbGJtRmliR1V0WW1GamEyZHliM1Z1WkRwdVpYY2dNQ0F3SURZMElEWTBPeUlnZUcxc09uTndZV05sUFNKd2NtVnpaWEoyWlNJK0NqeHpkSGxzWlNCMGVYQmxQU0owWlhoMEwyTnpjeUkrQ2drdWMzUXdlMlpwYkd3Nkl6UkdOVVEzTXp0OUNna3VjM1F4ZTI5d1lXTnBkSGs2TUM0eU8zMEtDUzV6ZERKN1ptbHNiRG9qTWpNeFJqSXdPMzBLQ1M1emRETjdabWxzYkRvalF6YzFRelZETzMwS0NTNXpkRFI3Wm1sc2JEb2pSVEE1T1RWRk8zMEtDUzV6ZERWN1ptbHNiRG9qUmpWRFJqZzNPMzBLQ1M1emREWjdabWxzYkRvalJUQkZNRVF4TzMwS1BDOXpkSGxzWlQ0S1BHY2dhV1E5SWt4aGVXVnlYekVpUGdvSlBHYytDZ2tKUEdOcGNtTnNaU0JqYkdGemN6MGljM1F3SWlCamVEMGlNeklpSUdONVBTSXpNaUlnY2owaU16SWlMejRLQ1R3dlp6NEtDVHhuSUdOc1lYTnpQU0p6ZERFaVBnb0pDVHh3WVhSb0lHTnNZWE56UFNKemRESWlJR1E5SWswek1pNHhMRE01TGpkRE16QXVOU3cwTVM0eUxESTJMRFV5TGpJc01qWXNOVEl1TW1NdE1DNDNMREV1TWl3d0xqTXNNaTR4TERJdU5pd3dMamxzT0M0eExUUXVOR00wTGpRdE1pNDBMRFV1TWkwekxqRXNOUzR5TFRoc0xUQXVPQzAxTGprS0NRa0pZeTB3TGpNdE1pMHhMamd0TWk0MExUTXVNeTB3TGpoTU16SXVNU3d6T1M0M2VpSXZQZ29KUEM5blBnb0pQR2NnWTJ4aGMzTTlJbk4wTVNJK0Nna0pQSEJoZEdnZ1kyeGhjM005SW5OME1pSWdaRDBpVFRJM0xqRXNNelF1TjJNdE1TNDJMREV1TmkweE1pNDFMRFl1TVMweE1pNDFMRFl1TVdNdE1TNHlMREF1TnkweUxqRXRNQzR6TFRBdU9TMHlMalpNTVRnc016QmpNaTQwTFRRdU5Dd3pMakV0TlM0eUxEZ3ROUzR5YkRVdU9Td3dMamdLQ1FrSll6SXNNQzR6TERJdU5Dd3hMamdzTUM0NExETXVNMHd5Tnk0eExETTBMamQ2SWk4K0NnazhMMmMrQ2drOFp6NEtDUWs4Y0dGMGFDQmpiR0Z6Y3owaWMzUXpJaUJrUFNKTk16SXVNU3d6Tnk0M1F6TXdMalVzTXprdU1pd3lOaXcxTUM0eUxESTJMRFV3TGpKakxUQXVOeXd4TGpJc01DNHpMREl1TVN3eUxqWXNNQzQ1YkRndU1TMDBMalJqTkM0MExUSXVOQ3cxTGpJdE15NHhMRFV1TWkwNGJDMHdMamd0TlM0NUNna0pDV010TUM0ekxUSXRNUzQ0TFRJdU5DMHpMak10TUM0NFRETXlMakVzTXpjdU4zb2lMejRLQ1R3dlp6NEtDVHhuUGdvSkNUeHdZWFJvSUdOc1lYTnpQU0p6ZERNaUlHUTlJazB5Tnk0eExETXlMamRqTFRFdU5pd3hMall0TVRJdU5TdzJMakV0TVRJdU5TdzJMakZqTFRFdU1pd3dMamN0TWk0eExUQXVNeTB3TGprdE1pNDJUREU0TERJNFl6SXVOQzAwTGpRc015NHhMVFV1TWl3NExUVXVNbXcxTGprc01DNDRDZ2tKQ1dNeUxEQXVNeXd5TGpRc01TNDRMREF1T0N3ekxqTk1NamN1TVN3ek1pNDNlaUl2UGdvSlBDOW5QZ29KUEdjZ1kyeGhjM005SW5OME1TSStDZ2tKUEhCaGRHZ2dZMnhoYzNNOUluTjBNaUlnWkQwaVRUSXhMaklzTXprdU5XTTFMakV0TlM0eExEa3VNeTB6TGpVc09TNHpMVE11TlhNeExqVXNOQzR6TFRNdU5TdzVMak56TFRFekxqTXNPQzQ0TFRFekxqa3NPQzR4UXpFeUxqVXNOVEl1T1N3eE5pNHlMRFEwTGpZc01qRXVNaXd6T1M0MWVpSXZQZ29KUEM5blBnb0pQR2MrQ2drSlBIQmhkR2dnWTJ4aGMzTTlJbk4wTkNJZ1pEMGlUVEl4TGpJc016Y3VOV00xTGpFdE5TNHhMRGt1TXkwekxqVXNPUzR6TFRNdU5YTXhMalVzTkM0ekxUTXVOU3c1TGpOekxURXpMak1zT0M0NExURXpMamtzT0M0eFF6RXlMalVzTlRBdU9Td3hOaTR5TERReUxqWXNNakV1TWl3ek55NDFlaUl2UGdvSlBDOW5QZ29KUEdjK0Nna0pQSEJoZEdnZ1kyeGhjM005SW5OME5TSWdaRDBpVFRJMUxqVXNNek11TTJNMUxqRXROUzR4TERrdU15MHpMalVzT1M0ekxUTXVOWE14TGpVc05DNHpMVE11TlN3NUxqTlRNVGdzTkRjdU9Td3hOeTQwTERRM0xqSkRNVFl1Tnl3ME5pNDJMREl3TGpRc016Z3VOQ3d5TlM0MUxETXpMak42SWk4K0NnazhMMmMrQ2drOFp5QmpiR0Z6Y3owaWMzUXhJajRLQ1FrOGNHRjBhQ0JqYkdGemN6MGljM1F5SWlCa1BTSk5ORE11Tml3ek55NHhZeTAzTGpnc055NDRMVEU1TGpnc05TNDNMVEU1TGpnc05TNDNjeTB5TGpFdE1USXNOUzQzTFRFNUxqaHpNVGt1TmkwNExqWXNNakV1TWkwM0xqRkROVEl1TWl3eE55NDBMRFV4TGpRc01qa3VNeXcwTXk0MkxETTNMakY2SWdvSkNRa3ZQZ29KUEM5blBnb0pQR2MrQ2drSlBIQmhkR2dnWTJ4aGMzTTlJbk4wTmlJZ1pEMGlUVFF6TGpZc016VXVNV010Tnk0NExEY3VPQzB4T1M0NExEVXVOeTB4T1M0NExEVXVOM010TWk0eExURXlMRFV1TnkweE9TNDRjekU1TGpZdE9DNDJMREl4TGpJdE55NHhRelV5TGpJc01UVXVOQ3cxTVM0MExESTNMak1zTkRNdU5pd3pOUzR4ZWlJS0NRa0pMejRLQ1R3dlp6NEtDVHhuSUdOc1lYTnpQU0p6ZERFaVBnb0pDVHh3WVhSb0lHTnNZWE56UFNKemRESWlJR1E5SWsweU1TdzBOMk10TUM0NExEQXVPQzB4TGpNc01TNDFMVEl1TVN3d0xqZHNNQ3d3WXkwd0xqZ3RNQzQ0TFRBdU1TMHhMak1zTUM0M0xUSXVNV3c1TGprdE1USXVOMk13TGpndE1DNDRMRFF1TWkweExqVXNOQzQ1TFRBdU4yd3dMREFLQ1FrSll6QXVPQ3d3TGpnc01DNHhMRFF1TWkwd0xqY3NOQzQ1VERJeExEUTNlaUl2UGdvSlBDOW5QZ29KUEdjK0Nna0pQSEJoZEdnZ1kyeGhjM005SW5OME15SWdaRDBpVFRJeExEUTFZeTB3TGpnc01DNDRMVEV1TXl3eExqVXRNaTR4TERBdU4yd3dMREJqTFRBdU9DMHdMamd0TUM0eExURXVNeXd3TGpjdE1pNHhiRGt1T1MweE1pNDNZekF1T0Mwd0xqZ3NOQzR5TFRFdU5TdzBMamt0TUM0M2JEQXNNQW9KQ1Fsak1DNDRMREF1T0N3d0xqRXNOQzR5TFRBdU55dzBMamxNTWpFc05EVjZJaTgrQ2drOEwyYytDZ2s4WnlCamJHRnpjejBpYzNReElqNEtDUWs4WTJseVkyeGxJR05zWVhOelBTSnpkRElpSUdONFBTSXpPUzQySWlCamVUMGlNamN1TVNJZ2NqMGlOQ0l2UGdvSlBDOW5QZ29KUEdjZ1kyeGhjM005SW5OME1TSStDZ2tKUEdOcGNtTnNaU0JqYkdGemN6MGljM1F5SWlCamVEMGlORFV1TXlJZ1kzazlJakl4TGpVaUlISTlJaklpTHo0S0NUd3ZaejRLQ1R4blBnb0pDVHhqYVhKamJHVWdZMnhoYzNNOUluTjBNQ0lnWTNnOUlqTTVMallpSUdONVBTSXlOUzR4SWlCeVBTSTBJaTgrQ2drOEwyYytDZ2s4Wno0S0NRazhZMmx5WTJ4bElHTnNZWE56UFNKemREQWlJR040UFNJME5TNHpJaUJqZVQwaU1Ua3VOU0lnY2owaU1pSXZQZ29KUEM5blBnbzhMMmMrQ2p4bklHbGtQU0pNWVhsbGNsOHlJajRLUEM5blBnbzhMM04yWno0SyIKfQ==";
}
