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

AC_DEFUN([BAIL_OR_DISABLE_MONO],
[
	if test "$with_mono" = "yes"; then
		AC_MSG_ERROR([You need to install $1])
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

AC_DEFUN([CHECK_GLIB_GTK_SHARP_VERSION],
[
	AC_ARG_WITH([gtksharp$1],
		    [AC_HELP_STRING([--with-gtksharp$1=[[yes|no|auto]]],
				    [build gtk-sharp$1 bindings])],
		    [], [with_gtksharp$1=auto])

	case "$with_gtksharp$1" in
		yes|auto)
			found_gtksharp$1=yes

			PKG_CHECK_MODULES(
				[GDKSHARP$1],
				[gtk-sharp-$1.0 >= $GTK_SHARP$1_MIN_VERSION],
				[], [found_gtksharp$1="no"])
			PKG_CHECK_MODULES(
				[GLIBSHARP$1],
				[glib-sharp-$1.0 >= $GTK_SHARP$1_MIN_VERSION],
				[], [found_gtksharp$1="no"])

			if test "$with_gtksharp$1" = "yes" -a \
				"$found_gtksharp$1" = "no"; then
				AC_MSG_ERROR([You need to install gtk-sharp$1])

			elif test "$found_gtksharp$1" = "yes"; then
				with_gtksharp$1=yes

			else
				with_gtksharp$1=no
			fi
			;;
	esac

        AM_CONDITIONAL([HAVE_GTKSHARP$1], [test "$with_gtksharp$1" = "yes"])
])

AC_DEFUN([CHECK_GLIB_GTK_SHARP],
[
	CHECK_GLIB_GTK_SHARP_VERSION([2])
	CHECK_GLIB_GTK_SHARP_VERSION([3])

	if test "$with_gtksharp2" != "yes" -a "$with_gtksharp3" != "yes"; then
		BAIL_OR_DISABLE_MONO([gtk-sharp2 or gtk-sharp3])
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
