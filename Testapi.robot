*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary

*** Test Cases ***
Validate JSON Response
    Create Session    gorest    https://gorest.co.in
    ${headers}    Create Dictionary    Authorization=Bearer 5e3eaba6413d596a3548452219cddd1e30d25dbf609669fe747ef6c284ba97f4
    ${response}    Get Request    gorest    /public/v2/users    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    log to console ${response.content}
    #Should Be Valid JSON    ${response.content}

    ${json_data}    Parse JSON    ${response.content}
    ${results}    Get Value From JSON    ${json_data}    $.data
    Should Be True    ${results}    # Verify that the 'data' field is present and not empty
