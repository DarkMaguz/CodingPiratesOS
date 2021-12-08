/*
 * DiskTool.h
 *
 *  Created on: Dec 8, 2021
 *      Author: magnus
 */

#ifndef SRC_DISKTOOL_H_
#define SRC_DISKTOOL_H_


#include <vector>

#include <glibmm.h>
#include <parted/parted.h>


class DiskTool
{
	public:
		DiskTool();
		virtual ~DiskTool();

		std::vector<Glib::ustring> device_paths;
	private:

		bool useable_device(const PedDevice* lp_device);
};

#endif /* SRC_DISKTOOL_H_ */
