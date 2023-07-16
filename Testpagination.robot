*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Test Cases ***
Verify Pagination
    Create Session    gorest    https://gorest.co.in
    ${response}    Get Request    gorest    /public/v2/users?page=1&per_page=20
    Should Be Equal As Strings    ${response.status_code}    200
    ${json_data}    Set Variable    ${response.content}
    ${pagination}    Get Pagination    ${json_data}
    Log Many    Pagination Information:    ${pagination}

*** Keywords ***
Get Pagination
    [Arguments]    ${json_data}
    ${pagination_data}    Get From Dictionary    ${json_data}    meta.pagination
    [Return]    ${pagination_data}
