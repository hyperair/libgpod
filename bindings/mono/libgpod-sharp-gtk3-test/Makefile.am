ASSEMBLY = libgpod-sharp-gtk3-test
TARGET = exe
LINK = -r:../libgpod-sharp-gtk3/libgpod-sharp-gtk3.dll

SOURCES =  \
	../libgpod-sharp-gtk2-test/AssemblyInfo.cs \
	../libgpod-sharp-gtk2-test/Main.cs

EXTRAS = \
	libgpod-sharp-gtk3-test.in

if HAVE_MONO
include $(srcdir)/../Makefile.include
else
EXTRA_DIST = $(SOURCES)
endif
