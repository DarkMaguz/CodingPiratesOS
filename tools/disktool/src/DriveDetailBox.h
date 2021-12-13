/*
 * DriveDetailBox.h
 *
 *  Created on: Dec 10, 2021
 *      Author: magnus
 */

#ifndef SRC_DRIVEDETAILBOX_H_
#define SRC_DRIVEDETAILBOX_H_

#include "DriveTool.h"

#include <gtkmm.h>

class DriveDetailBox: public Gtk::Box
{
	public:
		DriveDetailBox(DriveInfo& drive);
		virtual ~DriveDetailBox();

		void setDrive(DriveInfo& drive);

	private:
		DriveInfo m_drive;
};

#endif /* SRC_DRIVEDETAILBOX_H_ */
