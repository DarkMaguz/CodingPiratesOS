/*
 * DriveTreeView.cpp
 *
 *  Created on: Dec 9, 2021
 *      Author: magnus
 */

#include "DriveTreeView.h"

#include <exception>

DriveTreeView::DriveTreeView(DriveTool* driveTool) :
	m_refTreeModel(Gtk::ListStore::create(m_Columns)),
	m_driveTool(driveTool)
{
	set_model(m_refTreeModel);
	set_headers_visible(false);

	get_selection()->set_mode(Gtk::SELECTION_SINGLE);

	append_column("Icon", m_Columns.m_col_icon);
	append_column("Name", m_Columns.m_col_name);

	onDrivesUpdated();

	m_driveTool->signalDrivesUpdated().connect(sigc::mem_fun(*this, &DriveTreeView::onDrivesUpdated));

	show_all_children();
}

DriveTreeView::~DriveTreeView()
{
}

uint64_t DriveTreeView::getSelectedDrive(void)
{
	auto it = get_selection()->get_selected();
	uint64_t counter = 0;

	for (auto i : m_refTreeModel->children())
	{
		if (it->equal(i))
			break;
		counter++;
	}

	return counter;
}

void DriveTreeView::onDrivesUpdated(void)
{
	std::cout << "onDrivesUpdated" << std::endl;
	try
	{
		auto iconTheme = Gtk::IconTheme::create();
		m_refTreeModel->clear();
		for (t_drivesList::const_iterator it = m_driveTool->getDrives().begin(); it != m_driveTool->getDrives().end(); it++)
		{
			auto drive = *it;
			Gtk::TreeModel::Row row = *(m_refTreeModel->append());

			row[m_Columns.m_col_icon] = iconTheme->lookup_icon(drive.icon, 32).load_icon();
			row[m_Columns.m_col_name] = drive.name;
		}
	}
	catch (std::exception& e)
	{
		std::cout << "onDrivesUpdated failed: " << e.what() << std::endl;
	}
}
