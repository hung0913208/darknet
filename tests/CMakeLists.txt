include_directories(${CMAKE_SOURCE_DIR}/Base/Libraries/Base
		    ${CMAKE_SOURCE_DIR}/Base/Libraries/Base/Type
		    ${CMAKE_SOURCE_DIR}/Base/Libraries/Data
		    ${CMAKE_SOURCE_DIR}/Base/Libraries/Unittest
		    ${CMAKE_SOURCE_DIR}/Base/Libraries/Unittest/Implement
		    ${CMAKE_SOURCE_DIR}/Base/Libraries/Wrapping
		    ${CMAKE_SOURCE_DIR}/Base/Libraries/Wrapping/Implement
		    ${CMAKE_SOURCE_DIR}/src)

if(COMMAND cmake_policy)
	cmake_policy(SET CMP0003 NEW)
endif()

find_package(Threads)
find_package(PythonLibs)

add_subdirectory(darknet)
