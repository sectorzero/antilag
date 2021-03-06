# >> --------- Google ProtoBuf ------------
include(ExternalProject)

set(GOOGLE_PROTOBUF_PROJ_NAME "GoogleProtobuf")
set(GOOGLE_PROTOBUF_PREFIX_DIR "${CMAKE_BINARY_DIR}/${GOOGLE_PROTOBUF_PROJ_NAME}")

set(GOOGLE_PROTOBUF_VERSION "protobuf-2.5.0.tar.gz")
set(GOOGLE_PROTOBUF_VERSION_SHA1 "7f6ea7bc1382202fb1ce8c6933f1ef8fea0c0148")
set(GOOGLE_PROTOBUF_VERSION_URL "https://protobuf.googlecode.com/files/${GOOGLE_PROTOBUF_VERSION}")

download_and_install_file(
    ${GOOGLE_PROTOBUF_VERSION}
    ${GOOGLE_PROTOBUF_VERSION_URL}
    ${GOOGLE_PROTOBUF_VERSION_SHA1}
    "${CMAKE_SOURCE_DIR}/.antilag-repo"
    )

ExternalProject_Add(
    ${GOOGLE_PROTOBUF_PROJ_NAME}
    PREFIX  ${GOOGLE_PROTOBUF_PREFIX_DIR}
    DOWNLOAD_COMMAND ""
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
    ${GOOGLE_PROTOBUF_PROJ_NAME}_download_source
    COMMENT "download source if it does not exist"
    COMMAND ${CMAKE_COMMAND} -E make_directory ${GOOGLE_PROTOBUF_PREFIX_DIR}/repo
    COMMAND ${CMAKE_COMMAND} -E copy_if_different "${CMAKE_SOURCE_DIR}/.antilag-repo/${GOOGLE_PROTOBUF_VERSION}" "${GOOGLE_PROTOBUF_PREFIX_DIR}/repo/${GOOGLE_PROTOBUF_VERSION}"
    DEPENDERS download
    WORKING_DIRECTORY <BINARY_DIR>
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

# Export Paths
set(GOOGLE_PROTOBUF_BINARY_PATH ${GOOGLE_PROTOBUF_PREFIX_DIR}/bin)
set(GOOGLE_PROTOBUF_INCLUDE_PATH ${GOOGLE_PROTOBUF_PREFIX_DIR}/include)

link_directories(${GOOGLE_PROTOBUF_PREFIX_DIR}/lib)

# proto generation : source modified from MaidSafe as use-case was similar
function(generate_proto_src BaseName ProtoRootDir GeneratedProtoRootDir ProtoRelativeDir)

    set(${BaseName}ProtoSources "" PARENT_SCOPE)
    set(${BaseName}ProtoHeaders "" PARENT_SCOPE)

    # Get list of .proto files
    file(GLOB ProtoFiles RELATIVE ${ProtoRootDir} ${ProtoRootDir}/${ProtoRelativeDir}/*.proto)

    # Search for and remove old generated .pb.cc and .pb.h files in the output dir
    file(GLOB ExistingPbFiles
        RELATIVE ${GeneratedProtoRootDir}
        ${GeneratedProtoRootDir}/${ProtoRelativeDir}/*.pb.*)
    list(LENGTH ExistingPbFiles ExistingPbFilesCount)
    string(REGEX REPLACE "([^;]*)\\.proto" "\\1.pb.cc;\\1.pb.h" GeneratedFiles "${ProtoFiles}")
    if(ExistingPbFilesCount)
        if(GeneratedFiles)
            list(REMOVE_ITEM ExistingPbFiles ${GeneratedFiles})
        endif()
        foreach(ExistingPbFile ${ExistingPbFiles})
            file(REMOVE ${GeneratedProtoRootDir}/${ExistingPbFile})
            # message(STATUS "Removed ${ExistingPbFile}")
        endforeach()
    endif()

    if(NOT ProtoFiles)
        return()
    endif()

    # Set up protoc arguments
    set(ProtocArgs "--proto_path=${ProtoRootDir}/${ProtoRelativeDir}")
    set(ProtoImportDirs ${ARGN})
    foreach(ProtoImportDir ${ProtoImportDirs})
        list(APPEND ProtocArgs "--proto_path=${ProtoImportDir}")
    endforeach()
    list(REMOVE_DUPLICATES ProtocArgs)
    list(APPEND ProtocArgs "--cpp_out=${GeneratedProtoRootDir}/${ProtoRelativeDir}")
    if(MSVC)
        list(APPEND ProtocArgs "--error_format=msvs")
    else()
        list(APPEND ProtocArgs "--error_format=gcc")
    endif()

    # message(STATUS "[generate_proto_src] BaseName=${BaseName}")
    # message(STATUS "[generate_proto_src] ProtoRootDir=${ProtoRootDir}")
    # message(STATUS "[generate_proto_src] GeneratedProtoRootDir=${GeneratedProtoRootDir}")
    # message(STATUS "[generate_proto_src] ProtoFiles=${ProtoFiles}")

    # protoc exec path
    # Add custom command to generate CC and header files
    unset(GeneratedProtoFiles)
    unset(GeneratedProtoSources)
    unset(GeneratedProtoHeaders)

    file(MAKE_DIRECTORY ${GeneratedProtoRootDir}/${ProtoRelativeDir})
    foreach(ProtoFile ${ProtoFiles})
        get_filename_component(ProtoFileNameWe ${ProtoFile} NAME_WE)
        set(GeneratedSource ${GeneratedProtoRootDir}/${ProtoRelativeDir}/${ProtoFileNameWe}.pb.cc)
        set(GeneratedHeader ${GeneratedProtoRootDir}/${ProtoRelativeDir}/${ProtoFileNameWe}.pb.h)
        list(APPEND GeneratedProtoSources "${GeneratedSource}")
        list(APPEND GeneratedProtoHeaders "${GeneratedHeader}")
        add_custom_command(OUTPUT ${GeneratedSource} ${GeneratedHeader}
            COMMAND ${GOOGLE_PROTOBUF_PREFIX_DIR}/bin/protoc ${ProtocArgs} ${ProtoRootDir}/${ProtoFile}
            DEPENDS ${GOOGLE_PROTOBUF_PREFIX_DIR}/bin/protoc ${ProtoRootDir}/${ProtoFile}
            COMMENT "Generated files from ${ProtoFileNameWe}.proto"
            VERBATIM)
    endforeach()

    set_source_files_properties(${GeneratedProtoSources} ${GeneratedProtoHeaders} PROPERTIES GENERATED TRUE)
    set_source_files_properties(${GeneratedProtoSources} PROPERTIES COMPILE_FLAGS "-w")

    set(${BaseName}ProtoSources ${GeneratedProtoSources} PARENT_SCOPE)
    set(${BaseName}ProtoHeaders ${GeneratedProtoHeaders} PARENT_SCOPE)

endfunction()
