/*
 * DriveDetailBox.cpp
 *
 *  Created on: Dec 10, 2021
 *      Author: magnus
 */

#include "DriveDetailBox.h"

#include <iostream>

DriveDetailBox::DriveDetailBox(DriveInfo& drive) :
	Gtk::Box(Gtk::ORIENTATION_VERTICAL),
	m_drive(drive)
{
	setDrive(drive);
}

DriveDetailBox::~DriveDetailBox()
{
}

void DriveDetailBox::setDrive(DriveInfo& drive)
{
	m_drive = drive;
}
