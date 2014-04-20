ASSEMBLY = libgpod-sharp-gtk3
TARGET = library
LINK = $(GLIBSHARP3_LIBS) $(GDKSHARP3_LIBS)

ORIGSOURCES =  \
	Artwork.cs \
	AssemblyInfo.cs \
	Chapter.cs \
	ChapterData.cs \
	Device.cs \
	GPodBase.cs \
	GPodList.cs \
	IpodInfo.cs \
	ITDB.cs \
	PhotoAlbum.cs \
	PhotoDB.cs \
	Playlist.cs \
	Thumbnail.cs \
	Track.cs
SOURCES = $(addprefix ../libgpod-sharp-gtk2/,$(ORIGSOURCES))

dlname := $(shell grep "^dlname=" $(top_builddir)/src/libgpod.la | sed "s/^dlname='\(.*\)'/\1/g")
libgpod-sharp-gtk3.dll.config: libgpod-sharp-gtk3.dll.config.in
	sed "s/@DLNAME@/$(dlname)/g" $< >$@

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libgpod-sharp-gtk3.pc
EXTRAS = \
	libgpod-sharp-gtk3.pc.in

if HAVE_MONO
include $(srcdir)/../Makefile.include
module_SCRIPTS += libgpod-sharp-gtk3.dll.config
EXTRA_DIST += libgpod-sharp-gtk3.dll.config.in
DISTCLEANFILES += libgpod-sharp-gtk3.dll.config
else
EXTRA_DIST = $(SOURCES) libgpod-sharp-gtk3.dll.config.in
DISTCLEANFILES = libgpod-sharp-gtk3.dll.config
endif
