include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO hanickadot/compile-time-regular-expressions
    REF 1ab1d9d62a0e9317acc9353a02f780148fdae740 # v3.0.1
    SHA512 6bd95ee915fe64e6cbe8dd17881021fe2e2472878d602b51ea5100887e719253353571f96aaf7b6a7f83394a007f78132e9b5af33447b016e44905ca35929cb0
    HEAD_REF master
)

# Install header files
file(INSTALL ${SOURCE_PATH}/include DESTINATION ${CURRENT_PACKAGES_DIR})

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/ctre RENAME copyright)
