FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
 
SRC_URI_append = " file://egl_cast_fallback.diff"

