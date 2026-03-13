*** Variables ***
# Website / UI
${TITLE_TEXT}          ShopB2Wise — Robot Framework Demo Store
${LOGO_TEXT}           css:#navbar .logo span

# Product price locators
${PRICE_HEADPHONES}    css:#price-prod-001
${PRICE_KEYBOARD}      css:#price-prod-002
${PRICE_COFFEE}        css:#price-prod-003
${PRICE_SHOES}         css:#price-prod-004
${PRICE_LAMP}          css:#price-prod-005
${PRICE_YOGA}          css:#price-prod-006
${PRICE_BACKPACK}      css:#price-prod-007
${PRICE_WATCH}         css:#price-prod-008

# Quantity increment locators
${QTY_INC_HEADPHONES}  css:#qty-inc-prod-001
${QTY_INC_KEYBOARD}    css:#qty-inc-prod-002
${QTY_INC_COFFEE}      css:#qty-inc-prod-003
${QTY_INC_SHOES}       css:#qty-inc-prod-004
${QTY_INC_LAMP}        css:#qty-inc-prod-005
${QTY_INC_YOGA}        css:#qty-inc-prod-006
${QTY_INC_BACKPACK}    css:#qty-inc-prod-007
${QTY_INC_WATCH}       css:#qty-inc-prod-008

# Add to cart button locators
${ADD_BTN_HEADPHONES}  css:#add-btn-prod-001
${ADD_BTN_KEYBOARD}    css:#add-btn-prod-002
${ADD_BTN_COFFEE}      css:#add-btn-prod-003
${ADD_BTN_SHOES}       css:#add-btn-prod-004
${ADD_BTN_LAMP}        css:#add-btn-prod-005
${ADD_BTN_YOGA}        css:#add-btn-prod-006
${ADD_BTN_BACKPACK}    css:#add-btn-prod-007
${ADD_BTN_WATCH}       css:#add-btn-prod-008

# Cart locators (dynamic using ${INDEX})
${CART_ITEM_NAME}      css:#cart-name-prod-00${INDEX}
${CART_ITEM_QTY}       css:#cart-qty-prod-00${INDEX}
${CART_DEC_BTN}        css:#cart-dec-prod-00${INDEX}
${CART_DEL_BTN}        css:#delete-btn-prod-00${INDEX}

# Cart summary
${CART_TOTAL}          css:#cart-total
${CART_ITEM_COUNT}     css:#cart-item-count
${CHECKOUT_BTN}        css:#checkout-btn
${MODAL_MSG}           css:#modal-msg

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