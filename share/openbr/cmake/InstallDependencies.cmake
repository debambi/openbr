set(BR_INSTALL_DEPENDENCIES OFF CACHE BOOL "Install runtime dependencies.")

# OpenCV Libs
function(install_opencv_library lib)
  if(${BR_INSTALL_DEPENDENCIES})
    if(CMAKE_HOST_WIN32)
      if(${CMAKE_BUILD_TYPE} MATCHES Debug)
        set(BR_INSTALL_DEPENDENCIES_SUFFIX "d")
      endif()
      if(NOT MSVC)
        set(BR_INSTALL_DEPENDENCIES_PREFIX "lib")
      endif()
      list(GET OpenCV_LIB_DIR 0 cv_lib_stripped)
      install(FILES ${cv_lib_stripped}/../bin/${BR_INSTALL_DEPENDENCIES_PREFIX}${lib}${OpenCV_VERSION_MAJOR}${OpenCV_VERSION_MINOR}${OpenCV_VERSION_PATCH}${BR_INSTALL_DEPENDENCIES_SUFFIX}.dll DESTINATION bin)
    elseif(CMAKE_HOST_APPLE)
      set(OpenCV_LIB_DIR "/usr/local/lib")
      install(FILES ${OpenCV_LIB_DIR}/lib${lib}.${OpenCV_VERSION_MAJOR}.${OpenCV_VERSION_MINOR}.${OpenCV_VERSION_PATCH}${CMAKE_SHARED_LIBRARY_SUFFIX} DESTINATION lib)
      install(FILES ${OpenCV_LIB_DIR}/lib${lib}.${OpenCV_VERSION_MAJOR}.${OpenCV_VERSION_MINOR}${CMAKE_SHARED_LIBRARY_SUFFIX} DESTINATION lib)
      install(FILES ${OpenCV_LIB_DIR}/lib${lib}${CMAKE_SHARED_LIBRARY_SUFFIX} DESTINATION lib)
    else()
      set(OpenCV_LIB_DIR "/usr/local/lib")
      install(FILES ${OpenCV_LIB_DIR}/lib${lib}${CMAKE_SHARED_LIBRARY_SUFFIX}.${OpenCV_VERSION_MAJOR}.${OpenCV_VERSION_MINOR}.${OpenCV_VERSION_PATCH} DESTINATION lib)
      install(FILES ${OpenCV_LIB_DIR}/lib${lib}${CMAKE_SHARED_LIBRARY_SUFFIX}.${OpenCV_VERSION_MAJOR}.${OpenCV_VERSION_MINOR} DESTINATION lib)
      install(FILES ${OpenCV_LIB_DIR}/lib${lib}${CMAKE_SHARED_LIBRARY_SUFFIX} DESTINATION lib)
    endif()
  endif()
endfunction()

function(install_opencv_libraries libs)
  foreach(lib ${${libs}})
    install_opencv_library(${lib})
  endforeach()
endfunction()

# Qt Libs
function(install_qt_library lib)
  if(${BR_INSTALL_DEPENDENCIES})
    if(CMAKE_HOST_WIN32)
      if(${CMAKE_BUILD_TYPE} MATCHES Debug)
        set(BR_INSTALL_DEPENDENCIES_SUFFIX "d")
      endif()
      install(FILES ${_qt5Core_install_prefix}/bin/Qt5${lib}${BR_INSTALL_DEPENDENCIES_SUFFIX}.dll DESTINATION bin)
    elseif(CMAKE_HOST_APPLE)
      install(DIRECTORY ${_qt5Core_install_prefix}/lib/Qt${lib}.framework DESTINATION lib)
    else()
      install(FILES ${_qt5Core_install_prefix}/lib/libQt5${lib}.so.5.${Qt5Core_VERSION_MINOR}.${Qt5Core_VERSION_PATCH} DESTINATION lib)
      install(FILES ${_qt5Core_install_prefix}/lib/libQt5${lib}.so.5.${Qt5Core_VERSION_MINOR} DESTINATION lib)
      install(FILES ${_qt5Core_install_prefix}/lib/libQt5${lib}.so.5 DESTINATION lib)
      install(FILES ${_qt5Core_install_prefix}/lib/libQt5${lib}.so DESTINATION lib)
    endif()
  endif()
endfunction()

function(install_qt_libraries libs)
  foreach(lib ${${libs}})
    install_qt_library(${lib})
  endforeach()
endfunction()

# Qt Plugins
function(install_qt_imageformats)
  if(${BR_INSTALL_DEPENDENCIES})
    set(IMAGE_FORMATS_DIR "${_qt5Core_install_prefix}/plugins/imageformats")
    if(CMAKE_HOST_WIN32)
      set(INSTALL_DEPENDENCIES_PREFIX "")
      set(INSTALL_DEPENDENCIES_EXTENSION ".dll")
    elseif(CMAKE_HOST_APPLE)
      set(INSTALL_DEPENDENCIES_PREFIX "lib")
      set(INSTALL_DEPENDENCIES_EXTENSION ".dylib")
    else()
      set(INSTALL_DEPENDENCIES_PREFIX "lib")
      set(INSTALL_DEPENDENCIES_EXTENSION ".so")
    endif()
    install(FILES ${IMAGE_FORMATS_DIR}/${INSTALL_DEPENDENCIES_PREFIX}qgif${INSTALL_DEPENDENCIES_EXTENSION}
                  ${IMAGE_FORMATS_DIR}/${INSTALL_DEPENDENCIES_PREFIX}qico${INSTALL_DEPENDENCIES_EXTENSION}
                  ${IMAGE_FORMATS_DIR}/${INSTALL_DEPENDENCIES_PREFIX}qjpeg${INSTALL_DEPENDENCIES_EXTENSION}
                  ${IMAGE_FORMATS_DIR}/${INSTALL_DEPENDENCIES_PREFIX}qmng${INSTALL_DEPENDENCIES_EXTENSION}
                  ${IMAGE_FORMATS_DIR}/${INSTALL_DEPENDENCIES_PREFIX}qsvg${INSTALL_DEPENDENCIES_EXTENSION}
                  ${IMAGE_FORMATS_DIR}/${INSTALL_DEPENDENCIES_PREFIX}qtga${INSTALL_DEPENDENCIES_EXTENSION}
                  ${IMAGE_FORMATS_DIR}/${INSTALL_DEPENDENCIES_PREFIX}qtiff${INSTALL_DEPENDENCIES_EXTENSION}
                  ${IMAGE_FORMATS_DIR}/${INSTALL_DEPENDENCIES_PREFIX}qwbmp${INSTALL_DEPENDENCIES_EXTENSION}
            DESTINATION bin/imageformats)
  endif()
endfunction()

# Qt Other
function(install_qt_misc)
  if(MSVC)
    if(${CMAKE_BUILD_TYPE} MATCHES Debug)
      set(BR_INSTALL_DEPENDENCIES_SUFFIX "d")
    endif()
    install(FILES ${_qt5Core_install_prefix}/bin/libGLESv2${BR_INSTALL_DEPENDENCIES_SUFFIX}.dll DESTINATION bin)
    install(FILES ${_qt5Core_install_prefix}/bin/libEGL${BR_INSTALL_DEPENDENCIES_SUFFIX}.dll DESTINATION bin)
    file(GLOB icudlls ${_qt5Core_install_prefix}/bin/icu*.dll)
    install(FILES ${icudlls} DESTINATION bin)
    file(GLOB d3dcomp ${_qt5Core_install_prefix}/bin/d3dcompiler_*.dll)
    install(FILES ${d3dcomp} DESTINATION bin)
    install(FILES ${_qt5Core_install_prefix}/plugins/platforms/qwindows${BR_INSTALL_DEPENDENCIES_SUFFIX}.dll DESTINATION bin/platforms)
  endif()
endfunction()

# Compiler libraries
function(install_compiler_libraries)
  include(InstallRequiredSystemLibraries)
  if(${BR_INSTALL_DEPENDENCIES} AND MINGW)
    set(MINGW_DIR "MINGW_DIR-NOTFOUND" CACHE PATH "MinGW Path")
    get_filename_component(MINGW_DIR ${CMAKE_CXX_COMPILER} PATH)
    install(FILES ${MINGW_DIR}/libgcc_s_sjlj-1.dll ${MINGW_DIR}/libstdc++-6.dll DESTINATION bin)
  endif()
endfunction()

# R runtime
function(install_r_runtime)
  if(WIN32)
    find_path(R_DIR bin/Rscript.exe "C:/Program Files/R/*")
    install(DIRECTORY ${R_DIR}/ DESTINATION R)
  endif()
endfunction()

# FFMPEG
function(install_ffmpeg_help LIB)
  if(LIB)
    string(REGEX REPLACE "\\.[^.]*$" "" STRIPEXT ${LIB})
    file(GLOB LIBS "${STRIPEXT}.*[^a]")
    install(FILES ${LIBS} DESTINATION lib)
  endif()
endfunction()

function(install_ffmpeg)
  if(${BR_INSTALL_DEPENDENCIES})
    if(WIN32)
      list(GET OpenCV_LIB_DIR 0 cv_lib_stripped)
      if(${CMAKE_SIZEOF_VOID_P} MATCHES 8)
        set(FFMPEGSUFFIX "_64")
      else()
        set(FFMPEGSUFFIX "")
      endif()
      install(FILES ${cv_lib_stripped}/../bin/${BR_INSTALL_DEPENDENCIES_PREFIX}opencv_ffmpeg${OpenCV_VERSION_MAJOR}${OpenCV_VERSION_MINOR}${OpenCV_VERSION_PATCH}${FFMPEGSUFFIX}.dll DESTINATION bin)
    else()
      find_library(AVCODEC avcodec)
      install_ffmpeg_help(${AVCODEC})

      find_library(AVUTIL avutil)
      install_ffmpeg_help(${AVUTIL})

      find_library(AVFORMAT avformat)
      install_ffmpeg_help(${AVFORMAT})

      find_library(SWSCALE swscale)
      install_ffmpeg_help(${SWSCALE})

      find_library(XVIDCORE xvidcore)
      install_ffmpeg_help(${XVIDCORE})

      find_library(X264 x264)
      install_ffmpeg_help(${X264})

      find_library(BVPX bvpx)
      install_ffmpeg_help(${BVPX})

      find_library(VORBISENC vorbisenc)
      install_ffmpeg_help(${VORBISENC})

      find_library(VORBIS vorbis)
      install_ffmpeg_help(${VORBIS})

      find_library(THEORAENC theoraenc)
      install_ffmpeg_help(${THEORAENC})

      find_library(THEORADEC theoradec)
      install_ffmpeg_help(${THEORADEC})

      find_library(SPEEX speex)
      install_ffmpeg_help(${SPEEX})

      find_library(SCHROEDINGER-1.0 schroedinger-1.0)
      install_ffmpeg_help(${SCHROEDINGER-1.0})

      find_library(OPUS opus)
      install_ffmpeg_help(${OPUS})

      find_library(OPENJPEG openjpeg)
      install_ffmpeg_help(${OPENJPEG})

      find_library(MP3LAME mp3lame)
      install_ffmpeg_help(${MP3LAME})

      find_library(GSM gsm)
      install_ffmpeg_help(${GSM})

      find_library(VA va)
      install_ffmpeg_help(${VA})
    endif()
  endif()
endfunction()
