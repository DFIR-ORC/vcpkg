vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gabime/spdlog
    REF cbe9448650176797739dbab13961ef4c07f4290f # v1.8.1
    SHA512 a4719fe9083c662603b4819a58c5df8558262192f16a7d4b678ed761b042660727e0f614d106125b3756da3a01d56370bb46789d4b03bb468a170ad7b90172f3
    HEAD_REF v1.x
    PATCHES fix-featurebuild.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
	benchmark SPDLOG_BUILD_BENCH
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/tweakme.h DESTINATION ${SOURCE_PATH}/include/spdlog)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        ${FEATURE_OPTIONS}
        -DSPDLOG_FMT_EXTERNAL=ON
        -DSPDLOG_INSTALL=ON
)

vcpkg_install_cmake()

if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/${PORT}")
    vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/${PORT})
elseif(EXISTS "${CURRENT_PACKAGES_DIR}/lib/${PORT}/cmake")
    vcpkg_fixup_cmake_targets(CONFIG_PATH lib/${PORT}/cmake)
endif()

vcpkg_copy_pdbs()

# use vcpkg-provided fmt library (see also option SPDLOG_FMT_EXTERNAL above)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/spdlog/fmt/bundled)

vcpkg_replace_string(${CURRENT_PACKAGES_DIR}/include/spdlog/fmt/fmt.h
    "#if !defined(SPDLOG_FMT_EXTERNAL)"
    "#if 0 // !defined(SPDLOG_FMT_EXTERNAL)"
)

vcpkg_replace_string(${CURRENT_PACKAGES_DIR}/include/spdlog/fmt/ostr.h
    "#if !defined(SPDLOG_FMT_EXTERNAL)"
    "#if 0 // !defined(SPDLOG_FMT_EXTERNAL)"
)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/spdlog
                    ${CURRENT_PACKAGES_DIR}/debug/lib/spdlog
                    ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
