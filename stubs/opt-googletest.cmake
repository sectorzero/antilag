include(ExternalProject)

set(GOOGLE_TEST_VERSION "gtest-1.7.0.zip")
set(GOOGLE_TEST_VERSION_SHA1 "f85f6d2481e2c6c4a18539e391aa4ea8ab0394af")
set(GOOGLE_TEST_VERSION_URL "https://googletest.googlecode.com/files/${GOOGLE_TEST_VERSION}")
# set(GOOGLE_TEST_VERSION_URL "file:///Users/sectorzero/Tools/googletest/${GOOGLE_TEST_VERSION}")

set(GOOGLE_TEST_PROJ_NAME "GoogleTest")
set(GOOGLE_TEST_PREFIX_DIR "${CMAKE_BINARY_DIR}/${GOOGLE_TEST_PROJ_NAME}")

download_and_install_file(
    ${GOOGLE_TEST_VERSION}
    ${GOOGLE_TEST_VERSION_URL}
    ${GOOGLE_TEST_VERSION_SHA1}
    "${GOOGLE_TEST_PREFIX_DIR}/repo"
    )

ExternalProject_Add(
    ${GOOGLE_TEST_PROJ_NAME}
    PREFIX  ${GOOGLE_TEST_PREFIX_DIR}
    DOWNLOAD_DIR ${GOOGLE_TEST_PREFIX_DIR}/repo
    URL ${GOOGLE_TEST_VERSION_URL}
    URL_HASH SHA1=${GOOGLE_TEST_VERSION_SHA1}
    INSTALL_COMMAND ""
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    )

# TODO : Need to add paths for include and library references
