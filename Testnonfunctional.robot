*** Settings ***
Library    RequestsLibrary
Library    Collections

#Non Functional requirements
*** Test Cases ***

Verify HTTP Response Code
    Create Session    gorest    https://gorest.co.in
    ${response}    Get Request    gorest    /public/v2/comments
    ${status_code}    Convert To String    ${response.status_code}
    Should Be Equal As Strings    ${status_code}    200


Verify REST Service Without Authentication
    Create Session    gorest    https://gorest.co.in
    ${response}    Get Request    gorest    /public/v2/comments
    ${status_code}    Convert To String    ${response.status_code}
    Should Be Equal As Strings    ${status_code}    200
    ${json_data}    Set Variable    ${response.content}
    Should Be Valid JSON    ${json_data}

Verify Non-SSL REST Endpoint Behavior
    Create Session    gorest    http://gorest.co.in
    ${response}    Get Request    gorest    /public/v2/comments
    ${status_code}    Convert To String    ${response.status_code}
    Should Be Equal As Strings    ${status_code}    200
    ${json_data}    Set Variable    ${response.content}
    Should Be Valid JSON    ${json_data}


*** Keywords ***
Should Be Equal As Strings
    [Arguments]    ${actual}    ${expected}
    Should Be Equal    ${actual}    ${expected}


Should Be Valid JSON
    [Arguments]    ${json_data}
    ${parsed_json}    Evaluate    json.loads('''${json_data}''')
    Run Keyword If    "${parsed_json}" == "null"    Fail    The response is not a valid JSON document

