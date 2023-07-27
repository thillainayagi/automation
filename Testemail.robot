*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

$base url ="https://gorest.co.in/public/v2/users
*** Test Cases ***
*** New Added for Code Optimization ***
Verify Response Has Email Address by Using Python Get Method
    ${response}    Get Request    baseurl
    ${status_code}    Convert To String    ${response.status_code}
    Should Be Equal As Strings    ${status_code}    200


Verify Response Has Email Addresses
    Create Session    gorest    https://gorest.co.in
    ${response}    Get Request    gorest    /public/v2/users
    ${status_code}    Convert To String    ${response.status_code}
    Should Be Equal As Strings    ${status_code}    200   
    ${response_content}    Set Variable    ${response.content.decode('utf-8')
    Should Be Valid JSON    ${response_content}
    ${json_data}    Evaluate    json.loads('''${response_content}''')
    ${users}    Set Variable    ${json_data}    \[data]
    ${email_addresses}    Get Email Addresses    ${users}
    Should Not Be Empty    ${random_email}    No email addresses found in the response
    

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



*** Python File named as gorest.py***

***Calling Get Method ***
import requests 
from automation import testemail  #import robot file to call url value


Class gorest

# The API endpoint

def get_request(self,endpoint):
	# Adding a payload below as an example
	payload = {"id": 1, "emailId": "abc.test.com" }

	# A get request to the API
	response = requests.get(url, params=payload)

	# Below GET request we can use without payload i.e. 1 key/value pair without list in the API response
	# response = requests.get(url)

	# store the response
	response_json = response.json()
	return response_json 
