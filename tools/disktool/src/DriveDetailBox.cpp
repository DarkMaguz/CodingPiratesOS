/*
 * DriveDetailBox.cpp
 *
 *  Created on: Dec 10, 2021
 *      Author: magnus
 */

#include "DriveDetailBox.h"

#include <iostream>

DriveDetailBox::DriveDetailBox(DriveInfo& drive) :
	Gtk::Box(Gtk::ORIENTATION_VERTICAL),
	m_drive(drive),
	m_driveDetailBox(nullptr),
	m_driveAssistant(nullptr),
	m_refBuilder(Gtk::Builder::create_from_resource("/org/CPOS/DiskTool/ui/DriveDetailBox.glade"))
{
	setDrive(drive);

	auto refActionGroup = Gio::SimpleActionGroup::create();
	refActionGroup->add_action("apply", sigc::mem_fun(*this, &DriveDetailBox::onDriveApply));
	insert_action_group("drive-detail", refActionGroup);

	m_refBuilder->get_widget("drive-detail-box", m_driveDetailBox);

	add(*m_driveDetailBox);
	show_all_children();
}

DriveDetailBox::~DriveDetailBox()
{
	if (m_driveDetailBox)
		delete m_driveDetailBox;

	if (m_driveAssistant)
		delete m_driveAssistant;
}

void DriveDetailBox::setDrive(DriveInfo& drive)
{
	m_drive = drive;
	updateLable("name", m_drive.name);
	updateLable("size", Glib::ustring::format(m_drive.size));
	updateLable("removable", m_drive.isRemovable ? "yes" : "no");
	updateLable("vendor", m_drive.vendor);
	updateLable("model", m_drive.model);
	updateLable("id", m_drive.id);
	updateLable("revision", m_drive.revision);
	updateLable("serial", m_drive.serial);
	updateLable("path", m_drive.path);
}

void DriveDetailBox::onDriveApply(void)
{
	std::cout << "onDriveApply" << std::endl;

	if (m_driveAssistant)
		delete m_driveAssistant;

	m_driveAssistant = new DriveAssistant(m_drive);
	m_driveAssistant->show();

}

void DriveDetailBox::updateLable(const Glib::ustring &id, const Glib::ustring &value)
{
	Gtk::Label *tmpLabel = nullptr;
	m_refBuilder->get_widget("drive-detail-" + id, tmpLabel);
	tmpLabel->set_text(value);
	tmpLabel->set_visible(!value.empty());
}
