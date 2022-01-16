*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os

*** Variables ***
${BASE_URL}    https://restful-booker.herokuapp.com
${AUTH_ENDPOINT}     /auth
${BOOKING_ENDPOINT}    /booking

*** Test Cases ***
End To End Test
    ${AUTH_REQUEST_BODY}    load json from file    TestData/LoginPassword.json
    ${AUTH_HEADERS}    load json from file    TestData/LoginPasswordHeaders.json
    create session    Auth_Create_Token    ${BASE_URL}
    ${RESPONSE}    post on session    Auth_Create_Token    ${AUTH_ENDPOINT}    json=${AUTH_REQUEST_BODY}    headers=${AUTH_HEADERS}
    ${TOKEN}    convert to string    ${RESPONSE.content}
    ${ACTUAL_STATUS_CODE}    convert to string    ${RESPONSE.status_code}
    should be equal    ${ACTUAL_STATUS_CODE}    200

    ${REQUEST_BODY}    load json from file    TestData/CreateBookingData.json
    ${HEADERS}    load json from file    TestData/CreatBookingHeaders.json
    create session    Create_Booking    ${BASE_URL}
    ${RESPONSE}    post on session    Create_Booking    ${BOOKING_ENDPOINT}    json=${REQUEST_BODY}    headers=${HEADERS}

    ${ACTUAL_STATUS_CODE}    convert to string    ${RESPONSE.status_code}
    should be equal    ${ACTUAL_STATUS_CODE}    200

    @{bookingid_data}  get value from json    ${RESPONSE.json()}    bookingid
    ${BOOKINGID}    get from list    ${bookingid_data}    0

    @{firstname_data}    get value from json    ${RESPONSE.json()}    booking.firstname
    ${FIRSTNAME}    get from list    ${firstname_data}    0
    should be equal    ${FIRSTNAME}    Jim

    @{lastname_data}    get value from json    ${RESPONSE.json()}    booking.lastname
    ${LASTNAME}    get from list    ${lastname_data}    0
    should be equal    ${LASTNAME}    Brown

    @{total_price_data}    get value from json    ${RESPONSE.json()}    booking.totalprice
    ${total_price_int}    get from list    ${total_price_data}    0
    ${TOTAL_PRICE}    convert to string    ${total_price_int}
    should be equal    ${TOTAL_PRICE}    111

    @{depositpaid_data}    get value from json    ${RESPONSE.json()}    booking.depositpaid
    ${DEPOSITPAID}    get from list    ${depositpaid_data}    0
    should be true    ${DEPOSITPAID}

    @{checkin_data}    get value from json    ${RESPONSE.json()}    booking.bookingdates.checkin
    ${CHECKIN_DATE}    get from list    ${checkin_data}    0
    should be equal    ${CHECKIN_DATE}    2018-01-01

    @{checkout_data}    get value from json    ${RESPONSE.json()}    booking.bookingdates.checkout
    ${CHECKOUT_DATE}    get from list    ${checkout_data}    0
    should be equal    ${CHECKOUT_DATE}    2019-01-01

    @{add_needs_data}    get value from json    ${RESPONSE.json()}    booking.additionalneeds
    ${ADD_NEEDS}    get from list    ${add_needs_data}    0
    should be equal    ${ADD_NEEDS}    Breakfast


    ${CHECK_BOOKING_HEADERS}    load json from file    TestData/CheckBookingHeaders.json
    create session    Check_Booking1    ${BASE_URL}
    ${RESPONSE}    get on session    Check_Booking1    ${BOOKING_ENDPOINT}/${BOOKINGID}     headers=${CHECK_BOOKING_HEADERS}

    ${ACTUAL_STATUS_CODE}    convert to string    ${RESPONSE.status_code}
    should be equal    ${ACTUAL_STATUS_CODE}    200

    @{firstname_data}    get value from json    ${RESPONSE.json()}    firstname
    ${FIRSTNAME}    get from list    ${firstname_data}    0
    should be equal    ${FIRSTNAME}    Jim

    @{lastname_data}    get value from json    ${RESPONSE.json()}    lastname
    ${LASTNAME}    get from list    ${lastname_data}    0
    should be equal    ${LASTNAME}    Brown

    @{total_price_data}    get value from json    ${RESPONSE.json()}    totalprice
    ${total_price_int}    get from list    ${total_price_data}    0
    ${TOTAL_PRICE}    convert to string    ${total_price_int}
    should be equal    ${TOTAL_PRICE}    111

    @{depositpaid_data}    get value from json    ${RESPONSE.json()}    depositpaid
    ${DEPOSITPAID}    get from list    ${depositpaid_data}    0
    should be true    ${DEPOSITPAID}

    @{checkin_data}    get value from json    ${RESPONSE.json()}    bookingdates.checkin
    ${CHECKIN_DATE}    get from list    ${checkin_data}    0
    should be equal    ${CHECKIN_DATE}    2018-01-01

    @{checkout_data}    get value from json    ${RESPONSE.json()}    bookingdates.checkout
    ${CHECKOUT_DATE}    get from list    ${checkout_data}    0
    should be equal    ${CHECKOUT_DATE}    2019-01-01

    @{add_needs_data}    get value from json    ${RESPONSE.json()}    additionalneeds
    ${ADD_NEEDS}    get from list    ${add_needs_data}    0
    should be equal    ${ADD_NEEDS}    Breakfast

    create session    DeleteBooking    ${BASE_URL}    cookies=${TOKEN}
    ${DELETE_RESPONSE}    delete on session    DeleteBooking    ${BOOKING_ENDPOINT}/${BOOKINGID}
    ${ACTUAL_STATUS_CODE}    convert to string    ${DELETE_RESPONSE.status_code}
    should be equal    ${ACTUAL_STATUS_CODE}    201
    ${ACTUAL_BODY}    convert to string    ${DELETE_RESPONSE.content}
    should be equal    ${ACTUAL_BODY}    Created

    ${CHECK_BOOKING_HEADERS}    load json from file    TestData/CheckBookingHeaders.json
    create session    Check_Booking2    ${BASE_URL}
    ${RESPONSE}    get on session    Check_Booking2    ${BOOKING_ENDPOINT}/${BOOKINGID}     headers=${CHECK_BOOKING_HEADERS}    expected_status=any
    ${ACTUAL_STATUS_CODE}    convert to string    ${RESPONSE.status_code}
    should be equal    ${ACTUAL_STATUS_CODE}    404
    ${RESPONSE_BODY}    convert to string    ${RESPONSE.content}
    should be equal    ${RESPONSE_BODY}    Not Found