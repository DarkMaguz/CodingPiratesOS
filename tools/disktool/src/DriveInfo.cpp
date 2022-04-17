/*
 * DriveInfo.cpp
 *
 *  Created on: Dec 13, 2021
 *      Author: magnus
 */

#include "DriveInfo.h"

#include <iostream>
#include <algorithm>
#include <cctype>

#include <udisks/udisks.h>
#include <gobject/gobject.h>
#include <giomm.h>

#include <sys/stat.h>
#include <errno.h>

DriveInfo::DriveInfo(Glib::RefPtr<Gio::Drive>& drive) :
	m_drive(drive)
{
	name = drive->get_name();
	icon = drive->get_icon();
	isRemovable = drive->is_removable();
	hasVolumes = drive->has_volumes();
	PropeDrive();
}

DriveInfo::~DriveInfo()
{
}

UDisksObject *object_from_block_device(UDisksClient *client, std::string& block_device)
{
	gchar **error_message;
	struct stat statbuf;
	const gchar *crypto_backing_device;
	UDisksObject *object, *crypto_backing_object;
	UDisksBlock *block;

	object = nullptr;

	if (stat(block_device.c_str(), &statbuf) != 0)
	{
		*error_message = g_strdup_printf(("Error opening %s: %s"), block_device.c_str(), g_strerror(errno));
		return object;
	}

	block = udisks_client_get_block_for_dev(client, statbuf.st_rdev);
	if (block == nullptr)
	{
		*error_message = g_strdup_printf(("Error looking up block device for %s"), block_device.c_str());
		return object;
	}

	object = UDISKS_OBJECT(g_dbus_interface_dup_object (G_DBUS_INTERFACE (block)));
	g_object_unref(block);

	crypto_backing_device = udisks_block_get_crypto_backing_device((udisks_object_peek_block(object)));
	crypto_backing_object = udisks_client_get_object(client, crypto_backing_device);
	if (crypto_backing_object != nullptr)
	{
		g_object_unref(object);
		object = crypto_backing_object;
	}
	return object;
}

void DriveInfo::PropeDrive(void)
{

	for (auto id : m_drive->enumerate_identifiers())
		m_devicePath = m_drive->get_identifier(id);

	if (m_devicePath.empty())
		return;

	path = m_devicePath;
	std::cout << "Analyzing device: '" << m_devicePath << "'" << std::endl;

	GError *error = nullptr;
	UDisksClient *client = udisks_client_new_sync(nullptr, &error);
	if (!client)
	{
		g_error("Error getting udisks client: %s", error->message);
		g_error_free(error);
		return;
	}

	UDisksObject *object = object_from_block_device(client, m_devicePath);
	if (!object)
	{
		std::cerr << "Error getting udisks object." << std::endl;
		g_object_unref(client);
		return;
	}

	UDisksBlock *block = udisks_object_peek_block(object);
	if (!block)
	{
		std::cerr << "Error getting udisks block." << std::endl;
		g_object_unref(object);
		g_object_unref(client);
		return;
	}

  UDisksDrive *drive = nullptr;
  UDisksObject *driveObject = (UDisksObject *)g_dbus_object_manager_get_object(
  		udisks_client_get_object_manager(client),
			udisks_block_get_drive(block));
	if (driveObject != nullptr)
	{
		drive = udisks_object_peek_drive(driveObject);
		g_object_unref(driveObject);
	}
	else
	{
		std::cerr << "Error getting udisks drive object." << std::endl;
		g_object_unref(object);
		g_object_unref(client);
		return;
	}

	if (drive)
	{
	  vendor = udisks_drive_get_vendor(drive);
	  model = udisks_drive_get_model(drive);
	  id = udisks_drive_get_id(drive);
	  revision = udisks_drive_get_revision(drive);
	  size = udisks_drive_get_size(drive);
	  serial = udisks_drive_get_serial (drive);
	  isRemovable = udisks_drive_get_media_removable(drive);
	  gchar *drive_uuid = udisks_block_dup_id_uuid(block);
	  uuid = drive_uuid;
	  g_free(drive_uuid);
	}

  g_object_unref(object);
  g_object_unref(client);

}
