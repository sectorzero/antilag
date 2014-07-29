include(ExternalProject)

set(GOOGLE_TEST_VERSION "gtest-1.7.0.zip")
set(GOOGLE_TEST_VERSION_SHA1 "f85f6d2481e2c6c4a18539e391aa4ea8ab0394af")
set(GOOGLE_TEST_VERSION_URL "https://googletest.googlecode.com/files/${GOOGLE_TEST_VERSION}")
# set(GOOGLE_TEST_VERSION_URL "file:///Users/sectorzero/Tools/googletest/${GOOGLE_TEST_VERSION}")

set(GOOGLE_TEST_PROJ_NAME "GoogleTest")
set(GOOGLE_TEST_PREFIX_DIR "${CMAKE_BINARY_DIR}/${GOOGLE_TEST_PROJ_NAME}")

# How this works
# gtest build is a cmake build. This means we can use the full facility of
# cmake add_subdirectory to point to the directory of gtest which will invoke
# the build for gtest and also expose the well defined include paths and libraries
# without us having to re-define it again. This was the way cmake was designed to
# work and we are taking advantage of it to have clean design.
#
# What this script does is provide a flow to only download and extract the source
# of gtest and expose it's source dir path to the overall cmake process. The
# GOOGLE_TEST_SOURCE_DIR will be used at the top level CMakeLists.txt to use it 
# in the add_subdirectory()

ExternalProject_Add(
    ${GOOGLE_TEST_PROJ_NAME}
    PREFIX  ${GOOGLE_TEST_PREFIX_DIR}
    DOWNLOAD_DIR ${GOOGLE_TEST_PREFIX_DIR}/repo
    URL ${GOOGLE_TEST_VERSION_URL}
    URL_HASH SHA1=${GOOGLE_TEST_VERSION_SHA1}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    )

ExternalProject_Get_Property(${GOOGLE_TEST_PROJ_NAME} source_dir)
set(GOOGLE_TEST_SOURCE_DIR ${source_dir})
