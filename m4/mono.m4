AC_DEFUN([SHAMROCK_EXPAND_LIBDIR],
[
        expanded_libdir=`(
                case $prefix in
                        NONE) prefix=$ac_default_prefix ;;
                        *) ;;
                esac
                case $exec_prefix in
                        NONE) exec_prefix=$prefix ;;
                        *) ;;
                esac
                eval echo $libdir
        )`
        AC_SUBST(expanded_libdir)
])

AC_DEFUN([IF_WITH_MONO],
[
	case "$with_mono" in
		yes|auto)
			$1
			;;
	esac
])

AC_DEFUN([BAIL_OR_DISABLE_MONO]
[
	if test "$with_mono" = "yes"; then
		AC_MSG_ERROR([You need to install '$1'])
	elif
		with_mono=no
	fi
])

AC_DEFUN([SHAMROCK_FIND_PROGRAM],
[
	AC_PATH_PROG($1, $2, $3)
	AC_SUBST($1)
])

AC_DEFUN([SHAMROCK_FIND_PROGRAM_OR_BAIL],
[
	SHAMROCK_FIND_PROGRAM($1, $2, no)
	BAIL_OR_DISABLE_MONO([$2])
])

AC_DEFUN([SHAMROCK_FIND_MONO_2_0_COMPILER],
[
	SHAMROCK_FIND_PROGRAM_OR_BAIL(MCS, gmcs)
])

AC_DEFUN([SHAMROCK_FIND_MONO_RUNTIME],
[
	SHAMROCK_FIND_PROGRAM_OR_BAIL(MONO, mono)
])

AC_DEFUN([SHAMROCK_CHECK_MONO_MODULE],
[
	PKG_CHECK_MODULES([MONO_MODULE], [mono >= $1],
			  [], [BAIL_OR_DISABLE_MONO([mono])])
])

AC_DEFUN([CHECK_GLIB_GTK_SHARP],
[
        found_gtksharp="yes"
	PKG_CHECK_MODULES([GDKSHARP], [gtk-sharp-2.0 >= $GTK_SHARP_MIN_VERSION],
			  [], [found_gtksharp="no"])

	PKG_CHECK_MODULES([GLIBSHARP],
			  [glib-sharp-2.0 >= $GTK_SHARP_MIN_VERSION],
			  [], [found_gtksharp="no"])

	if test "X$found_gtksharp" != "Xyes"; then
		BAIL_OR_DISABLE_MONO([gtk-sharp])
	fi
])

dnl check for mono and required dependencies
AC_DEFUN([LIBGPOD_CHECK_MONO],
[
	AC_ARG_WITH(mono,
		    AC_HELP_STRING([--with-mono],
				   [build mono bindings [[default=auto]]]),
		    [with_mono=$withval],[with_mono=auto])

	AC_MSG_CHECKING(whether to build mono bindings)
	AC_MSG_RESULT($with_mono)

	SHAMROCK_EXPAND_LIBDIR
	IF_WITH_MONO([SHAMROCK_CHECK_MONO_MODULE([$MONO_MIN_VERSION])])
	IF_WITH_MONO([SHAMROCK_FIND_MONO_2_0_COMPILER])
	IF_WITH_MONO([SHAMROCK_FIND_MONO_RUNTIME])
	IF_WITH_MONO([CHECK_GLIB_GTK_SHARP])

	test "$with_mono" = "auto" && with_mono=yes
	AM_CONDITIONAL(HAVE_MONO, test "$with_mono" = "yes")
])
