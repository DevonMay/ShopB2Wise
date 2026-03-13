*** Variables ***
# Website / UI
${TITLE_TEXT}          ShopB2Wise — Robot Framework Demo Store
${LOGO_TEXT}           css:#navbar .logo span

# Product price locators
${PRICE_HEADPHONES}    id:price-prod-001
${PRICE_HEADPHONES}    id:price-prod-001
${PRICE_KEYBOARD}      id:price-prod-002
${PRICE_COFFEE}        id:price-prod-003
${PRICE_SHOES}         id:price-prod-004
${PRICE_LAMP}          id:price-prod-005
${PRICE_YOGA}          id:price-prod-006
${PRICE_BACKPACK}      id:price-prod-007
${PRICE_WATCH}         id:price-prod-008

# Quantity increment locators
${QTY_INC_HEADPHONES}  id:qty-inc-prod-001
${QTY_INC_KEYBOARD}    id:qty-inc-prod-002
${QTY_INC_COFFEE}      id:qty-inc-prod-003
${QTY_INC_SHOES}       id:qty-inc-prod-004
${QTY_INC_LAMP}        id:qty-inc-prod-005
${QTY_INC_YOGA}        id:qty-inc-prod-006
${QTY_INC_BACKPACK}    id:qty-inc-prod-007
${QTY_INC_WATCH}       id:qty-inc-prod-008

# Add to cart button locators
${ADD_BTN_HEADPHONES}  id:add-btn-prod-001
${ADD_BTN_KEYBOARD}    id:add-btn-prod-002
${ADD_BTN_COFFEE}      id:add-btn-prod-003
${ADD_BTN_SHOES}       id:add-btn-prod-004
${ADD_BTN_LAMP}        id:add-btn-prod-005
${ADD_BTN_YOGA}        id:add-btn-prod-006
${ADD_BTN_BACKPACK}    id:add-btn-prod-007
${ADD_BTN_WATCH}       id:add-btn-prod-008

# Cart locators (dynamic variables using ${i} during execution, when replacing..please omit the last digit of the locator)
${CART_ITEM_NAME}      id:cart-name-prod-00
${CART_ITEM_QTY}       id:cart-qty-prod-00
${CART_DEC_BTN}        id:cart-dec-prod-00
${CART_DEL_BTN}        id:delete-btn-prod-00

# Cart summary
${CART_TOTAL}          id:cart-total
${CART_ITEM_COUNT}     id:cart-item-count
${CHECKOUT_BTN}        id:checkout-btn
${MODAL_MSG}           id:modal-msg

# Product totals
${headphones_total}    0
${keyboard_total}      0
${coffee_total}        0
${shoes_total}         0
${lamp_total}          0
${yoga_total}          0
${backpack_total}      0
${watch_total}         0

${Datafile}    DataFile/datafile.xlsx


${LOCAL_HTML}    file://${CURDIR}/../HTML/Shop-demo-B2Wise.html