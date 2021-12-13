/*
 * DiskTool.h
 *
 *  Created on: Dec 8, 2021
 *      Author: magnus
 */

#ifndef SRC_DRIVETOOL_H_
#define SRC_DRIVETOOL_H_

#include "DriveInfo.h"

#include <iostream>
#include <vector>

#include <glibmm.h>
#include <giomm.h>
#include <sigc++/sigc++.h>

struct __DriveInfo
{
		Glib::RefPtr<Gio::Drive> drive;
		std::string name;
		Glib::RefPtr<Gio::Icon> icon;
		bool isRemovable;
		bool hasVolumes;
};

typedef std::vector<DriveInfo> t_drivesList;

class DriveTool
{
	public:
		DriveTool();
		virtual ~DriveTool();

		sigc::signal<void> signalDrivesUpdated(void);

		t_drivesList& getDrives(void);

	protected:
		void onDeviceEvent(const Glib::RefPtr<Glib::Interface>& device);

	private:
		void updateDrives(void);
		sigc::signal<void> m_signalDrivesUpdated;
		GVolumeMonitor* m_gvm;

		t_drivesList m_drives;
};

#endif /* SRC_DRIVETOOL_H_ */
