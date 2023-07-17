*** Settings ***
Library    RequestsLibrary
Library    Collections
Library  OperatingSystem

*** Test Cases ***
Verify Certificate with Custom CA Bundle
    ${ca_bundle_path}  Set Variable   /opt/homebrew/etc/ca-certificates/cert.pem
    ${command}  Set Variable  python -c "import requests; requests.get('https://gorest.co.in/public/v2/users', verify='${ca_bundle_path}')"
    ${output}  Run  ${command}
    Log  ${output}



Verify Similar Attributes
    Create Session    gorest    https://gorest.co.in
    ${response}    Get Request    gorest    /public/v2/users
    Should Be Equal As Strings    ${response.status_code}    200
    ${json_data}    Set Variable    ${response.content}
    ${decoded_data}    Set Variable    """${json_data.decode('utf-8')}"""
    ${data}    Evaluate    eval(${decoded_data})
    ${users}    Get Users    ${data}
    Log Many    User Attributes:    ${users}

*** Keywords ***
Get Users
    [Arguments]    ${json_data}
    ${users}    Create List
    ${data}    Get From Dictionary    ${json_data}    data
    FOR    ${user}    IN    @{data}
        Append To List    ${users}    ${user}
    END
    [Return]    ${users}
