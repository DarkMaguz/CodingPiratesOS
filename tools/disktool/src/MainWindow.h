/*
 * MainWindow.h
 *
 *  Created on: Dec 8, 2021
 *      Author: magnus
 */

#ifndef SRC_MAINWINDOW_H_
#define SRC_MAINWINDOW_H_

#include "DriveTreeView.h"
#include "DriveDetailBox.h"
#include "DriveTool.h"

#include <gtkmm.h>

class MainWindow : public Gtk::Window
{
	public:
		MainWindow();
		virtual ~MainWindow();

	protected:
		void onDriveSelectChange(void);

	private:
		void buildToolbar(void);
		void onToolbarQuit(void);

		DriveTool* m_driveTool;

		Gtk::Box m_mainBox;
		DriveDetailBox m_driveDetailBox;

		Gtk::Toolbar *m_toolbar;
		Gtk::Statusbar m_statusbar;

		Gtk::Paned m_HPaned;
		DriveTreeView m_driveTreeView;
		Gtk::ScrolledWindow m_scrolledWindow;

		Glib::RefPtr<Gtk::Builder> m_refBuilder;

};

#endif /* SRC_MAINWINDOW_H_ */