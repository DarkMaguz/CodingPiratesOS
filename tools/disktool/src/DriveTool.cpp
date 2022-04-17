/*
 * DiskTool.cpp
 *
 *  Created on: Dec 8, 2021
 *      Author: magnus
 */

#include "DriveTool.h"
#include <iostream>

#include <giomm.h>
#include <sigc++/sigc++.h>

DriveTool::DriveTool() :
	m_gvm(g_volume_monitor_get()) // Bug fix for getting signals to work.
{
	auto vm = Gio::VolumeMonitor::get();

	vm->signal_drive_changed().connect(sigc::mem_fun(*this, &DriveTool::onDeviceEvent));
	vm->signal_drive_connected().connect(sigc::mem_fun(*this, &DriveTool::onDeviceEvent));
	vm->signal_drive_disconnected().connect(sigc::mem_fun(*this, &DriveTool::onDeviceEvent));

	vm->signal_mount_changed().connect(sigc::mem_fun(*this, &DriveTool::onDeviceEvent));
	vm->signal_mount_added().connect(sigc::mem_fun(*this, &DriveTool::onDeviceEvent));
	vm->signal_mount_pre_unmount().connect(sigc::mem_fun(*this, &DriveTool::onDeviceEvent));
	vm->signal_mount_removed().connect(sigc::mem_fun(*this, &DriveTool::onDeviceEvent));

	vm->signal_volume_changed().connect(sigc::mem_fun(*this, &DriveTool::onDeviceEvent));
	vm->signal_volume_added().connect(sigc::mem_fun(*this, &DriveTool::onDeviceEvent));
	vm->signal_volume_removed().connect(sigc::mem_fun(*this, &DriveTool::onDeviceEvent));

	updateDrives();
}

DriveTool::~DriveTool()
{
}

sigc::signal<void> DriveTool::signalDrivesUpdated(void)
{
	return m_signalDrivesUpdated;
}

t_drivesList& DriveTool::getDrives(void)
{
	return m_drives;
}

void DriveTool::onDeviceEvent(const Glib::RefPtr<Glib::Interface>& device)
{
	updateDrives();
	m_signalDrivesUpdated.emit();
}

void DriveTool::updateDrives(void)
{
	auto vm = Gio::VolumeMonitor::get();
	auto drives = vm->get_connected_drives();

	m_drives.clear();
	for (auto drive : drives)
	{
		DriveInfo di(drive);
		m_drives.push_back(di);
	}

}
