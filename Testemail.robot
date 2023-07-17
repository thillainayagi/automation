*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

*** Test Cases ***
Verify Response Has Email Addresses
    Create Session    gorest    https://gorest.co.in
    ${response}    Get Request    gorest    /public/v2/users
    ${status_code}    Convert To String    ${response.status_code}
    Should Be Equal As Strings    ${status_code}    200
    ${response_content}    Set Variable    ${response.content.decode('utf-8')}
    Should Be Valid JSON    ${response_content}
    ${json_data}    Evaluate    json.loads('''${response_content}''')
    ${users}    Set Variable    ${json_data}    \[data]
    ${email_addresses}    Get Email Addresses    ${users}
    Should Not Be Empty    ${email_addresses}    No email addresses found in the response

*** Keywords ***
Should Be Equal As Strings
    [Arguments]    ${actual}    ${expected}
    Should Be Equal    ${actual}    ${expected}

Should Be Valid JSON
    [Arguments]    ${json_data}
    ${parsed_json}    Evaluate    json.loads('''${json_data}''')
    Run Keyword If    "${parsed_json}" == "null"    Fail    The response is not a valid JSON document

Get Email Addresses
    [Arguments]    ${users}
    ${email_addresses}    Create List
    FOR    ${user}    IN    @{users}
        ${email}    Set Variable    ${user}    \[email]
        Append To List    ${email_addresses}    ${email}
    END
    [Return]    ${email_addresses}
