/*
 * DriveTreeView.h
 *
 *  Created on: Dec 9, 2021
 *      Author: magnus
 */

#ifndef SRC_DRIVETREEVIEW_H_
#define SRC_DRIVETREEVIEW_H_

#include "DriveTool.h"

#include <gtkmm.h>

class DriveTreeView: public Gtk::TreeView
{
	public:
		DriveTreeView(DriveTool* driveTool);
		virtual ~DriveTreeView();

		uint64_t getSelectedDrive(void);

	protected:
		//Tree model columns:
		class ModelColumns: public Gtk::TreeModel::ColumnRecord
		{
			public:

				ModelColumns()
				{
					add(m_col_icon);
					add(m_col_name);
				}
				Gtk::TreeModelColumn<Glib::RefPtr<Gdk::Pixbuf>> m_col_icon;
				Gtk::TreeModelColumn<Glib::ustring> m_col_name;
		};

		ModelColumns m_Columns;
		Glib::RefPtr<Gtk::ListStore> m_refTreeModel;

		void onDrivesUpdated(void);

		private:
			DriveTool* m_driveTool;
};

#endif /* SRC_DRIVETREEVIEW_H_ */
