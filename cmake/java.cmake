set(JAVA_HOME $ENV{JAVA_HOME})

find_package(Java 14.0 COMPONENTS Development REQUIRED)
find_package(JNI 14.0 REQUIRED)

function(add_jni target)
    cmake_parse_arguments("" "" "PATH" "JAVA_SOURCES;NATIVE_SOURCES" ${ARGN})
    set(input "${CMAKE_SOURCE_DIR}/${_PATH}")
    set(output "${CMAKE_BINARY_DIR}/${_PATH}")
    set(java_src ${_JAVA_SOURCES})
    set(native_src ${_NATIVE_SOURCES})
    list(TRANSFORM java_src PREPEND "${output}/")
    list(TRANSFORM native_src PREPEND "${output}/")
    add_custom_target("${target}_headers"
        COMMAND "${CMAKE_COMMAND}" -E copy_directory "${input}" "${output}"
        COMMAND "${Java_JAVAC_EXECUTABLE}" ${java_src}
        COMMAND "${Java_JAVAC_EXECUTABLE}" -h ${output} ${java_src}
    )
    add_library("${target}" SHARED ${native_src})
    target_include_directories("${target}" SYSTEM PRIVATE ${JNI_INCLUDE_DIRS})
    target_include_directories("${target}" PRIVATE ${CMAKE_SOURCE_DIR})
    target_link_libraries("${target}" imagequant ${JNI_LIBRARIES})
    set_property(SOURCE ${native_src} PROPERTY GENERATED 1)
    add_dependencies("${target}" "${target}_headers")
endfunction()
