# facets/
## facets/DFAdminFacet.sol
- Owner can pause, change owner, change score, change radius, create planets, give spaceships

## facets/DFArtifactFacet.sol
- Create artifacts
- Functionality for calling library of depositing/activating/deactivating artifacts

### giveSpaceShips
- Gives a player 5 spaceships on their home planet (can only be called once)
- This is the first (and currently only) method of spawning ships into the game

## facets/DFCaptureFacet.sol
### invadePlanet
- checks planet is in capture zone
- Can only invade planets you own

### capturePlanet
- Planets can only be captured once
- Can only capture a planet you have already invaded
  - Cooldown between invasion and capture

### planetInCaptureZone
- There are a certain number of capture zones per 5000 radius
- These are proceduraly generated

## facets/DFCoreFacet.sol
- Entrypoint for various aspects of actions in the game
- refresh planet, reveal location (and check proof), initialize player, upgrade planet, transfer planet, buy hat, withdraw silver

## facets/DFGetterFacet.sol
- getters for states of the game

## facets/DFLobbyFacet.sol
- Create lobby

## facets/DFMoveFacet.sol
### move
- entrypoint for moving planets

### _executeMove
- Handles various aspects of a move
- calls _createArrival

### applySpaceshipDepart
- Home planets don't have penalty if a ship leaves
- Otherwise, reduce planet stats depending on ship type

### _abandonPlanet
- Cannot abandon a planet with incoming voyages
- When abandoning:
  1. Always send full energy and silver
  2. Receive a range / speed boost
  3. Transfer ownership to 0 address
  4. Place double the default amount of space pirates
  5. Subtract space junk from player total

## facets/DFWhitelistFacet.sol
- Various whitelist functionality

# libraries/
## libraries/LibArtifactUtils.sol
- A planet can only have 1 artifact activated at a time

### findArtifact
- Checks that an artifact is valid to be found at planet
- Generates the artifact based on the random seed inputs
- Adds points to the users score

### activateNonSpaceshipArtifact
- Artifacts can only be activated every certain amount of time since deactivation (dependent upon type)

### depositArtifact
- Can only deposit on trading posts
- Planet level must be higher than artifact rarity
- Cannot deposit spaceships
- Max 5 artifacts

### prospectPlanet
- Must prospect a planet before finding an artifact on it
- Starts a cooldown until finding can be done

## libraries/LibGameUtils.sol
### revertIfBadSnarkPerlinFlags
- Checks public inputs into the snark circuit

### _getRadius
- Radius increases as more players join

### _getUpgradeForArtifact
- Details the stats of what effects artifacts have on a planet

### checkPlanetDOS
- Check the arrivals from owner
- Check the arrivals from others
- Each of the above numbers can be at max 5

### _defaultPlanet
- Create a default planet based on its location, level, planet type and space type

## libraries/LibLazyUpdate.sol
Functions to update aspects of a planet such as:
- Silver
- Population

### applyArrival
- If the player sending ships owns the planet, then pop is increased
- Else, checks if the planet can defend against the invading ships. If not, the ship owner now owns the planet

## libraries/LibPlanet.sol
### revealLocation
- Can only reveal a location every x seconds

## libraries/LibStorage.sol
Diamond standard storage

# root
## DFInitialize.sol
- Customized version of DiamondInit.sol
- Initializes the state of the system such as planet defaults

## DFTypes.sol
- Various structs used in the game to store data (planets, players, artifacts)

## Verifier.sol
- Pairing check