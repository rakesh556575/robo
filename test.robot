*** settings ***
Documentation     Robot Demo.
Library           Collections
Library           RequestsLibrary
Library           OperatingSystem
Library           String
Library           Selenium2Library
Resource          resources/LoginUI.txt






*** Test Cases ***
LoginTest
    Open Browser to the Login Page
    Maximize Browser Window
    Enter User Name
    Enter Password
    Click Login
    sleep    ${Delay}
    Assert Dashboard Title
    [Teardown]    Close Browser


*** Keywords ***

Open Browser to the Login Page
    open browser    ${SiteUrl}    ${Browser}
    Maximize Browser Window
    Wait Until Element Is Visible   ${LoginUserName Id}

Enter User Name
    Input Text    ${LoginUserName Id}    ${Username}

Enter Password
    Input Text    ${LoginPassword Id}   ${Password}

Click Login
    click button    ${LoginButton Id}

Assert Dashboard Title
    Title Should be    ${DashboardTitle}


