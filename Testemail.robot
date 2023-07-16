*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Test Cases ***
Verify Email Addresses
    Create Session    gorest    https://gorest.co.in
    ${response}    Get Request    gorest    /public/v2/users
    Should Be Equal As Strings    ${response.status_code}    200
    ${json_data}    Set Variable    ${response.content}
    ${email_addresses}    Get Email Addresses    ${json_data}
    Log Many    Email Addresses:    @{email_addresses}

*** Keywords ***
Get Email Addresses
    [Arguments]    ${json_data}
    ${email_regex}    Set Variable    ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
    ${email_addresses}    Create List
    ${users}    Get From Dictionary    ${json_data}    data
    FOR    ${user}    IN    @{users}
        ${email}    Get From Dictionary    ${user}    email
        Run Keyword If    Matches Regex    ${email}    ${email_regex}    Append To List    ${email_addresses}    ${email}
    END
    [Return]    ${email_addresses}
