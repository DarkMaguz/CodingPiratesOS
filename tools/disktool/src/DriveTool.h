/*
 * DiskTool.h
 *
 *  Created on: Dec 8, 2021
 *      Author: magnus
 */

#ifndef SRC_DRIVETOOL_H_
#define SRC_DRIVETOOL_H_

#include <iostream>
#include <vector>

#include <glibmm.h>
#include <giomm.h>
#include <sigc++/sigc++.h>

//enum t_changeType {
//	CHANGE,
//	CONNECT,
//	DISCONNECT,
//	ADD,
//	REMOVE,
//	PRE_UNMOUNT,
//	UNKNOWN
//};

struct DriveInfo
{
		std::string name;
		std::string icon;
		bool hasVolumes;
		bool isRemovable;
};

typedef std::vector<Glib::RefPtr<Gio::Drive>> t_drivesList;

class DriveTool
{
	public:
		DriveTool();
		virtual ~DriveTool();

		sigc::signal<void> signalDrivesUpdated(void);

		t_drivesList& getDrives(void);

	protected:
		void onDeviceEvent(const Glib::RefPtr<Glib::Interface>& device);

//		void onDriveChanged(const Glib::RefPtr<Gio::Drive>& drive, const t_changeType& changeType);
//		void onMountChanged(const Glib::RefPtr<Gio::Mount>& mount, const t_changeType& changeType);
//		void onVolumeChanged(const Glib::RefPtr<Gio::Volume>& volume, const t_changeType& changeType);

	private:
		void updateDrives(void);
		sigc::signal<void> m_signalDrivesUpdated;
		GVolumeMonitor* m_gvm;

		t_drivesList m_drives;
};

#endif /* SRC_DRIVETOOL_H_ */
