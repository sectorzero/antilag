include(ExternalProject)

set(GOOGLE_TEST_VERSION "gtest-1.7.0.zip")
set(GOOGLE_TEST_VERSION_SHA1 "f85f6d2481e2c6c4a18539e391aa4ea8ab0394af")

set(GOOGLE_TEST_VERSION_URL "https://googletest.googlecode.com/files/${GOOGLE_TEST_VERSION}")
# set(GOOGLE_TEST_VERSION_URL "file:///${CMAKE_SOURCE_DIR}/.antilag-repo/${GOOGLE_TEST_VERSION}")
message(STATUS ${GOOGLE_PROTOBUF_VERSION_URL})

if(ENABLE_TESTING)

    set(GOOGLE_TEST_PROJ_NAME "GoogleTest")
    set(GOOGLE_TEST_PREFIX_DIR "${CMAKE_BINARY_DIR}/${GOOGLE_TEST_PROJ_NAME}")
    
    ExternalProject_Add(
        ${GOOGLE_TEST_PROJ_NAME}
        PREFIX  ${GOOGLE_TEST_PREFIX_DIR}
        DOWNLOAD_DIR ${GOOGLE_TEST_PREFIX_DIR}/repo
        URL ${GOOGLE_TEST_VERSION_URL}
        URL_HASH SHA1=${GOOGLE_TEST_VERSION_SHA1}
        # CMAKE_ARGS "${gtest_cmake_args}"
        UPDATE_COMMAND ""
        INSTALL_COMMAND ""
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
        )
    
    ExternalProject_Get_Property(${GOOGLE_TEST_PROJ_NAME} source_dir)
    set(GOOGLE_TEST_SOURCE_DIR ${source_dir})
    
    ExternalProject_Get_Property(${GOOGLE_TEST_PROJ_NAME} binary_dir)
    set(GOOGLE_TEST_BINARY_DIR ${binary_dir})
    
    link_directories(${GOOGLE_TEST_BINARY_DIR})
    
    enable_testing()

    function(add_cxx_test name src libs)
      include_directories(
          ${GOOGLE_TEST_SOURCE_DIR}/include
          ${CMAKE_SOURCE_DIR}
          )
      add_executable(${name} ${src})
      foreach (lib "${libs}")
        target_link_libraries(${name} ${lib})
      endforeach()
      target_link_libraries(${name} 
          gtest
          gtest_main
          # pthread
          )
      add_dependencies(${name} ${GOOGLE_TEST_PROJ_NAME})
      add_test(
          NAME ${name} 
          COMMAND ${name} "--gtest_break_on_failure"
          )
    endfunction()

endif()
