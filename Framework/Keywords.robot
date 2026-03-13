*** Settings ***
Library     Collections
Library     OperatingSystem
Library     SeleniumLibrary
Library     RequestsLibrary
Library     RPA.Excel.Files
Resource    ..//Framework//Variable.robot
Resource    ..//Framework//commonKeywords.robot
Resource    DataFileConfig.robot

*** Keywords ***
# ----------------------------
# Opens the demo store website and validates page title and logo
OpenWebsite
    Open Local HTML And Maximize
    Title Should Be    ShopB2Wise — Robot Framework Demo Store  # Validate browser title
    ${text}=    Get Text    css:#navbar .logo span    # Extract text from logo element
    Should Be Equal As Strings    ${text.strip()}    B2Wise    # Validate logo text
    Log To Console       Website Name: ${text}    # Print website name to console

# ----------------------------
# Loops through datafile SKUs and quantities and adds products to cart
AddToBasketAction
        FOR    ${i}    IN RANGE    1    9
        ${sku}=    Set Variable    ${excel_dict["SKU${i}"]}  # Read SKU from datafile
        ${qty}=    Set Variable    ${excel_dict["Quantity${i}"]}  # Read Quantity
        Run Keyword If    '${sku}' != 'NA'    addProducts   ${sku}    ${qty}  # Add only if SKU is valid
        END

# ----------------------------
# Adds individual product to cart based on SKU and quantity
addProducts
    [Arguments]    ${sku}    ${qty}

    # IF/ELSE block to add different products to the cart
    IF    '${sku}' == 'Wireless Headphones'
        Execute JavaScript    window.scrollTo(0, 0);   # Scroll to top
        #Keyword IF statement to handle scenarios where qty either = 1 or more
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-001    ELSE    Click Quantity Buttons    css:#qty-inc-prod-001    ${qty}
        Click Add To Cart    css:#add-btn-prod-001

    ELSE IF    '${sku}' == 'Mechanical Keyboard'
        Execute JavaScript    window.scrollTo(0, 0);
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-002    ELSE    Click Quantity Buttons    css:#qty-inc-prod-002    ${qty}
        Click Add To Cart   css:#add-btn-prod-002


    ELSE IF    '${sku}' == 'Coffee Maker'
        Execute JavaScript    window.scrollTo(0, 0);
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-003    ELSE    Click Quantity Buttons    css:#qty-inc-prod-003    ${qty}
        Click Add To Cart    css:#add-btn-prod-003


    ELSE IF    '${sku}' == 'Running Shoes'
        Execute JavaScript    window.scrollTo(0, 0);
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-004    ELSE    Click Quantity Buttons    css:#qty-inc-prod-004    ${qty}
        Click Add To Cart    css:#add-btn-prod-004


    ELSE IF    '${sku}' == 'Desk Lamp'
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-005    ELSE    Click Quantity Buttons    css:#qty-inc-prod-005    ${qty}
        Click Add To Cart    css:#add-btn-prod-005


    ELSE IF    '${sku}' == 'Yoga Mat'
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-006    ELSE    Click Quantity Buttons    css:#qty-inc-prod-006    ${qty}
        Click Add To Cart    css:#add-btn-prod-006


    ELSE IF    '${sku}' == 'Backpack'
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-007    ELSE    Click Quantity Buttons    css:#qty-inc-prod-007    ${qty}
        Click Add To Cart    css:#add-btn-prod-007


    ELSE IF    '${sku}' == 'Smart Watch'
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-008    ELSE    Click Quantity Buttons    css:#qty-inc-prod-008    ${qty}
        Click Add To Cart    css:#add-btn-prod-008


    ELSE
        Log To Console    Unknown product
        RETURN
    END

# ----------------------------
# Loops through datafile SKUs and quantities to remove products from cart
RemoveFromBasketAction
    FOR    ${i}    IN RANGE    1    9
        ${sku}=    Set Variable    ${excel_dict["SKU${i}"]}
        ${qty_to_remove}=    Set Variable    ${excel_dict["RemoveQty${i}"]}
        Run Keyword If    '${sku}' != 'NA' and ${qty_to_remove} > 0    RemoveItemFromBasket    ${sku}    ${qty_to_remove}
    END

# ----------------------------
# Removes items from cart based on SKU and quantity
RemoveItemFromBasket
    [Arguments]    ${sku}    ${qty_to_remove}
    FOR    ${i}    IN RANGE    1    9
        ${exists}=    Run Keyword And Return Status    Element Should Be Visible    css:#cart-name-prod-00${i}

        IF    ${exists}
            ${cart_name}=    Get Text    css:#cart-name-prod-00${i}
            ${qty_in_basket}=    Get Text    css:#cart-qty-prod-00${i}
            ${qty_in_basket}=    Convert To Integer    ${qty_in_basket}

            IF    '${cart_name}' == '${sku}' and ${qty_to_remove} > 0
                ${adjusted_qty}=    Evaluate    ${qty_to_remove} + 1
                RemoveItemFromPosition    ${i}    ${adjusted_qty}
            END
        END
    END

# ----------------------------
# Removes specified quantity from a cart position
RemoveItemFromPosition
    [Arguments]    ${pos}    ${qty_to_remove}
    ${qty_in_basket}=    Get Text    css:#cart-qty-prod-00${pos}
    ${qty_in_basket}=    Convert To Integer    ${qty_in_basket}

    IF    ${qty_to_remove} >= ${qty_in_basket}   # Delete entire item if qty_to_remove >= qty_in_basket
        Click Element    css:#delete-btn-prod-00${pos}
    ELSE
        Click Quantity Buttons    css:#cart-dec-prod-00${pos}    ${qty_to_remove}  # Decrease quantity
    END

# ----------------------------
# Extracts the name of a cart item for global use
ExtractCartName
    [Arguments]    ${i}
    ${cart_name}=    Get Text    css:#cart-name-prod-00${i}
    Set Global Variable    ${cart_name}

# ----------------------------
# Extracts quantity of a cart item for global use
CartQtyExtract
    [Arguments]    ${position}
    ${qty_in_basket}=    Get Text    css:#cart-qty-prod-00${position}
    Set Global Variable    ${qty_in_basket}

# ----------------------------
# Calculates combined total for checkout and verifies order confirmation
CheckoutBtn
    ${combined_total}=    Set Variable    0

    # Get all quantity elements dynamically
    ${qty_elements}=    Get WebElements    xpath=//span[starts-with(@id,'cart-qty-prod-')]

    FOR    ${qty_elem}    IN    @{qty_elements}
        ${qty_text}=    Get Text    ${qty_elem}
        ${qty}=         Convert To Number    ${qty_text}

        Run Keyword If    ${qty} == 0    Continue For Loop  # Skip items with 0 quantity

        # Extract the product ID from the quantity element
        ${qty_id}=       Get Element Attribute    ${qty_elem}    id
        ${prod_id}=      Replace String    ${qty_id}    cart-qty-    cart-unit-price-

        # Get corresponding unit price
        ${price_text}=   Get Text    css:#${prod_id}
        ${price}=        Convert Price Text To Number    ${price_text}

        # Calculate total for this product
        ${total}=        Evaluate    round(${qty} * ${price}, 2)
        ${combined_total}=    Evaluate    round(${combined_total} + ${total}, 2)
        Log To Console    Product ${prod_id} Total: ${total}
    END

    ${combined_total}=    Evaluate    "{:.2f}".format(${combined_total})  # Format combined total
    Set Global Variable    ${combined_total}
    Log To Console    Combined Total of All Items: ${combined_total}

    # Proceed to checkout
    Click Element    css:#checkout-btn
    Wait Until Element Is Visible    css:#modal-msg    20
    ${modal-msg}=    Get Text    css:#modal-msg

    # Verify confirmation message
    ${expected_msg}=    Set Variable    ${expected_global_qty} item(s) totalling $${combined_total} — order confirmed! A confirmation will be sent shortly.
    Should Be Equal    ${modal-msg}    ${expected_msg}
    Log To Console    Order confirmation message : ${modal-msg}
    Log To Console    Order confirmation message Text : ${expected_msg}

# ----------------------------
# Converts price text with $ sign to number
Convert Price Text To Number
    [Arguments]    ${price_text}
    ${price_text}=    Replace String    ${price_text}    $    ${EMPTY}
    ${price}=    Convert To Number    ${price_text}
    [Return]    ${price}

# ----------------------------
# Clicks quantity increment button multiple times
Click Quantity Buttons
    [Arguments]    ${inc_css_selector}    ${qty}
    FOR    ${i}    IN RANGE    1    ${qty}
        Scroll Element Into View    ${inc_css_selector}
        Click Element    ${inc_css_selector}
        Sleep    0.3
    END

# ----------------------------
# Scrolls to quantity increment button and clicks once
Click Quantity Once
    [Arguments]    ${inc_css_selector}
    Scroll Element Into View    ${inc_css_selector}

# ----------------------------
# Clicks Add To Cart button
Click Add To Cart
    [Arguments]    ${Add_css_selector}
    Click Element    ${Add_css_selector}

# ----------------------------
# Validates shopping cart summary totals and quantities
ValidateShoppingCartSummary
    ${total}=    Set Variable    0

    FOR    ${i}    IN RANGE    1    9
        ${qty}=    Set Variable    ${excel_dict["Quantity${i}"]}

        IF    '${qty}' != 'NA'
            ${num}=    Convert To Integer    ${qty}
            ${total}=    Evaluate    ${total} + ${num}
        END
    END

   IF    ${total} == 1
    ${expected_qty}=    Set Variable    ${total} item
    ELSE
    ${expected_qty}=    Set Variable    ${total} items
   END
    Set Global Variable    ${expected_global_qty}    ${total}

    ${cart_count}=    Get Text    css:#cart-item-count
    Set Global Variable    ${cart_count}

    Should Be Equal    ${cart_count}    ${expected_qty}
    Log To Console    Ui Cart: ${cart_count}
    Log To Console    Datafile Quantities: ${expected_qty}

    Scroll Element Into View    css:#checkout-btn  # Scroll to checkout button

# ----------------------------
# Validates basket quantities after removal
ValidateBasketAfterRemoval
    FOR    ${i}    IN RANGE    1    9
        ${sku}=    Set Variable    ${excel_dict["SKU${i}"]}
        ${qty}=    Set Variable    ${excel_dict["Quantity${i}"]}
        ${remove_qty}=    Set Variable    ${excel_dict["RemoveQty${i}"]}

        IF    '${sku}' == 'NA'
            CONTINUE
        END

        ${qty}=    Convert To Integer    ${qty}

        IF    '${remove_qty}' != 'NA'
            ${remove_qty}=    Convert To Integer    ${remove_qty}
        ELSE
            ${remove_qty}=    Set Variable    0
        END

        ${expected_remaining}=    Evaluate    ${qty} - ${remove_qty}

        FOR    ${pos}    IN RANGE    1    9
            ${exists}=    Run Keyword And Return Status    Element Should Be Visible    css:#cart-name-prod-00${pos}

            IF    ${exists}
                ${cart_name}=    Get Text    css:#cart-name-prod-00${pos}
                IF    '${cart_name}' == '${sku}'
                    IF    ${expected_remaining} <= 0
                        Fail    ${sku} should have been removed but still exists in cart
                    END
                    ${ui_qty}=    Get Text    css:#cart-qty-prod-00${pos}
                    ${ui_qty}=    Convert To Integer    ${ui_qty}
                    Should Be Equal As Integers    ${ui_qty}    ${expected_remaining}
                    Log To Console    ${sku} validated. Remaining Qty: ${ui_qty}
                END
            END
        END

        IF    ${expected_remaining} <= 0
            Log To Console    ${sku} correctly removed from cart
        END
    END

# ----------------------------
# Validates cart totals and items after deletion
ValidateCart
    # Gets cart totals and items
    ${deductedCart}=    Get Text    css:#cart-total
    ${deductedItems}=    Get Text    css:#cart-item-count
    ${combined_total}=    Get Text    css:#cart-total

    ${deductedCart}=    Replace String    ${deductedCart}    $    ${EMPTY}
    Log To Console    Cart Price after removal of items : ${deductedCart}
    Log To Console    Cart Price before removal of items : ${combined_total}
    Log To Console    Cart Items before removal of items : ${cart_count}
    Log To Console    Cart Items after removal of items : ${deductedItems}

    ${deductedItems}=    Strip String    ${deductedItems}
    ${deductedItems}=    Replace String    ${deductedItems}    items    ${EMPTY}
    ${deductedItems}=    Convert To Number    ${deductedItems}
    ${deductedItems}=    Convert To Integer   ${deductedItems}

    ${expectedAmount}=    Set Variable    0
    ${expectedAmount}=    Convert To Integer   ${expectedAmount}

    # If cart is empty
    IF    ${deductedItems} == ${expectedAmount}
        Should Be Equal    ${deductedItems}    ${expectedAmount}
        Log To Console    Cart is completely empty. Totals are 0.
    ELSE
        # Normal scenario: totals/items changed but not zero
        Should Not Be Equal    ${deductedCart}    ${combined_total}
        Should Not Be Equal    ${cart_count}    ${deductedItems}
        Log To Console    Cart totals before removal : $ ${combined_total} with ${cart_count}, after removal : $ ${deductedCart} with ${deductedItems} items remaining. updated correctly after removal.
    END

# ----------------------------
# Script flow: Adds products, validates, and performs checkout
AdditionOfProducts
    OpenWebsite
    AddToBasketAction
    ValidateShoppingCartSummary
    CheckoutBtn
    Sleep    10

# ----------------------------
# Script flow: Adds products, removes some, validates cart after deletion
DeletionOfProducts
    OpenWebsite
    AddToBasketAction
    ValidateShoppingCartSummary
    Sleep    5
    RemoveFromBasketAction
    Sleep    5
    ValidateBasketAfterRemoval
    ValidateCart