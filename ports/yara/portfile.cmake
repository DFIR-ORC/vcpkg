vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO VirusTotal/yara
  REF "v${VERSION}"
  SHA512 705db57b73e5165a26e0aaea728521f372b9f7f613665860dd22066c30e75a614815fb17ee8654780fcfc157f0137cbeda015ec088a698f31adcf071e233205f
  HEAD_REF master
  PATCHES
    # Module elf request new library tlshc(https://github.com/avast/tlshc), the related upstream PR: https://github.com/VirusTotal/yara/pull/1624.
    Disable-module-elf.patch
    xp_sp2_target.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
  FEATURES
    cuckoo    CUCKOO_MODULE
    dotnet    DOTNET_MODULE
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
      ${FEATURE_OPTIONS}
  OPTIONS_DEBUG 
      -DDISABLE_INSTALL_HEADERS=ON 
      -DDISABLE_INSTALL_TOOLS=ON
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME unofficial-libyara)

# Handle copyright
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
