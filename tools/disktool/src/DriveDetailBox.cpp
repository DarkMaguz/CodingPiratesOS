/*
 * DriveDetailBox.cpp
 *
 *  Created on: Dec 10, 2021
 *      Author: magnus
 */

#include "DriveDetailBox.h"

#include <iostream>

#include <parted/parted.h>
#include <udisks/udisks.h>
#include <gobject/gobject.h>
#include <giomm.h>

//#include <stdio.h>
//#include <stdlib.h>
#include <errno.h>
//#include <fcntl.h>
//#include <sys/ioctl.h>
//#include <linux/hdreg.h>

//#include <sys/statvfs.h>

DriveDetailBox::DriveDetailBox(Glib::RefPtr<Gio::Drive>& drive) :
	Gtk::Box(Gtk::ORIENTATION_VERTICAL),
	m_drive(drive)
{
	setDrive(drive);
}

DriveDetailBox::DriveDetailBox() :
	Gtk::Box(Gtk::ORIENTATION_VERTICAL),
	m_drive(nullptr)
{
	this->get_children();

}

DriveDetailBox::~DriveDetailBox()
{
}

UDisksObject *object_from_block_device(UDisksClient *client, const gchar *block_device)
{
	gchar **error_message;
	struct stat statbuf;
	const gchar *crypto_backing_device;
	UDisksObject *object, *crypto_backing_object;
	UDisksBlock *block;

	object = NULL;

	if (stat(block_device, &statbuf) != 0)
	{
		*error_message = g_strdup_printf(("Error opening %s: %s"), block_device, g_strerror(errno));
		return object;
	}

	block = udisks_client_get_block_for_dev(client, statbuf.st_rdev);
	if (block == NULL)
	{
		*error_message = g_strdup_printf(("Error looking up block device for %s"), block_device);
		return object;
	}

	object = UDISKS_OBJECT(g_dbus_interface_dup_object (G_DBUS_INTERFACE (block)));
	g_object_unref(block);

	crypto_backing_device = udisks_block_get_crypto_backing_device((udisks_object_peek_block(object)));
	crypto_backing_object = udisks_client_get_object(client, crypto_backing_device);
	if (crypto_backing_object != NULL)
	{
		g_object_unref(object);
		object = crypto_backing_object;
	}
	return object;
}

void prope(const char *devname)
{

	std::cout << "Analyzing device: " << devname << std::endl;

//	PedDevice* dev = ped_device_get(devname);
//
//	std::cout << "model: " << dev->model << std::endl;
//
//	ped_device_free_all();

//
//	struct statvfs fsinfo;
//	statvfs("/", &fsinfo);
//
//	uint64_t hdd_size = fsinfo.f_frsize * fsinfo.f_blocks;
//	uint64_t hdd_free = fsinfo.f_bsize * fsinfo.f_bfree;




	GError *error = nullptr;
	UDisksClient *client = udisks_client_new_sync(NULL, &error);
	if (!client)
	{
		g_error("Error getting udisks client: %s", error->message);
		g_error_free(error);
		return;
	}
	udisks_client_settle(client);
	UDisksObject *object = object_from_block_device(client, devname);
	//udisks_client_peek_object(client, "/dev/sdc3");
	if (!UDISKS_IS_OBJECT(object))
	{
		std::cerr << "Error object is not an udsisk object." << std::endl;
	}
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
//  Gio::DBus::ObjectManager dBusOM;
  UDisksDrive *drive = NULL;
  UDisksObject *drive_object = (UDisksObject *)g_dbus_object_manager_get_object(udisks_client_get_object_manager(client),
                                                                        udisks_block_get_drive(block));
	if (drive_object != NULL)
	{
		drive = udisks_object_peek_drive(drive_object);
		g_object_unref(drive_object);
	}

	UDisksObjectInfo *info = udisks_client_get_object_info(client, object);
  const gchar *drive_vendor = udisks_drive_get_vendor(drive);
  const gchar *drive_model = udisks_drive_get_model(drive);
  const gchar *drive_id = udisks_drive_get_id(drive);
  const gchar *drive_revision = udisks_drive_get_revision(drive);
  uint64_t size = udisks_drive_get_size(drive);
  const gchar *serial = udisks_drive_get_serial (drive);
  bool removable = udisks_drive_get_media_removable(drive);
  gchar *uuid = udisks_block_dup_id_uuid(block);

  std::cout << "\tdrive_vendor: " << drive_vendor << std::endl;
  std::cout << "\tdrive_model: " << drive_model << std::endl;
  std::cout << "\tdrive_id: " << drive_id << std::endl;
  std::cout << "\tdrive_revision: " << drive_revision << std::endl;
  std::cout << "\tsize: " << size << std::endl;
  std::cout << "\tserial: " << serial << std::endl;
  std::cout << "\tremovable: " << removable << std::endl;

  g_free(uuid);
  g_clear_object(&info);
  g_object_unref(object);
  g_object_unref(client);
  g_object_unref(drive_object);





//  static struct hd_driveid hd;
//  int fd;
//
//  /*if (geteuid() >  0) {
//      printf("ERROR: Must be root to use\n");
//      exit(1);
//  }*/
//
//  if ((fd = open(devname, O_RDONLY|O_NONBLOCK)) < 0) {
//      printf("ERROR: Cannot open device %s\n", devname);
//      //exit(1);
//      return;
//  }
//
//  if (!ioctl(fd, HDIO_GET_IDENTITY, &hd)) {
//      printf("Hard Disk Model: %.40s\n", hd.model);
//      printf("  Serial Number: %.20s\n", hd.serial_no);
//  } else if (errno == -ENOMSG) {
//      printf("No hard disk identification information available\n");
//  } else {
//      perror("ERROR: HDIO_GET_IDENTITY");
//      return;
//  }
}

void DriveDetailBox::setDrive(Glib::RefPtr<Gio::Drive>& drive)
{
	if (!drive)
		return;
	m_drive = drive;
	std::cout << "setDrive: " << m_drive->get_name() << std::endl;
	for (auto id : drive->enumerate_identifiers())
	{
		std::cout << "id: " << id << std::endl;
		std::cout << "\tvalue: " << drive->get_identifier(id) << std::endl;
		prope(drive->get_identifier(id).c_str());
	}
}
