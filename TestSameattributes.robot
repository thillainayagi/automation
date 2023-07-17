*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BaseURL}    https://gorest.co.in/public/v2
${Endpoint}    /comments

*** Test Cases ***
VerifyAllEntriesHaveSameAttributes
    [Documentation]    Verify that all entries on the list have the same attributes
    Create Session    Base    ${BaseURL}
    ${response}    Get Request    Base    ${Endpoint}
    Should Be Equal As Strings    ${response.status_code}    200
    ${comments}    Set Variable    ${response.json()}
    Validate All Entries Have Same Attributes    ${comments}

*** Keywords ***
Validate All Entries Have Same Attributes
    [Arguments]    ${comments}
    ${expected_keys}    Create List    id    name    email    body
    FOR    ${comment}    IN    @{comments}
        Log To Console    Verifying attributes for comment with id: ${comment['id']}
        Validate Entry Attributes    ${comment}    ${expected_keys}
    END

Validate Entry Attributes
    [Arguments]    ${entry}    ${expected_keys}
    ${missing_keys}    Remove Values From List    ${expected_keys}    ...    @{entry.keys()}
    Run Keyword If    ${missing_keys}    Fail    The following attributes are missing in the entry: ${missing_keys}
