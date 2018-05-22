*** settings ***
Documentation     Kuber Demo.
Library           Collections
Library           RequestsLibrary
Library           OperatingSystem
Library           String
Library           SSHLibrary
Resource          resources/kube.txt
Suite Setup       Open Connection And Log In
Suite Teardown    Close All Connections


*** Test Cases ***
Test Login
    [Documentation]    Execute Command can be used to ran commands on the remote machine.

    ${output}=         Execute Command  echo Hello SSHLibrary!
    Should Be Equal    ${output}        Hello SSHLibrary!


Get Nodes list
    [Documentation]    Get the the list of number of Nodes.
    ${output}=         Execute Command  ${get_nodes}
    Log  ${output}
    Log  ${node_list}
    ${output_list}=    Split String    ${output}
    : FOR    ${ITEM}    IN   @{node_list}
    \    should contain  ${output}  ${ITEM}


create deployment
    [Tags]  test1
    [Documentation]    Create deployment.
    create_deployment   ${deployment_name1}
    ${deployment_list}  Execute Command  ${get_deployment}
    ${deployment_list}    Split String    ${deployment_list}
    should contain   ${deployment_list}  ${deployment_label}

Delete deployment
    [Tags]  test1
    [Documentation]    Delete deployment1.
    delete_deployment  ${deployment_label}
    ${deployment_list}  Execute Command  ${get_deployment}
    ${deployment_list}=    Split String    ${deployment_list}
    should not contain   ${deployment_list}  frontend

scale deployment
    [Tags]  test1
    [Documentation]    scale deployment
    create_deployment   ${deployment_name1}
    scale_deployment    ${deployment_name1}  ${desired_numbers}
    ${describe_deployment_out}  Execute Command  ${describe_deployment}  ${deployment_label}
    Log  ${describe_deployment_out}
    should contain   ${describe_deployment_out }  ${desired_numbers} desired

upgrade deployment
    [Tags]    sanity
    [Documentation]    upgrade deployment
    create_deployment   ${deployment_name1}
    ${deployment_list}  Execute Command  ${get_deployment}
    ${deployment_list}=    Split String    ${deployment_list}
    should contain   ${deployment_list}  ${deployment_label}
    upgrade_deployment   ${deployment_label}  ${image_name}  ${image_version}
    ${describe_deployment_out}  Execute Command  ${describe_deployment}  frontend
    Log  ${describe_deployment_out}
    should contain   ${describe_deployment_out }  ${image_name}:${image_version}
    sh
*** Keywords ***
Open Connection And Log In
   Open Connection     ${HOST}
   Login               ${USERNAME}        ${PASSWORD}



create_deployment
    [Arguments]   ${deployment_name}
    ${output}=          Execute Command  ${create_deployment} ${deployment_name}
    Log  ${output}

delete_deployment
    [Arguments]   ${deployment_label}
    ${output}=          Execute Command  ${delete_deployment} ${deployment_label}
    Log  ${output}


scale_deployment
    [Arguments]   ${deployment_name}  ${desired_numbers}
    ${scale_out}       Execute Command   ${scale_deployment} --replicas=${desired_numbers} -f ${deployment_name}
    Log  ${scale_out}


upgrade_deployment
    [Arguments]  ${deployment_label}  ${image_name}  ${image_version}
    ${upgarde_image}  Execute Command  kubectl set image deployments/${deployment_label} *=${image_name}:${image_version} --all
    Log  ${upgarde_image}