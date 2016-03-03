#ifndef UDEBUG_CONF_H_
#define UDEBUG_CONF_H_

#define USE_UOS_SEMIHOSTING 1

/* Input/output mechanism ----------------------------------------------------*/

#if USE_UOS_SEMIHOSTING
#include "Trace.h"
#define udebug_printf(...) trace_printf (__VA_ARGS__)
#define udebug_puts(...) trace_puts (__VA_ARGS__)
#define udebug_getchar(...)
#else
#include <stdio.h>
#define udebug_printf(...) printf (__VA_ARGS__)
#define udebug_puts(...) puts (__VA_ARGS__)
#define udebug_getchar(...) getchar (__VA_ARGS__)
#endif

/* Pause/hang options --------------------------------------------------------*/

// Whether to pause for user input (ie via getchar) before continuing
#define _UDEBUG_INFO_PAUSE 0
#define _UDEBUG_WARN_PAUSE 0
#define _UDEBUG_ERROR_PAUSE 0
#define _UDEBUG_ASSERT_PAUSE 0

// Whether to hang in infinite loop
#define _UDEBUG_INFO_HANG 0
#define _UDEBUG_WARN_HANG 0
#define _UDEBUG_ERROR_HANG 1
#define _UDEBUG_ASSERT_HANG 1

/* Available format options for info, warn and error -------------------------*/
/*
 * _udebug_stringvar_file	- Full string with variables, and filename.
 * _udebug_string_file		- Full string without variables, and filename.
 * _udebug_stringvar_nofile	- Full string with variables, no filename.
 * _udebug_nostring_file	- Just filename
 * _udebug_nostring_nofile	- Just statement type (I, W, E or A)
 * _udebug_nothing			- No output
 *
 * In assert, the string is the failed expression.
*/
/* UDEBUG_LEVEL 1 ------------------------------------------------------------*/

#if UDEBUG_LEVEL==1

#define _UDEBUG_INFO_OUTPUT 		_udebug_nothing
#define _UDEBUG_WARN_OUTPUT 		_udebug_nostring_nofile
#define _UDEBUG_ERROR_OUTPUT 		_udebug_nostring_nofile
#define _UDEBUG_ASSERT_OUTPUT		_udebug_nostring_nofile

/* UDEBUG_LEVEL 2 ------------------------------------------------------------*/

#elif UDEBUG_LEVEL==2

#define _UDEBUG_INFO_OUTPUT 		_udebug_stringvar_nofile
#define _UDEBUG_WARN_OUTPUT 		_udebug_string_file
#define _UDEBUG_ERROR_OUTPUT 		_udebug_string_nofile
#define _UDEBUG_ASSERT_OUTPUT		_udebug_nostring_nofile


#endif // UDEBUG_LEVEL

/* Private variables ---------------------------------------------------------*/

extern void initialise_monitor_handles(void);

/* udebug_init ---------------------------------------------------------------*/

static inline int udebug_init()
{
#if !(USE_UOS_SEMIHOSTING)
	initialise_monitor_handles();
#endif
	return 0;
}

#endif // include guard
