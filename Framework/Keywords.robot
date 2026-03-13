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
#Script logic/ keywords below
OpenWebsite
    Open Local HTML And Maximize
    Title Should Be    ShopB2Wise — Robot Framework Demo Store  #Validates that the browsers title is correct
    ${text}=    Get Text    css:#navbar .logo span    #extracts the text from logo class and stores it to a variable
    Should Be Equal As Strings    ${text.strip()}    B2Wise    #uses extracted text stored into variable and validates that it should be equal as expected text
    Log To Console       Website Name: ${text}    #Prints variable to console


AddToBasketAction
        FOR    ${i}    IN RANGE    1    9
        ${sku}=    Set Variable    ${excel_dict["SKU${i}"]}
        ${qty}=    Set Variable    ${excel_dict["Quantity${i}"]}
        Run Keyword If    '${sku}' != 'NA'    addProducts   ${sku}    ${qty}
        END

addProducts
    [Arguments]    ${sku}    ${qty}
    # ----------------------------
    # Massive IF/ELSE block
    IF    '${sku}' == 'Wireless Headphones'
        Execute JavaScript    window.scrollTo(0, 0);
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-001    ELSE    Click Quantity Buttons    css:#qty-inc-prod-001    ${qty}
        Click Add To Cart    css:#add-btn-prod-001
        Log To Console    Wireless Headphones Total: ${headphones_total}

    ELSE IF    '${sku}' == 'Mechanical Keyboard'
        Execute JavaScript    window.scrollTo(0, 0);
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-002    ELSE    Click Quantity Buttons    css:#qty-inc-prod-002    ${qty}
        Click Add To Cart   css:#add-btn-prod-002
        Log To Console    Mechanical Keyboard Total: ${keyboard_total}

    ELSE IF    '${sku}' == 'Coffee Maker'
        Execute JavaScript    window.scrollTo(0, 0);
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-003    ELSE    Click Quantity Buttons    css:#qty-inc-prod-003    ${qty}
        Click Add To Cart    css:#add-btn-prod-003
        Log To Console    Coffee Maker Total: ${coffee_total}

    ELSE IF    '${sku}' == 'Running Shoes'
        Execute JavaScript    window.scrollTo(0, 0);
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-004    ELSE    Click Quantity Buttons    css:#qty-inc-prod-004    ${qty}
        Click Add To Cart    css:#add-btn-prod-004
        Log To Console    Running Shoes Total: ${shoes_total}

    ELSE IF    '${sku}' == 'Desk Lamp'
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-005    ELSE    Click Quantity Buttons    css:#qty-inc-prod-005    ${qty}
        Click Add To Cart    css:#add-btn-prod-005
        Log To Console    Desk Lamp Total: ${lamp_total}

    ELSE IF    '${sku}' == 'Yoga Mat'

        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-006    ELSE    Click Quantity Buttons    css:#qty-inc-prod-006    ${qty}
        Click Add To Cart    css:#add-btn-prod-006

        Log To Console    Yoga Mat Total: ${yoga_total}

    ELSE IF    '${sku}' == 'Backpack'
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-007    ELSE    Click Quantity Buttons    css:#qty-inc-prod-007    ${qty}
        Click Add To Cart    css:#add-btn-prod-007
        Log To Console    Backpack Total: ${backpack_total}

    ELSE IF    '${sku}' == 'Smart Watch'
        Run Keyword If    '${qty}' == '1'    Click Quantity Once    css:#qty-inc-prod-008    ELSE    Click Quantity Buttons    css:#qty-inc-prod-008    ${qty}
        Click Add To Cart    css:#add-btn-prod-008
        Log To Console    Smart Watch Total: ${watch_total}

    ELSE
        Log To Console    Unknown product
        RETURN
    END


RemoveFromBasketAction
    FOR    ${i}    IN RANGE    1    9
        ${sku}=    Set Variable    ${excel_dict["SKU${i}"]}
        ${qty_to_remove}=    Set Variable    ${excel_dict["RemoveQty${i}"]}
        Run Keyword If    '${sku}' != 'NA' and ${qty_to_remove} > 0    RemoveItemFromBasket    ${sku}    ${qty_to_remove}
    END

RemoveItemFromBasket
    [Arguments]    ${sku}    ${qty_to_remove}
    # Loop through all cart positions (1-8)
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

RemoveItemFromPosition
    [Arguments]    ${pos}    ${qty_to_remove}
    ${qty_in_basket}=    Get Text    css:#cart-qty-prod-00${pos}
    ${qty_in_basket}=    Convert To Integer    ${qty_in_basket}

    IF    ${qty_to_remove} >= ${qty_in_basket}
        Click Element    css:#delete-btn-prod-00${pos}
    ELSE
        Click Quantity Buttons    css:#cart-dec-prod-00${pos}    ${qty_to_remove}
    END

ExtractCartName
    [Arguments]    ${i}
    ${cart_name}=    Get Text    css:#cart-name-prod-00${i}
    Set Global Variable    ${cart_name}

CartQtyExtract
    [Arguments]    ${position}
    ${qty_in_basket}=    Get Text    css:#cart-qty-prod-00${position}   # adjust locator
    Set Global Variable    ${qty_in_basket}

CheckoutBtn2
   # Calculate combined total
  # ${combined_total}=    Evaluate    round(${headphones_total} + ${keyboard_total} + ${coffee_total} + ${shoes_total} + ${lamp_total} + ${yoga_total} + ${backpack_total} + ${watch_total}, 2)
    #${combined_total}=    Evaluate    "{:.2f}".format(${combined_total})
    #Set Global Variable    ${combined_total}
   # Log To Console    Combined Total of All Items: ${combined_total}

    Click Element    css:#checkout-btn
    Wait Until Element Is Visible    css:#modal-msg    20
    ${modal-msg}=    Get Text    css:#modal-msg

    ${expected_msg}=    Set Variable     ${expected_global_qty} item(s) totalling $${combined_total} — order confirmed! A confirmation will be sent shortly.
    Should Be Equal    ${modal-msg}    ${expected_msg}
    Log To Console    Order confirmation message : ${modal-msg}
    Log To Console    Order confirmation message Text : ${expected_msg}

CheckoutBtn
    ${combined_total}=    Set Variable    0

    # ----------------------------
    # Get all quantity elements dynamically
    ${qty_elements}=    Get WebElements    xpath=//span[starts-with(@id,'cart-qty-prod-')]

    FOR    ${qty_elem}    IN    @{qty_elements}
        ${qty_text}=    Get Text    ${qty_elem}
        ${qty}=         Convert To Number    ${qty_text}

        Run Keyword If    ${qty} == 0    Continue For Loop

        # Extract the product ID from the qty element's ID
        ${qty_id}=       Get Element Attribute    ${qty_elem}    id
        ${prod_id}=      Replace String    ${qty_id}    cart-qty-    cart-unit-price-

        # Get corresponding unit price
        ${price_text}=   Get Text    css:#${prod_id}
        ${price}=        Convert Price Text To Number    ${price_text}

        # Calculate total and add to combined
        ${total}=        Evaluate    round(${qty} * ${price}, 2)
        ${combined_total}=    Evaluate    round(${combined_total} + ${total}, 2)
        Log To Console    Product ${prod_id} Total: ${total}
    END

    # ----------------------------
    # Final combined total
    ${combined_total}=    Evaluate    "{:.2f}".format(${combined_total})
    Set Global Variable    ${combined_total}
    Log To Console    Combined Total of All Items: ${combined_total}

    # ----------------------------
    # Proceed to checkout
    Click Element    css:#checkout-btn
    Wait Until Element Is Visible    css:#modal-msg    20
    ${modal-msg}=    Get Text    css:#modal-msg

    # ----------------------------
    # Verify confirmation message
    ${expected_msg}=    Set Variable    ${expected_global_qty} item(s) totalling $${combined_total} — order confirmed! A confirmation will be sent shortly.
    Should Be Equal    ${modal-msg}    ${expected_msg}
    Log To Console    Order confirmation message : ${modal-msg}
    Log To Console    Order confirmation message Text : ${expected_msg}

Convert Price Text To Number
    [Arguments]    ${price_text}
    ${price_text}=    Replace String    ${price_text}    $    ${EMPTY}
    ${price}=    Convert To Number    ${price_text}
    [Return]    ${price}

Click Quantity Buttons
    [Arguments]    ${inc_css_selector}    ${qty}
    FOR    ${i}    IN RANGE    1    ${qty}
        Scroll Element Into View    ${inc_css_selector}
        Click Element    ${inc_css_selector}
        Sleep    0.3
    END

Click Quantity Once
    [Arguments]    ${inc_css_selector}
    Scroll Element Into View    ${inc_css_selector}


Click Add To Cart
    [Arguments]    ${Add_css_selector}
    Click Element    ${Add_css_selector}


ValidateShoppingCartSummary
    #Calculates that the total Quantity amount matches
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
    #${cart_count}=    Strip String    ${cart_count}
    Set Global Variable    ${cart_count}


    Should Be Equal    ${cart_count}    ${expected_qty}
    Log To Console    Ui Cart: ${cart_count}
    Log To Console    Datafile Quantities: ${expected_qty}

    #Scrolls to the cart summary bottom page
    Scroll Element Into View    css:#checkout-btn



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

ValidateCart
    ${deductedCart}=    Get Text    css:#cart-total
    ${deductedItems}=    Get Text    css:#cart-item-count
    ${combined_total}=    Get Text    css:#cart-total
    ${deductedCart}=    Replace String    ${deductedCart}    $    ${EMPTY}
    Log To Console    Cart Price after removal of items : ${deductedCart}
    Log To Console    Cart Price before removal of items : ${combined_total}
    Log To Console    Cart Items before removal of items : ${cart_count}
    Log To Console    Cart Items after removal of items : ${deductedItems}

    ${deductedItems}=    Strip String    ${deductedItems}               # remove spaces
    ${deductedItems}=    Replace String    ${deductedItems}    items    ${EMPTY}  # remove 'items'
    ${deductedItems}=    Convert To Number    ${deductedItems}
    ${deductedItems}=    Convert To Integer   ${deductedItems}   # now it’s 0


    ${expectedAmount}=    Set Variable    0
    ${expectedAmount}=    Convert To Integer   ${expectedAmount}   # now it’s 0

# If cart is completely empty
    IF    ${deductedItems} == ${expectedAmount}
        Should Be Equal    ${deductedItems}    ${expectedAmount}
        Log To Console    Cart is completely empty. Totals are 0.
    ELSE
        # Normal scenario: totals/items changed but not zero
        Should Not Be Equal    ${deductedCart}    ${combined_total}
        Should Not Be Equal    ${cart_count}    ${deductedItems}
        Log To Console    Cart totals before removal : $ ${combined_total} with ${cart_count}, after removal : $ ${deductedCart} with ${deductedItems} items remaining. updated correctly after removal.
    END






#Script flow/ Sequence below
AdditionOfProducts
    OpenWebsite
    AddToBasketAction
    ValidateShoppingCartSummary
    CheckoutBtn
    Sleep    10


DeletionOfProducts
    OpenWebsite
    AddToBasketAction
    ValidateShoppingCartSummary
    Sleep    5
    RemoveFromBasketAction
    Sleep    5
    ValidateBasketAfterRemoval
    ValidateCart