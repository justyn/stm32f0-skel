/**
 * udebug (aka μdebug) macros.
 */

#ifndef _UDEBUG_H_
#define _UDEBUG_H_

// Convert given argument to string
#define udebug_xstr(x) udebug_str(x)
#define udebug_str(x) #x

#if UDEBUG_LEVEL
	#include "udebug_conf.h"
#else
	#define UDEBUG_LEVEL 0
#endif

/* Only proceed if UDEBUG_LEVEL not 0 */
#if UDEBUG_LEVEL

/* Output format macros ------------------------------------------------------*/
#define _udebug_stringvar_file(_type, _string, _hang, _pause, ...)\
	udebug_printf( _string " (" _type ":" __FILE__ ":" udebug_xstr(__LINE__) ")\n", ##__VA_ARGS__);\
	if (_pause) { udebug_getchar() };\
	while(_hang)

#define _udebug_string_file(_type, _string, _hang, _pause, ...)\
	udebug_puts( _string " (" _type ":" __FILE__ ":" udebug_xstr(__LINE__) ")\n");\
	if (_pause) { udebug_getchar() };\
	while(_hang)

#define _udebug_stringvar_nofile(_type, _string, _hang, _pause, ...)\
	udebug_printf( _string " (" _type ")\n", ##__VA_ARGS__);\
	if (_pause) { udebug_getchar() };\
	while(_hang)

#define _udebug_string_nofile(_type, _string, _hang, _pause, ...)\
	udebug_puts( _string " (" _type ")\n");\
	if (_pause) { udebug_getchar() };\
	while(_hang)

#define _udebug_nostring_file(_type, _string, _hang, _pause, ...)\
	udebug_puts( "(" _type ":" __FILE__ ":" udebug_xstr(__LINE__) ")\n");\
	if (_pause) { udebug_getchar() };\
	while(_hang)

#define _udebug_nostring_nofile(_type, _string, _hang, _pause, ...)\
	udebug_puts( _type "\n");\
	if (_pause) { udebug_getchar() };\
	while(_hang)

#define _udebug_nothing(_type, _string, _hang, _pause, ...)\
	if (_pause) { udebug_getchar() };\
	while(_hang)

/* User macros ---------------------------------------------------------------*/

#ifndef udebug_info
	#define udebug_info(_str, ...)\
		_UDEBUG_INFO_OUTPUT		("I", _str, _UDEBUG_INFO_HANG, _UDEBUG_INFO_PAUSE, ##__VA_ARGS__)
#endif

#ifndef udebug_warn
	#define udebug_warn(_str, ...)\
		_UDEBUG_WARN_OUTPUT		("W", _str, _UDEBUG_WARN_HANG, _UDEBUG_WARN_PAUSE, ##__VA_ARGS__)
#endif

#ifndef udebug_error
	#define udebug_error(_str, ...)\
		_UDEBUG_ERROR_OUTPUT	("E", _str, _UDEBUG_ERROR_HANG, _UDEBUG_ERROR_PAUSE, ##__VA_ARGS__)
#endif

#ifndef udebug_assert
	#define udebug_assert(_expr)	\
		if (!(_expr)) { \
			_UDEBUG_ASSERT_OUTPUT("A", #_expr, _UDEBUG_ASSERT_HANG, _UDEBUG_ASSERT_PAUSE);}
#endif

/* ---------------------------------------------------------------------------*/


#else // UDEBUG_LEVEL=0

	/* Dummy macros */
	#define udebug_error(x, ...) while(0)
	#define udebug_warning(x, ...) while(0)
	#define udebug_info(x, ...) while(0)
	#define udebug_assert(x) while(0)

#endif // UDEBUG_LEVEL

#endif // include guard
