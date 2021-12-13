/*
 * DriveInfo.h
 *
 *  Created on: Dec 13, 2021
 *      Author: magnus
 */

#ifndef SRC_DRIVEINFO_H_
#define SRC_DRIVEINFO_H_

#include <string>

#include <glibmm.h>
#include <giomm.h>

class DriveInfo
{
	public:
		DriveInfo(Glib::RefPtr<Gio::Drive>& drive);
		virtual ~DriveInfo();

		std::string name;
		Glib::RefPtr<Gio::Icon> icon;

		uint64_t size;
		bool isRemovable;
		bool hasVolumes;

		std::string vendor;
		std::string model;
		std::string id;
		std::string revision;
		std::string serial;
		std::string uuid;

	private:
		void PropeDrive(void);
		Glib::RefPtr<Gio::Drive> m_drive;
		std::string m_devicePath;

};

#endif /* SRC_DRIVEINFO_H_ */
