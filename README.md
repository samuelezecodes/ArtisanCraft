# ArtisanCraft Smart Contract

## Overview

ArtisanCraft is a Clarity smart contract designed for a decentralized artisan marketplace on the Stacks blockchain. It allows artisans to manage their crafts, track mastery points, and maintain craft conditions.

## Features

- Add, complete, update, and remove crafts
- Track artisan mastery points
- Manage craft conditions
- Limit the number of crafts per artisan
- Implement owner-only functions for contract management

## Contract Details

### Constants

- `CONTRACT_OWNER`: The principal who deployed the contract
- `MAX_DESCRIPTION_LENGTH`: Maximum length for craft descriptions (128 characters)
- `MAX_ARTISAN_POINTS`: Maximum mastery points an artisan can accumulate (1,000,000)
- `CRAFTING_THRESHOLD`: Minimum mastery points required to perform a craft (100)
- `MAX_CRAFTS_PER_ARTISAN`: Maximum number of crafts an artisan can have (1,000)
- `MASTERY_REWARD`: Mastery points awarded for completing a craft (10)

### Data Structures

- `crafts`: Map storing craft details (description and condition) for each artisan and craft ID
- `artisan-data`: Map storing artisan data (mastery points and craft count)

### Public Functions

1. `add-craft`: Add a new craft for the caller
2. `complete-craft`: Mark a craft as completed and award mastery points
3. `update-craft-condition`: Update the condition of a craft
4. `remove-craft`: Remove a craft from the artisan's inventory
5. `update-mastery`: Update an artisan's mastery points (owner-only function)

### Read-Only Functions

1. `get-craft`: Retrieve details of a specific craft
2. `get-artisan-data`: Get an artisan's data (mastery points and craft count)
3. `get-total-crafts`: Get the total number of crafts in the system
4. `can-perform-craft`: Check if an artisan has enough mastery points to perform a craft
5. `get-valid-conditions`: Retrieve the list of valid craft conditions

## Usage

### Deploying the Contract

1. Ensure you have the Stacks CLI installed and configured
2. Deploy the contract using the Stacks CLI:

```bash
stacks deploy --contract-name artisan-craft --source-file path/to/artisan-craft.clar

# ArtisanCraft Smart Contract

## Overview
The **ArtisanCraft Smart Contract** is a decentralized system designed for managing artisan crafts. It allows artisans to register their crafts, update their statuses, and earn mastery points based on their contributions. The contract ensures secure and validated interactions on the **Stacks Blockchain** using **Clarity**.

## Features
- **Craft Management**: Artisans can add, update, complete, and remove crafts.
- **Mastery System**: Artisans gain mastery points upon completing crafts.
- **Craft Conditions**: Crafts have predefined statuses such as `listed`, `commissioned`, `completed`, `restoring`, and `archived`.
- **Validation Checks**: Ensures proper data integrity, input validation, and permission checks.
- **Ownership & Permissions**: Certain functions are restricted to contract owners.

## Smart Contract Functions

### Public Functions
#### `add-craft(description: string-ascii 128) -> (response uint err)`
Allows an artisan to add a new craft with a description.

#### `complete-craft(craft-id: uint) -> (response bool err)`
Marks a craft as completed and rewards mastery points to the artisan.

#### `update-craft-condition(craft-id: uint, new-condition: string-ascii 20) -> (response bool err)`
Updates the condition of an existing craft to a valid status.

#### `remove-craft(craft-id: uint) -> (response bool err)`
Removes a craft from the system.

#### `update-mastery(artisan: principal, points: int) -> (response uint err)`
Allows the contract owner to update an artisan’s mastery points.

### Read-Only Functions
#### `get-craft(artisan: principal, craft-id: uint) -> (option {description, condition})`
Retrieves details of a specific craft.

#### `get-artisan-data(artisan: principal) -> {mastery, crafts-count}`
Fetches an artisan’s mastery level and craft count.

#### `get-total-crafts() -> (response uint)`
Returns the total number of crafts in the system.

#### `can-perform-craft(artisan: principal) -> bool`
Checks if an artisan meets the mastery threshold to perform crafting.

#### `get-valid-conditions() -> (response list)`
Returns the list of valid craft conditions.

## Deployment & Usage
This contract is written in **Clarity**, a smart contract language for the **Stacks Blockchain**. To deploy and interact with this contract:
1. Deploy the contract using the Clarity runtime or a Stacks-compatible environment.
2. Invoke public functions through Stacks transactions.
3. Monitor interactions using read-only functions.

## Interacting with the Contract

You can interact with the contract using the Stacks CLI or by integrating it into your dApp.

Example: Adding a craft

```shellscript
stacks call --contract-name artisan-craft --function-name add-craft --arg '"My beautiful handmade vase"'
```

## Security Considerations

- The contract implements input validation to prevent common vulnerabilities
- Only the contract owner can update artisan mastery points
- There are limits on the number of crafts per artisan and total mastery points

## Future Improvements

1. Implement a marketplace feature for buying and selling crafts
2. Add a rating system for completed crafts
3. Introduce craft categories and specialized mastery points
4. Implement a governance system for updating contract parameters

## Contributing

Contributions to the ArtisanCraft smart contract are welcome. Please submit pull requests or open issues on the project's GitHub repository.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

