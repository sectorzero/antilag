# >> --------- EasyLoggingCpp ------------
include(ExternalProject)

set(EASYLOGGINGCPP_PROJ_NAME "EasyLoggingCpp")
set(EASYLOGGINGCPP_PREFIX_DIR "${CMAKE_BINARY_DIR}/${EASYLOGGINGCPP_PROJ_NAME}")

set(EASYLOGGINGCPP_VERSION "easyloggingpp_v9.75.tar.gz")
set(EASYLOGGINGCPP_VERSION_SHA1 "7dddd6ed119c37a589f9d89bf3c58e217d079079")
set(EASYLOGGINGCPP_VERSION_URL "https://github.com/easylogging/easyloggingpp/releases/download/v9.75/${EASYLOGGINGCPP_VERSION}")

download_and_install_file(
    ${EASYLOGGINGCPP_VERSION}
    ${EASYLOGGINGCPP_VERSION_URL}
    ${EASYLOGGINGCPP_VERSION_SHA1}
    "${CMAKE_SOURCE_DIR}/.antilag-repo"
    )

ExternalProject_Add(
    ${EASYLOGGINGCPP_PROJ_NAME}
    PREFIX  ${EASYLOGGINGCPP_PREFIX_DIR}
    DOWNLOAD_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD ON
    LOG_UPDATE ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_TEST ON
    LOG_INSTALL ON
    )

ExternalProject_Add_Step(
    ${EASYLOGGINGCPP_PROJ_NAME}
    ${EASYLOGGINGCPP_PROJ_NAME}_download_source
    COMMENT "download source if it does not exist"
    COMMAND ${CMAKE_COMMAND} -E make_directory ${EASYLOGGINGCPP_PREFIX_DIR}/repo
    COMMAND ${CMAKE_COMMAND} -E copy_if_different "${CMAKE_SOURCE_DIR}/.antilag-repo/${EASYLOGGINGCPP_VERSION}" "${EASYLOGGINGCPP_PREFIX_DIR}/repo/${EASYLOGGINGCPP_VERSION}"
    DEPENDERS download
    WORKING_DIRECTORY <BINARY_DIR>
    )

ExternalProject_Add_Step(
    ${EASYLOGGINGCPP_PROJ_NAME}
    ${EASYLOGGINGCPP_PROJ_NAME}_extract_src
    COMMENT "extracting source headers"
    COMMAND ${CMAKE_COMMAND} -E tar xvzf  "${EASYLOGGINGCPP_PREFIX_DIR}/repo/${EASYLOGGINGCPP_VERSION}"
    DEPENDEES download
    DEPENDERS configure
    WORKING_DIRECTORY <BINARY_DIR>
    )

ExternalProject_Add_Step(
    ${EASYLOGGINGCPP_PROJ_NAME}
    ${EASYLOGGINGCPP_PROJ_NAME}_install_header
    COMMENT "copy easyloggingcpp.h to include"
    COMMAND ${CMAKE_COMMAND} -E make_directory ${EASYLOGGINGCPP_PREFIX_DIR}/include
    COMMAND ${CMAKE_COMMAND} -E copy_if_different "${EASYLOGGINGCPP_PREFIX_DIR}/src/${EASYLOGGINGCPP_PROJ_NAME}-build/easylogging++.h" "${EASYLOGGINGCPP_PREFIX_DIR}/include"
    DEPENDEES build
    DEPENDERS install
    WORKING_DIRECTORY <BINARY_DIR>
    )

# Export Paths
set(EASYLOGGINGCPP_INCLUDE_PATH ${EASYLOGGINGCPP_PREFIX_DIR}/include)
set_target_properties(${EASYLOGGINGCPP_PROJ_NAME}
    PROPERTIES INCLUDE_DIRECTORIES ${EASYLOGGINGCPP_INCLUDE_PATH}
    )
