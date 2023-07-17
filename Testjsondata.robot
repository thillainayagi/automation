*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary


#FunctionalRequirements: Verify Response has valid Json Data
*** Test Cases ***
Verify Response Data Has Valid JSON Format
    Create Session    gorest    https://gorest.co.in
    ${response}    Get Request    gorest    /public/v2/comments
    ${response_status}    Set Variable    ${response.status_code}
    ${status_code}    Convert To String    ${response.status_code}
    Should Be Equal As Strings    ${status_code}    200
    ${response_content}    Set Variable    ${response.content.decode('utf-8')}
    Should Be Valid JSON    ${response_content}

*** Keywords ***
Should Be Equal As Strings
    [Arguments]    ${actual}    ${expected}
    Should Be Equal    ${actual}    ${expected}

Should Be Valid JSON
    [Arguments]    ${json_data}
    ${parsed_json}    Evaluate    json.loads('''${json_data}''')
    Run Keyword If    "${parsed_json}" == "null"    Fail    The response is not a valid JSON document
