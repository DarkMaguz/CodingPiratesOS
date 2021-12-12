/*
 * MainWindow.cpp
 *
 *  Created on: Dec 8, 2021
 *      Author: magnus
 */

#include "DriveTool.h"
#include "MainWindow.h"

#include <string>
#include <iostream>

#include <gtkmm.h>

MainWindow::MainWindow() :
	m_driveTool(new DriveTool),
	m_mainBox(Gtk::ORIENTATION_VERTICAL),
	m_HPaned(Gtk::ORIENTATION_HORIZONTAL),
	m_driveDetailBox(),
	m_toolbar(nullptr),
	m_driveTreeView(m_driveTool),
	m_refBuilder(Gtk::Builder::create())
{
	set_title("CPOS Disk Tool");
	set_default_size(800, 600);

	buildToolbar();
	m_mainBox.pack_start(*m_toolbar, Gtk::PACK_SHRINK);
	m_mainBox.pack_start(m_HPaned, Gtk::PACK_EXPAND_WIDGET);
	m_mainBox.pack_start(m_statusbar, Gtk::PACK_SHRINK);

	m_scrolledWindow.add(m_driveTreeView);
	m_scrolledWindow.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_AUTOMATIC);

	m_HPaned.pack1(m_scrolledWindow);
	m_HPaned.pack2(m_driveDetailBox, Gtk::EXPAND);

	m_driveTreeView.get_selection()->signal_changed().connect(sigc::mem_fun(*this, &MainWindow::onDriveSelectChange));

	add(m_mainBox);
	show_all_children();
}

MainWindow::~MainWindow()
{
	if (m_toolbar)
		delete m_toolbar;
	if (m_driveTool)
		delete m_driveTool;
}

void MainWindow::onDriveSelectChange(void)
{
	auto drive = m_driveTreeView.getSelectedDrive();
	m_driveDetailBox.setDrive(m_driveTool->getDrives().at(drive));
}

void MainWindow::buildToolbar(void)
{
	auto refActionGroup = Gio::SimpleActionGroup::create();
	refActionGroup->add_action("quit", sigc::mem_fun(*this, &MainWindow::onToolbarQuit));
	insert_action_group("toolbar", refActionGroup);

  try
  {
    m_refBuilder->add_from_resource("/org/CPOS/DiskTool/ui.xml");
  }
  catch (const Glib::Error& ex)
  {
    std::cerr << "Building toolbar failed: " <<  ex.what();
  }

  m_refBuilder->get_widget("toolbar", m_toolbar);
  if (!m_toolbar)
  	std::cerr << "GtkToolbar not found!";
  else
  	m_toolbar->set_toolbar_style(Gtk::TOOLBAR_BOTH);

}

void MainWindow::onToolbarQuit(void)
{
	if (false)
	{
		// Ask user if they really would like to terminate ongoing processes.
		Gtk::MessageDialog dialog(*this,
				"Are you sure about terminating ongoing processes?",
				false,
				Gtk::MESSAGE_QUESTION,
				Gtk::BUTTONS_OK_CANCEL);
		if (dialog.run() == Gtk::RESPONSE_OK)
			hide();
	}
	else
	{
		hide();
	}
}
