#pragma once

// Copyright (c) 2019 Christoffer Lerno. All rights reserved.
// Use of this source code is governed by the GNU LGPLv3.0 license
// a copy of which can be found in the LICENSE file.


#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>
#include <assert.h>
#include "errors.h"
#include <stdbool.h>

#define NO_ARENA 0
#define MAX_VECTOR_WIDTH 65536
#define MAX_ARRAY_SIZE INT64_MAX
#define MAX_IDENTIFIER_LENGTH 31
#define MAX_SOURCE_LOCATION_LEN 255
#define PROJECT_JSON "project.json"


#if defined( _WIN32 ) || defined( __WIN32__ ) || defined( _WIN64 )
#define PLATFORM_WINDOWS 1
#define PLATFORM_POSIX 0
#else
#define PLATFORM_WINDOWS 0
#define PLATFORM_POSIX 1
#endif

#ifndef USE_PTHREAD
#if PLATFORM_POSIX
#define USE_PTHREAD 1
#else
#define USE_PTHREAD 0
#endif
#endif

#define IS_GCC 0
#define IS_CLANG 0
#ifdef __GNUC__
#ifdef __clang__
#undef IS_CLANG
#define IS_CLANG 1
#else
#undef IS_GCC
#define IS_GCC 1
#endif
#endif

#ifndef __printflike
#define __printflike(x, y)
#endif

#ifndef __unused
#define __unused
#endif

#ifdef __GNUC__
#define PACK( __Declaration__ ) __Declaration__ __attribute__((__packed__))
#endif

#ifdef _MSC_VER
#define PACK( __Declaration__ ) __pragma( pack(push, 1) ) __Declaration__ __pragma( pack(pop))
#endif