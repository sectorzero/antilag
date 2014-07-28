# Common Utilities

# Download a file from an url to a destination directory
# and verify the checksum
#   input : filename, url, checksum(sha1), destination_dir
#   output : download the object pointed to by the url to the download path
function(download_and_install_file Filename Url ChecksumSha1 DestinationDir)
    if(NOT EXISTS "${DestinationDir}/${Filename}")
        message(STATUS "Downloading ${Filename} to ${DestinationDir}")
    else()
        message(STATUS "Already Exists : ${Filename} in ${DestinationDir}")
    endif()
    file(DOWNLOAD 
            "${Url}" "${DestinationDir}/${Filename}"
            TIMEOUT 120
            INACTIVITY_TIMEOUT 300
            STATUS status
            LOG log
            SHOW_PROGRESS
            EXPECTED_HASH SHA1=${ChecksumSha1}
        )
    message(STATUS ${status})
    message(STATUS ${log})
endfunction()
