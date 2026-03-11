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
        ${price_text}=    Get Text    css:#price-prod-001
        Execute JavaScript    window.scrollTo(0, 0);

        Click Quantity Buttons    css:#qty-inc-prod-001    ${qty}
        Click Add To Cart    css:#add-btn-prod-001
        ${price}=    Convert Price Text To Number    ${price_text}
        ${headphones_total}=    Evaluate    ${headphones_total} + (${price} * ${qty})
        Set Suite Variable    ${headphones_total}
        Log To Console    Wireless Headphones Total: ${headphones_total}

    ELSE IF    '${sku}' == 'Mechanical Keyboard'
        ${price_text}=    Get Text    css:#price-prod-002
        Execute JavaScript    window.scrollTo(0, 0);
        Click Quantity Buttons    css:#qty-inc-prod-002    ${qty}
        Click Add To Cart   css:#add-btn-prod-002
        ${price}=    Convert Price Text To Number    ${price_text}
        ${keyboard_total}=    Evaluate    ${keyboard_total} + (${price} * ${qty})
        Set Suite Variable    ${keyboard_total}
        Log To Console    Mechanical Keyboard Total: ${keyboard_total}

    ELSE IF    '${sku}' == 'Coffee Maker'
        ${price_text}=    Get Text    css:#price-prod-003
        Execute JavaScript    window.scrollTo(0, 0);
        Click Quantity Buttons    css:#qty-inc-prod-003    ${qty}
        Click Add To Cart    css:#add-btn-prod-003
        ${price}=    Convert Price Text To Number    ${price_text}
        ${coffee_total}=    Evaluate    ${coffee_total} + (${price} * ${qty})
        Set Suite Variable    ${coffee_total}
        Log To Console    Coffee Maker Total: ${coffee_total}

    ELSE IF    '${sku}' == 'Running Shoes'
        ${price_text}=    Get Text    css:#price-prod-004
        Execute JavaScript    window.scrollTo(0, 0);
        Click Quantity Buttons    css:#qty-inc-prod-004    ${qty}
        Click Add To Cart    css:#add-btn-prod-004
        ${price}=    Convert Price Text To Number    ${price_text}
        ${shoes_total}=    Evaluate    ${shoes_total} + (${price} * ${qty})
        Set Suite Variable    ${shoes_total}
        Log To Console    Running Shoes Total: ${shoes_total}

    ELSE IF    '${sku}' == 'Desk Lamp'
        ${price_text}=    Get Text    css:#price-prod-005
        Click Quantity Buttons   css:#qty-inc-prod-005    ${qty}
        Click Add To Cart    css:#add-btn-prod-005
        ${price}=    Convert Price Text To Number    ${price_text}
        ${lamp_total}=    Evaluate    ${lamp_total} + (${price} * ${qty})
        Set Suite Variable    ${lamp_total}
        Log To Console    Desk Lamp Total: ${lamp_total}

    ELSE IF    '${sku}' == 'Yoga Mat'
        ${price_text}=    Get Text    css:#price-prod-006
        Click Quantity Buttons    css:#qty-inc-prod-006    ${qty}
        Click Add To Cart    css:#add-btn-prod-006
        ${price}=    Convert Price Text To Number    ${price_text}
        ${yoga_total}=    Evaluate    ${yoga_total} + (${price} * ${qty})
        Set Suite Variable    ${yoga_total}
        Log To Console    Yoga Mat Total: ${yoga_total}

    ELSE IF    '${sku}' == 'Backpack'
        ${price_text}=    Get Text    css:#price-prod-007
        Click Quantity Buttons    css:#qty-inc-prod-007    ${qty}
        Click Add To Cart    css:#add-btn-prod-007
        ${price}=    Convert Price Text To Number    ${price_text}
        ${backpack_total}=    Evaluate    ${backpack_total} + (${price} * ${qty})
        Set Suite Variable    ${backpack_total}
        Log To Console    Backpack Total: ${backpack_total}

    ELSE IF    '${sku}' == 'Smart Watch'
        ${price_text}=    Get Text    css:#price-prod-008
        Click Quantity Buttons    css:#qty-inc-prod-008    ${qty}
        Click Add To Cart    css:#add-btn-prod-008
        ${price}=    Convert Price Text To Number    ${price_text}
        ${watch_total}=    Evaluate    ${watch_total} + (${price} * ${qty})
        Set Suite Variable    ${watch_total}
        Log To Console    Smart Watch Total: ${watch_total}

    ELSE
        Log To Console    Unknown product
        RETURN
    END

    # ----------------------------
    # Calculate combined total
    ${combined_total}=    Evaluate    round(${headphones_total} + ${keyboard_total} + ${coffee_total} + ${shoes_total} + ${lamp_total} + ${yoga_total} + ${backpack_total} + ${watch_total}, 2)
    Set Global Variable    ${combined_total}
    Log To Console    Combined Total of All Items: ${combined_total}



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
##############################DELETION NOT USING UNDER
CheckoutBtn
    Click Element    css:#checkout-btn
    Wait Until Element Is Visible    css:#modal-msg    20
    ${modal-msg}=    Get Text    css:#modal-msg

    ${expected_msg}=    Set Variable     ${expected_global_qty} item(s) totalling $${combined_total} — order confirmed! A confirmation will be sent shortly.
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

    ${expected_qty}=    Set Variable    ${total} items
    Set Global Variable    ${expected_global_qty}    ${total}

    ${cart_count}=    Get Text    css:#cart-item-count
    ${cart_count}=    Strip String    ${cart_count}
    Set Global Variable    ${cart_count}

    Should Be Equal    ${cart_count}    ${expected_qty}
    Log To Console    Ui Cart: ${cart_count}
    Log To Console    Datafile Quantities: ${expected_qty}

    #Scrolls to the cart summary bottom page
    Scroll Element Into View    css:#checkout-btn


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