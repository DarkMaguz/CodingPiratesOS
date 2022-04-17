/*
 * DriveDetailBox.h
 *
 *  Created on: Dec 10, 2021
 *      Author: magnus
 */

#ifndef SRC_DRIVEDETAILBOX_H_
#define SRC_DRIVEDETAILBOX_H_

#include "DriveTool.h"
#include "DriveAssistant.h"

#include <gtkmm.h>

class DriveDetailBox: public Gtk::Box
{
	public:
		DriveDetailBox(DriveInfo& drive);
		virtual ~DriveDetailBox();

		void setDrive(DriveInfo& drive);

	private:
		void onDriveApply(void);

		void updateLable(const Glib::ustring &id, const Glib::ustring &value);
		DriveInfo m_drive;

		Gtk::Box *m_driveDetailBox;

		Glib::RefPtr<Gtk::Builder> m_refBuilder;

		DriveAssistant *m_driveAssistant;
};

#endif /* SRC_DRIVEDETAILBOX_H_ */
