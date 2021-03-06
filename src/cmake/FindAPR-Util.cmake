# Locate APR-Util include paths and libraries
include(FindPackageHandleStandardArgs)

# This module defines
# APR_UTIL_INCLUDE_DIR, where to find apr.h, etc.
# APR_UTIL_LIBRARIES, the libraries to link against to use APR.
# APR_UTIL_DLL_DIR, where to find libaprutil-1.dll
# APR_UTIL_FOUND, set to yes if found

macro(_apu_invoke _varname)
    execute_process(
        COMMAND ${APR_UTIL_CONFIG_EXECUTABLE} ${ARGN}
        OUTPUT_VARIABLE _apr_output
        RESULT_VARIABLE _apr_failed
    )

    if(_apr_failed)
        message(FATAL_ERROR "apu-1-config ${ARGN} failed with result ${_apr_failed}")
    else(_apr_failed)
        string(REGEX REPLACE "[\r\n]"  "" _apr_output "${_apr_output}")
        string(REGEX REPLACE " +$"     "" _apr_output "${_apr_output}")
        string(REGEX REPLACE "^ +"     "" _apr_output "${_apr_output}")

        separate_arguments(_apr_output)

        set(${_varname} "${_apr_output}")
    endif(_apr_failed)
endmacro(_apu_invoke)

find_program(APR_UTIL_CONFIG_EXECUTABLE
    apu-1-config
    PATHS /usr/local/bin    /usr/bin    C:/Progra~1/apr-util/bin
    )
mark_as_advanced(APR_UTIL_CONFIG_EXECUTABLE)
if(EXISTS ${APR_UTIL_CONFIG_EXECUTABLE})
    _apu_invoke(APR_UTIL_INCLUDE_DIR   --includedir)
    _apu_invoke(APR_UTIL_LIBRARIES     --link-ld)
else()
    find_path(APR_UTIL_INCLUDE_DIR apu.h PATH_SUFFIXES apr-1)
    find_library(APR_UTIL_LIBRARIES NAMES libaprutil-1 aprutil-1)
    find_path(APR_UTIL_DLL_DIR libaprutil-1.dll)
endif()

find_package_handle_standard_args(apr-util DEFAULT_MSG
  APR_UTIL_INCLUDE_DIR APR_UTIL_LIBRARIES)
