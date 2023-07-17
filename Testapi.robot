*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    JSONLibrary

*** Test Cases ***
Validate JSON Response
    Create Session    gorest    https://gorest.co.in
    ${headers}    Create Dictionary    Authorization=Bearer 5e3eaba6413d596a3548452219cddd1e30d25dbf609669fe747ef6c284ba97f4
    ${response}    Get Request    gorest    /public/v2/users    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json_data}    Set Variable    ${response.content}
    Run Keyword And Continue On Failure    Should Be Valid JSON    ${json_data}

    ${parsed_json}    Get From Dictionary    ${json_data}    data
    ${results}    Get From Dictionary    ${parsed_json}    data
    Should Be True    ${results}    # Verify that the 'data' field is present and not empty

*** Keywords ***
Should Be Valid JSON
    [Arguments]    ${json_data}
    Run And Return Rc And Output    python -c "import json, sys; json.loads('''${json_data}''')"    ignore_errors=True
    Run Keyword If    "${RC}" != "0"    Fail    The response is not a valid JSON document
