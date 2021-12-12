/*
 * DriveDetailBox.h
 *
 *  Created on: Dec 10, 2021
 *      Author: magnus
 */

#ifndef SRC_DRIVEDETAILBOX_H_
#define SRC_DRIVEDETAILBOX_H_

#include <gtkmm.h>
#include <giomm.h>

class DriveDetailBox: public Gtk::Box
{
	public:
		DriveDetailBox(Glib::RefPtr<Gio::Drive>& drive);
		DriveDetailBox();
		virtual ~DriveDetailBox();

		void setDrive(Glib::RefPtr<Gio::Drive>& drive);

	private:
		Glib::RefPtr<Gio::Drive> m_drive;
};

#endif /* SRC_DRIVEDETAILBOX_H_ */
