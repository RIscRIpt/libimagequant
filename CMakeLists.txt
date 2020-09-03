cmake_minimum_required(VERSION 3.18)

project(imagequant
    VERSION 2.18.8
    LANGUAGES C
)

option(BUILD_SHARED_LIBS "Build shared library" ON)
option(BUILD_JNI "Build JNI bindings" ON)
option(USE_SSE "Use SSE" ON)

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_SOURCE_DIR}/cmake")

if(WIN32)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

file(GLOB SOURCES "*.c")

add_library(imagequant SHARED ${SOURCES})
target_include_directories(imagequant PRIVATE ${CMAKE_SOURCE_DIR})
if(USE_SSE)
    target_compile_definitions(imagequant PUBLIC USE_SSE=1)
endif()

if(BUILD_JNI)
    include(java)

    file(GLOB JAVA_SOURCES RELATIVE "${CMAKE_SOURCE_DIR}/org/pngquant" "org/pngquant/*.java")
    file(GLOB NATIVE_SOURCES RELATIVE "${CMAKE_SOURCE_DIR}/org/pngquant" "org/pngquant/*.c")

    add_jni_dll(imagequant_jni
        PATH "org/pngquant"
        JAVA_SOURCES ${JAVA_SOURCES}
        NATIVE_SOURCES ${NATIVE_SOURCES}
    )

    add_dependencies(imagequant_jni_dll imagequant)
endif()
