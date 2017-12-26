SRC_URI_remove = "http://gstreamer.freedesktop.org/src/gst-omx/gst-omx-${PV}.tar.xz"
SRC_URI_append = " git://github.com/renesas-rcar/gst-omx.git;branch=RCAR-GEN3/1.12.2_intermediate \
                   file://gstomx.conf"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "omx-user-module mmngrbuf-user-module"

SRCREV = "${AUTOREV}"

LIC_FILES_CHKSUM = "file://COPYING;md5=4fbd65380cdd255951079008b364516c \
    file://omx/gstomx.h;beginline=1;endline=22;md5=e2c6664eda77dc22095adbed9cb6c6e4 \
"

S = "${WORKDIR}/git"

GSTREAMER_1_0_OMX_TARGET = "rcar"
GSTREAMER_1_0_OMX_CORE_NAME = "${libdir}/libomxr_core.so"
EXTRA_OECONF_append = " --enable-experimental"
EXTRA_OECONF_append = " --with-omx-header-path=${S}/omx/openmax"

do_compile_prepend() {
    cp ${WORKDIR}/gstomx.conf ${S}/config/rcar
}

do_configure_prepend() {
    export http_proxy=${http_proxy}
    export https_proxy=${https_proxy}
    export HTTP_PROXY=${HTTP_PROXY}
    export HTTPS_PROXY=${HTTPS_PROXY}
    cd ${S}
    ./autogen.sh --noconfigure
    cd ${B}
}

RDEPENDS_${PN} = "libwayland-egl"
