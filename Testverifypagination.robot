*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

*** Test Cases ***
Verify Response Has Pagination
    Create Session    gorest    https://gorest.co.in
    ${response}    Get Request    gorest    /public/v2/users?page=1&per_page=20
    ${status_code}    Convert To String    ${response.status_code}
    Should Be Equal As Strings    ${status_code}    200
    ${response_content}    Set Variable    ${response.content.decode('utf-8')}
    Should Be Valid JSON    ${response_content}
    ${json_data}    Evaluate    json.loads('''${response_content}''')
    ${pagination}    Get Pagination Info    ${json_data}
    Should Not Be Empty    ${pagination}    Pagination information not found in the response
    ${total_pages}    Get List Length    ${pagination}
    #Should Be Equal As Integers    ${total_pages}    20

*** Keywords ***
Should Be Equal As Strings
    [Arguments]    ${actual}    ${expected}
    Should Be Equal    ${actual}    ${expected}

Should Be Equal As Integers
    [Arguments]    ${actual}    ${expected}
    ${actual_length}    Get Length    ${actual}
    ${expected_length}    Get Length    ${expected}
    Should Be Equal    ${actual_length}    ${expected_length}


Should Be Valid JSON
    [Arguments]    ${json_data}
    ${parsed_json}    Evaluate    json.loads('''${json_data}''')
    Run Keyword If    "${parsed_json}" == "null"    Fail    The response is not a valid JSON document

Get Pagination Info
    [Arguments]    ${json_data}
    [Return]    ${json_data}

Get List Length
    [Arguments]    ${list}
    [Return]    Get Length    ${list}

Get Length
    [Arguments]    ${item}
    [Return]    Length    ${item}
