# Stub CMakeLists.txt for flutter_sound on Linux
# This provides empty implementation to allow compilation
cmake_minimum_required(VERSION 3.10)

set(PROJECT_NAME "flutter_sound")
project(${PROJECT_NAME} LANGUAGES CXX)

set(PLUGIN_NAME "flutter_sound_plugin")

add_library(${PLUGIN_NAME} SHARED
  "flutter_sound_plugin.cc"
)

apply_standard_settings(${PLUGIN_NAME})

set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET default)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
# Export symbols so they can be found by the linker
target_compile_options(${PLUGIN_NAME} PRIVATE -fvisibility=default)

target_include_directories(${PLUGIN_NAME} INTERFACE
  "include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)

set(flutter_sound_bundled_libraries
  ""
  PARENT_SCOPE
)
