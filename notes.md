# facets/

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