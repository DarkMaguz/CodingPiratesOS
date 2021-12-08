/*
 * MainWindow.cpp
 *
 *  Created on: Dec 8, 2021
 *      Author: magnus
 */

#include "MainWindow.h"
#include "DiskTool.h"

#include <giomm.h>

#include <string>
#include <iostream>

MainWindow::MainWindow() :
	m_mainBox(Gtk::ORIENTATION_VERTICAL),
	m_diskBox(Gtk::ORIENTATION_VERTICAL),
	m_toolbar(nullptr),
	m_refBuilder(Gtk::Builder::create())
{
	set_title("CPOS Disk Tool");
	set_default_size(800, 600);

	buildToolbar();
	m_mainBox.pack_start(*m_toolbar, Gtk::PACK_SHRINK);
	m_mainBox.pack_start(m_diskBox, Gtk::PACK_EXPAND_WIDGET);
	m_mainBox.pack_start(m_statusbar, Gtk::PACK_SHRINK);

	add(m_mainBox);
	show_all_children();
}

MainWindow::~MainWindow()
{
	if (m_toolbar)
		delete m_toolbar;
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
		// Ask user if they really would like to quit the game.
		Gtk::MessageDialog dialog(*this,
				"Are you sure about quitting the game?",
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
