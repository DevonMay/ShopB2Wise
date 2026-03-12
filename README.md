# E-Commerce Cart Automation Framework
### Project Overview

This project is an automation framework built using Robot Framework and Python for testing the ShopB2Wise e-commerce website.
The framework focuses on cart management scenarios, including:

- Adding multiple products from an Excel data file.

- Removing products partially or completely from the cart.

- Validating item quantities after removal.

- Validating cart totals and handling empty cart scenarios.

The framework uses data-driven and keyword-driven approaches to maximize reusability and maintainability.
## Robot Framework

Robot Framework is an open-source test automation framework that supports keyword-driven and data-driven testing. This project leverages Robot Framework to implement reusable keywords, interact with the web UI via SeleniumLibrary, and validate cart behavior across multiple scenarios.

## Key Features

Human-Readable Syntax: Robot Framework’s keyword-based syntax allows for clear and maintainable test scripts.

Keyword and Data-Driven Testing: All test steps are modular and reusable. Input data (SKUs, quantities, and removal quantities) are managed via Excel or CSV files.

## Comprehensive Cart Validation:

Ensures totals and item counts are correct after adding or removing items.

Handles singular and plural item labels dynamically.

Validates empty cart scenarios.

Dynamic Calculations: Cart totals are computed programmatically and formatted to two decimal places, ensuring consistent comparison with UI values.

Scalable Test Data: Easily extendable to multiple SKUs and different quantities without modifying test logic.

## Features

- Add products to the cart dynamically from Excel input.

- Remove products partially or fully from the cart.

- Validate remaining quantities per product.

- Validate cart totals after modifications.

- Support for empty cart scenario (totals and item count are 0).

- Logs meaningful console output for debugging.

- Robust against UI changes like extra spaces or currency symbols.

## Prerequisites

Python 3.10.0

Robot Framework 6.1.1

Browser driver (Chrome, Edge, or Firefox)

Excel file with product data (SKU1..SKU8, Quantity1..Quantity8, RemoveQty1..RemoveQty8)

Installed libraries required under Settings




## Project Structure


## Test Data

- Excel file contains SKU, Quantity, and RemoveQty columns for each product.

- Each test reads the data dynamically and performs actions based on it.

## Keywords Overview

- AddToBasketAction – Adds products from Excel to cart.

- addProducts – Handles individual product addition with dynamic quantity.

- ValidateShoppingCartSummary – Validates total quantities before removal.

- RemoveFromBasketAction – Removes products from the cart.

- RemoveItemFromBasket / RemoveItemFromPosition – Internal removal handling per cart position.

- ValidateBasketAfterRemoval – Validates remaining quantities per product.

- ValidateCart – Validates cart totals, item count, and empty cart scenario.

## Logging & Reporting

Console logs provide detailed info for each action:

- Product added/removed.

- Remaining quantities.

- Cart totals before and after changes.
