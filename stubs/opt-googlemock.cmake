include(ExternalProject)

set(GOOGLE_MOCK_VERSION "gmock-1.7.0.zip")
set(GOOGLE_MOCK_VERSION_SHA1 "f9d9dd882a25f4069ed9ee48e70aff1b53e3c5a5")
set(GOOGLE_MOCK_VERSION_URL "https://googlemock.googlecode.com/files/${GOOGLE_MOCK_VERSION}")
# set(GOOGLE_MOCK_VERSION_URL "file:///Users/sectorzero/Tools/googlemock/${GOOGLE_MOCK_VERSION}")

set(GOOGLE_MOCK_PROJ_NAME "GoogleMock")
set(GOOGLE_MOCK_PREFIX_DIR "${CMAKE_BINARY_DIR}/${GOOGLE_MOCK_PROJ_NAME}")

download_and_install_file(
    ${GOOGLE_MOCK_VERSION}
    ${GOOGLE_MOCK_VERSION_URL}
    ${GOOGLE_MOCK_VERSION_SHA1}
    "${GOOGLE_MOCK_PREFIX_DIR}/repo"
    )

ExternalProject_Add(
    ${GOOGLE_MOCK_PROJ_NAME}
    PREFIX  ${GOOGLE_MOCK_PREFIX_DIR}
    DOWNLOAD_DIR ${GOOGLE_MOCK_PREFIX_DIR}/repo
    URL ${GOOGLE_MOCK_VERSION_URL}
    URL_HASH SHA1=${GOOGLE_MOCK_VERSION_SHA1}
    INSTALL_COMMAND ""
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    )

# TODO : Need to add paths for include and library references
