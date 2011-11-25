# New ports collection makefile for:	sessreg
# Date Created:				17 Feb 2006
# Whom:					Florent Thoumie <flz@FreeBSD.org>
#
# $FreeBSD: ports/x11/sessreg/Makefile,v 1.10 2011/02/25 16:52:16 miwi Exp $
#

PORTNAME=	sessreg
PORTVERSION=	1.0.7
CATEGORIES=	x11

MAINTAINER=	x11@FreeBSD.org
COMMENT=	Manage utmp/wtmp entries for non-init X clients

BUILD_DEPENDS+=	${LOCALBASE}/share/aclocal/xorg-macros.m4:${PORTSDIR}/devel/xorg-macros

XORG_CAT=	app
USE_XORG=	x11

PLIST_FILES=	bin/sessreg

MAN1=		sessreg.1

.include <bsd.port.mk>
