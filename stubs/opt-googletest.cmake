include(ExternalProject)

set(GOOGLE_TEST_PROJ_NAME "GoogleTest")
set(GOOGLE_TEST_PREFIX_DIR "${CMAKE_BINARY_DIR}/${GOOGLE_TEST_PROJ_NAME}")

set(GOOGLE_TEST_VERSION "gtest-1.7.0.zip")
set(GOOGLE_TEST_VERSION_SHA1 "f85f6d2481e2c6c4a18539e391aa4ea8ab0394af")
set(GOOGLE_TEST_VERSION_URL "https://googletest.googlecode.com/files/${GOOGLE_TEST_VERSION}")

download_and_install_file(
    ${GOOGLE_TEST_VERSION}
    ${GOOGLE_TEST_VERSION_URL}
    ${GOOGLE_TEST_VERSION_SHA1}
    "${CMAKE_SOURCE_DIR}/.antilag-repo"
    )

ExternalProject_Add(
    ${GOOGLE_TEST_PROJ_NAME}
    PREFIX  ${GOOGLE_TEST_PREFIX_DIR}
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD ON
    LOG_UPDATE ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_TEST ON
    LOG_INSTALL ON
    )

ExternalProject_Add_Step(
    ${GOOGLE_TEST_PROJ_NAME}
    ${GOOGLE_TEST_PROJ_NAME}_download_source
    COMMENT "download source if it does not exist"
    COMMAND ${CMAKE_COMMAND} -E make_directory ${GOOGLE_TEST_PREFIX_DIR}/repo
    COMMAND ${CMAKE_COMMAND} -E copy_if_different "${CMAKE_SOURCE_DIR}/.antilag-repo/${GOOGLE_TEST_VERSION}" "${GOOGLE_TEST_PREFIX_DIR}/repo/${GOOGLE_TEST_VERSION}"
    DEPENDERS download
    WORKING_DIRECTORY <BINARY_DIR>
    )

# Export Paths
ExternalProject_Get_Property(${GOOGLE_TEST_PROJ_NAME} source_dir)
set(GOOGLE_TEST_SOURCE_DIR ${source_dir})

ExternalProject_Get_Property(${GOOGLE_TEST_PROJ_NAME} binary_dir)
set(GOOGLE_TEST_BINARY_DIR ${binary_dir})

link_directories(${GOOGLE_TEST_BINARY_DIR})

# Enable Testing in Cmake
enable_testing()

# Functions
function(add_cxx_test name src libs)
    message(STATUS "[INFO] add_cxx_test : ${name}, ${src}, ${libs}")

    # Executable Target
    add_executable(${name} ${src})

    # Dependent library compile and link resources
    foreach (lib "${libs}")
        get_property(
            ${lib}_IncludeDirs
            TARGET ${lib}
            PROPERTY INCLUDE_DIRECTORIES
            )
        target_include_directories(${name} PRIVATE ${${lib}_IncludeDirs})

        target_link_libraries(${name} ${lib})
    endforeach()

    # Dependent 'google-test' compile and link resources
    target_include_directories(${name} PRIVATE ${GOOGLE_TEST_SOURCE_DIR}/include)

    target_link_libraries(${name} 
        gtest
        gtest_main
        # pthread
        )

    # Explicit dependency on googletest ExternalProject_Add
    add_dependencies(${name} ${GOOGLE_TEST_PROJ_NAME})

    # Add test instance
    add_test(
        NAME ${name} 
        COMMAND ${name} "--gtest_break_on_failure"
        )
endfunction()
