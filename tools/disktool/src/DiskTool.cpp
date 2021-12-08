/*
 * DiskTool.cpp
 *
 *  Created on: Dec 8, 2021
 *      Author: magnus
 */

#include "DiskTool.h"

#include <parted/parted.h>

DiskTool::DiskTool()
{
	ped_device_probe_all();
	PedDevice* lp_device = ped_device_get_next( NULL ) ;
	while (lp_device)
	{
		/* TO TRANSLATORS: looks like   Confirming /dev/sda */
		//set_thread_status_message( Glib::ustring::compose( _("Confirming %1"), lp_device->path ) );

		//only add this device if we can read the first sector (which means it's a real device)
		if ( useable_device( lp_device ) )
			device_paths.push_back( lp_device->path );

		lp_device = ped_device_get_next( lp_device ) ;
	}

	//std::sort( device_paths .begin(), device_paths .end() ) ;
	
}

bool DiskTool::useable_device(const PedDevice* lp_device)
{
	//g_assert( lp_device != NULL );  // Bug: Not initialised by call to ped_device_get() or ped_device_get_next()

	char * buf = static_cast<char *>( malloc( lp_device->sector_size ) );
	if ( ! buf )
		return false;

	// Must be able to read from the first sector before the disk device is considered
	// useable in GParted.
	bool success = false;
//	int fd = open(lp_device->path, O_RDONLY|O_NONBLOCK);
//	if (fd >= 0)
//	{
//		ssize_t bytes_read = read(fd, buf, lp_device->sector_size);
//		success = (bytes_read == lp_device->sector_size);
//		close(fd);
//	}

	free( buf );

	return success;
}

DiskTool::~DiskTool()
{
	// TODO Auto-generated destructor stub
}

