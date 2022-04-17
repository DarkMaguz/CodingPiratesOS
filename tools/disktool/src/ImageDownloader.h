/*
 * ImageDownloader.h
 *
 *  Created on: Mar 21, 2022
 *      Author: magnus
 */

#ifndef SRC_IMAGEDOWNLOADER_H_
#define SRC_IMAGEDOWNLOADER_H_

#include <thread>
#include <string>
#include <vector>
#include <functional>

typedef std::function<int(double, double, double, double)> ProgressFunctionFunctor;

void iDownloader(const std::string& url, const std::string& path, ProgressFunctionFunctor progressFunction);

class ImageDownloader
{
	public:
		ImageDownloader();
		virtual ~ImageDownloader();

//		double Progress(void) const;

		void Download(const std::string& url, ProgressFunctionFunctor progressFunction);

	private:
		std::string GetTmpFile(const std::string& file);
		std::vector<std::string> tmpFiles;

//		double progress;

};

#endif /* SRC_IMAGEDOWNLOADER_H_ */
