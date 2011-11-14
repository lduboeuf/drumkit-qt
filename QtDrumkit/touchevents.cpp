/**
 * Copyright (c) 2011 Nokia Corporation.
 * All rights reserved.
 *
 * Part of the QtDrumkit
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#include "touchevents.h"
#include "qmlviewer.h"

TouchEvents::TouchEvents()
{
    // Reroute QmlViewer instance signal through this object.
    connect(QmlViewer::instance(), SIGNAL(touchEventReceived(int,int)),
            this, SIGNAL(touchEventReceived(int,int)));
}
