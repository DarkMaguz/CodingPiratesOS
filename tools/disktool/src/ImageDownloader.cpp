/*
 * ImageDownloader.cpp
 *
 *  Created on: Mar 21, 2022
 *      Author: magnus
 */

#include "ImageDownloader.h"

#include <curlpp/cURLpp.hpp>
#include <curlpp/Easy.hpp>
#include <curlpp/Options.hpp>

#include <stdio.h>

#include <fstream>
#include <random>
#include <sstream>
#include <algorithm>

void iDownloader(const std::string& url, const std::string& path, ProgressFunctionFunctor progressFunction)
{
	std::fstream fs;
	fs.open(path, std::ios::out | std::ios::binary);

	try
	{
		curlpp::Cleanup curlCleanup;
		curlpp::Easy request;

		typedef curlpp::OptionTrait<int, CURLOPT_MAX_RECV_SPEED_LARGE> MaxRecvSpeed;

		request.setOpt<curlpp::options::Url>(url);
		//myRequest.setOpt<curlpp::options::Timeout>(3);
		//request.setOpt<curlpp::options::Verbose>(false);
		request.setOpt<MaxRecvSpeed>(500000);
		request.setOpt<curlpp::options::NoProgress>(false);
		request.setOpt<curlpp::options::WriteStream>(&fs);
		request.setOpt<curlpp::options::ProgressFunction>(progressFunction);

		request.perform();
	}
	catch (curlpp::RuntimeError &e)
	{
		std::cout << e.what() << std::endl;
	}
	catch (curlpp::LogicError &e)
	{
		std::cout << e.what() << std::endl;
	}
}

ImageDownloader::ImageDownloader()
{
}

bool fileExist(const std::string& path)
{
	std::ifstream ifs;
	ifs.open(path, std::ios::binary);
	return ifs.is_open();
}

ImageDownloader::~ImageDownloader()
{
	for (auto file : tmpFiles)
		if (fileExist(file))
			remove(file.c_str());
}

//double ImageDownloader::Progress(void) const
//{
//	return progress;
//}

void ImageDownloader::Download(const std::string& url, ProgressFunctionFunctor progressFunction)
{
	auto fileName = url.substr(url.rfind('/') + 1);
	auto tmpFile = GetTmpFile(fileName);

	std::fstream fs;
	fs.open(tmpFile, std::ios::out | std::ios::binary);

//	auto progressFunction = [this](double a, double b, double c, double d)
//	{
//
//		return 0;
//	};

	try
	{
		curlpp::Cleanup curlCleanup;
		curlpp::Easy request;

		typedef curlpp::OptionTrait<int, CURLOPT_MAX_RECV_SPEED_LARGE> MaxRecvSpeed;

		request.setOpt<curlpp::options::Url>(url);
		//myRequest.setOpt<curlpp::options::Timeout>(3);
		//request.setOpt<curlpp::options::Verbose>(false);
		//request.setOpt<MaxRecvSpeed>(500000);
		request.setOpt<curlpp::options::NoProgress>(false);
		request.setOpt<curlpp::options::WriteStream>(&fs);
		request.setOpt<curlpp::options::ProgressFunction>(progressFunction);

		request.perform();
	}
	catch (curlpp::RuntimeError &e)
	{
		std::cout << e.what() << std::endl;
	}
	catch (curlpp::LogicError &e)
	{
		std::cout << e.what() << std::endl;
	}
}

std::string ImageDownloader::GetTmpFile(const std::string& file)
{
	std::string path;
	std::string tmpDir = "/tmp/";//Glib::get_tmp_dir() + "/";

	path = tmpDir + file;

	while (fileExist(path))
	{
		auto now = std::chrono::system_clock::now().time_since_epoch().count();
		std::stringstream ss;
		ss << std::hex << now;
		std::string rndSring = ss.str();
		std::reverse_copy(rndSring.begin(), rndSring.end(), rndSring.begin());
		rndSring.resize(5);

		path = tmpDir + rndSring + "_" + file;
	}

	return path;
}
