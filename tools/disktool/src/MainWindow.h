/*
 * MainWindow.h
 *
 *  Created on: Dec 8, 2021
 *      Author: magnus
 */

#ifndef SRC_MAINWINDOW_H_
#define SRC_MAINWINDOW_H_

#include <gtkmm.h>


class MainWindow : public Gtk::Window
{
	public:
		MainWindow();
		virtual ~MainWindow();

	private:
		void buildToolbar(void);
		void onToolbarQuit(void);

		Gtk::Box m_mainBox;
		Gtk::Box m_diskBox;

		Gtk::Toolbar *m_toolbar;
		Gtk::Statusbar m_statusbar;

		Glib::RefPtr<Gtk::Builder> m_refBuilder;

};

#endif /* SRC_MAINWINDOW_H_ */
