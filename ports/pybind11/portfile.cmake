vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pybind/pybind11
    REF c4a8b5bb9140cdc8c214044d41e2593986f875d0 # v2.6.0-RC2
    SHA512 48dbc5e6d23e5861e4eb8e867a662644d1e6949daf2cebce50e99aa86581add105c241792b8f7cf08197c63b20325edf55645ef3172b13c22c1638eaba6b49ae
    HEAD_REF master
)

vcpkg_find_acquire_program(PYTHON3)
get_filename_component(PYPATH ${PYTHON3} PATH)
vcpkg_add_to_path("${PYPATH}")

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DPYBIND11_TEST=OFF
        -DPYTHONLIBS_FOUND=ON
        -DPYTHON_INCLUDE_DIRS=${CURRENT_INSTALLED_DIR}/include
        -DPYTHON_MODULE_EXTENSION=.dll
    OPTIONS_RELEASE
        -DPYTHON_IS_DEBUG=OFF
        -DPYTHON_LIBRARIES=${CURRENT_INSTALLED_DIR}/lib/python36.lib
    OPTIONS_DEBUG
        -DPYTHON_IS_DEBUG=ON
        -DPYTHON_LIBRARIES=${CURRENT_INSTALLED_DIR}/debug/lib/python36_d.lib
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH share/cmake/pybind11)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/)

# copy license
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
