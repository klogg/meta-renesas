require weston.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

BRANCH = "rcar-gen3/2.0.0/gl-fallback"

SRCREV = "${AUTOREV}"

SRC_URI = " \
    git://github.com/renesas-rcar/weston.git;branch=${BRANCH} \
    file://weston.png \
    file://weston.desktop \
    file://0001-make-error-portable.patch \
    file://0001-configure.ac-Fix-wayland-protocols-path.patch \
    file://xwayland.weston-start \
    file://0001-weston-launch-Provide-a-default-version-that-doesn-t.patch \
    file://weston.ini \
    file://weston_v4l2.ini \
"

S = "${WORKDIR}/git"

PACKAGECONFIG_append = " \
    ${@base_conditional('USE_MULTIMEDIA', '1', ' v4l2', '', d)} \
"
PACKAGECONFIG[v4l2] = " --enable-v4l2, --disable-v4l2,,kernel-module-vsp2driver"

do_install_append() {
    install -d ${D}/${sysconfdir}/xdg/weston
    if [ "X${USE_MULTIMEDIA}" = "X1" ]; then
        # install weston.ini as sample settings of v4l2-renderer
        if [ "${MACHINE}" = "m3ulcb" -o "${MACHINE}" = "h3ulcb" ] ; then
            sed -i 's|media1|media0|g' ${WORKDIR}/weston_v4l2.ini
        fi
        install -m 644 ${WORKDIR}/weston_v4l2.ini ${D}/${sysconfdir}/xdg/weston/weston.ini
    else
        # install weston.ini as sample settings of gl-renderer
        install -m 644 ${WORKDIR}/weston.ini ${D}/${sysconfdir}/xdg/weston/
    fi

    # Checking for ivi-shell configuration
    # If ivi-shell is enable, we will add its configs to weston.ini
    if [ "X${USE_WAYLAND_IVI_SHELL}" = "X1" ]; then
        sed -i '/repaint-window=34/c\repaint-window=34\nshell=ivi-shell.so' \
            ${D}/${sysconfdir}/xdg/weston/weston.ini
        sed -e '$a\\' \
            -e '$a\[ivi-shell]' \
            -e '$a\ivi-module=ivi-controller.so' \
            -e '$a\ivi-input-module=ivi-input-controller.so' \
            -e '$a\transition-duration=300' \
            -e '$a\cursor-theme=default' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    fi
}

FILES_${PN}_append = " \
    ${sysconfdir}/xdg/weston/weston.ini \
"
