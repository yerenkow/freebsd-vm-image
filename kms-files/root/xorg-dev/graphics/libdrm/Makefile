# New ports collection makefile for:	libdrm
# Date created:				29 Dec 2005
# Whom:					lesi@FreeBSD.org
#
# $FreeBSD$
#

PORTNAME=	libdrm
PORTVERSION=	2.4.27
CATEGORIES=	graphics x11
MASTER_SITES=	http://dri.freedesktop.org/libdrm/

MAINTAINER=	x11@FreeBSD.org
COMMENT=	Userspace interface to kernel Direct Rendering Module services

BUILD_DEPENDS+=	${LOCALBASE}/libdata/pkgconfig/pthread-stubs.pc:${PORTSDIR}/devel/libpthread-stubs
LIB_DEPENDS=	pciaccess.0:${PORTSDIR}/devel/libpciaccess \
		pthread-stubs.0:${PORTSDIR}/devel/libpthread-stubs
RUN_DEPENDS+=	${LOCALBASE}/libdata/pkgconfig/pthread-stubs.pc:${PORTSDIR}/devel/libpthread-stubs

USE_BZIP2=	yes
GNU_CONFIGURE=	yes
USE_LDCONFIG=	yes

CONFIGURE_ARGS=	--enable-nouveau-experimental-api

MAKE_JOBS_SAFE=	yes

OPTIONS=	KMS "Enable KMS support (very experimental)" off

.include <bsd.port.options.mk>

.if defined(WITH_KMS)
CONFIGURE_ARGS+=--enable-libkms
EXTRA_PATCHES+=	${FILESDIR}/extra-xf86drmMode.c
PLIST_SUB+=	KMS=""
.else
PLIST_SUB+=	KMS="@comment "
.endif

pre-patch:
	@${REINPLACE_CMD} 's|{libdir}/pkgconfig|{prefix}/libdata/pkgconfig|g' \
	    ${WRKSRC}/configure

.include <bsd.port.mk>
