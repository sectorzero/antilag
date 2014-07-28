# >> --------- Google ProtoBuf ------------
include(ExternalProject)

set(GOOGLE_PROTOBUF_VERSION "protobuf-2.5.0.tar.gz")
set(GOOGLE_PROTOBUF_VERSION_SHA1 "7f6ea7bc1382202fb1ce8c6933f1ef8fea0c0148")
set(GOOGLE_PROTOBUF_VERSION_URL "https://protobuf.googlecode.com/files/${GOOGLE_PROTOBUF_VERSION}")
# set(GOOGLE_PROTOBUF_VERSION_URL "file:///Users/sectorzero/Tools/protobuf/${GOOGLE_PROTOBUF_VERSION}")

set(GOOGLE_PROTOBUF_PROJ_NAME "GoogleProtobuf")
set(GOOGLE_PROTOBUF_PREFIX_DIR "${CMAKE_BINARY_DIR}/${GOOGLE_PROTOBUF_PROJ_NAME}")

download_and_install_file(
    ${GOOGLE_PROTOBUF_VERSION}
    ${GOOGLE_PROTOBUF_VERSION_URL}
    ${GOOGLE_PROTOBUF_VERSION_SHA1}
    "${GOOGLE_PROTOBUF_PREFIX_DIR}/repo"
    )

ExternalProject_Add(
    ${GOOGLE_PROTOBUF_PROJ_NAME}
    PREFIX  ${GOOGLE_PROTOBUF_PREFIX_DIR}
    DOWNLOAD_DIR ${GOOGLE_PROTOBUF_PREFIX_DIR}/repo
    URL ${GOOGLE_PROTOBUF_VERSION_URL}
    URL_HASH SHA1=${GOOGLE_PROTOBUF_VERSION_SHA1}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --disable-shared
    LOG_DOWNLOAD ON
    LOG_UPDATE ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_TEST ON
    LOG_INSTALL ON
    )

ExternalProject_Add_Step(
    ${GOOGLE_PROTOBUF_PROJ_NAME}
    ${GOOGLE_PROTOBUF_PROJ_NAME}_make_check
    COMMENT "make check for google protobuf"
    COMMAND make check
    DEPENDEES build
    DEPENDERS install
    WORKING_DIRECTORY <BINARY_DIR>
    )
# << -------- Google ProtoBuf ------------
