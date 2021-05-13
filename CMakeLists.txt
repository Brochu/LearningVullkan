cmake_minimum_required(VERSION 3.20)

project(LearnVulkan
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Vulkan REQUIRED)

add_executable(LearnVulkan)
target_sources(LearnVulkan PRIVATE main.cpp)

target_link_libraries(LearnVulkan PRIVATE Vulkan::Vulkan)
