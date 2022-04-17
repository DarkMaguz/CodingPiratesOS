/*
 * WebWorker.cpp
 *
 *  Created on: Mar 13, 2022
 *      Author: magnus
 */

#include "WebWorker.h"
#include "AssistantSourcePage.h"

//#include <curlpp/cURLpp.hpp>
#include <curlpp/Easy.hpp>
#include <curlpp/Options.hpp>

#include <tinyxml2.h>

#include <string>
#include <sstream>
#include <iostream>
#include <exception>

WebWorker::WebWorker(AssistantSourcePage *sourcePage) :
	sourcePage(sourcePage)
{
}

WebWorker::~WebWorker()
{
	std::cout << "~WebWorker" << std::endl;
//	if (doc2)
//		delete doc2;
}

void WebWorker::Worker(void)
{
	std::string url = "https://darkmagus.dk/cpos/images/content.xml";
	std::stringstream ss;
	try
	{
		// That's all that is needed to do cleanup of used resources (RAII style).
		//curlpp::Cleanup curlCleanup;
		curlpp::Easy request;

		request.setOpt<curlpp::options::Url>(url);
		//myRequest.setOpt<curlpp::options::Timeout>(3);
		request.setOpt<curlpp::options::Verbose>(false);
		request.setOpt<curlpp::options::WriteStream>(&ss);

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

//	auto target = ss.str().find_first_of('\n');
//	std::cout << "###################" << std::endl;
//	std::cout << ss.str().substr(target+1) << std::endl;
//	std::cout << "###################" << std::endl;

//	std::cout << ss.str() << std::endl;

	std::map<std::string, std::vector<FileInfo>> images;

	tinyxml2::XMLDocument doc;
	//tinyxml2::XMLError xmlError = doc.LoadFile("content.xml");
	tinyxml2::XMLError xmlError = doc.Parse(ss.str().c_str());
	if (xmlError)
	{
		std::cout << "xmlError: " << xmlError << std::endl;
		//exit(xmlError);
	}
	else
	{
		auto rootElement = doc.RootElement();
		auto distElement = rootElement->FirstChildElement("directory");
		if (distElement == nullptr)
			std::cerr << "tinyxml: " << std::endl;

		while (distElement)
		{
			std::string distName = distElement->Attribute("name");
			auto fileElement = distElement->FirstChildElement("file");
			while (fileElement)
			{
				FileInfo fileInfo;
				std::string fileName = fileElement->Attribute("name");
				auto fileExtPos = fileName.rfind('.');
				auto fileExt = fileName.substr(fileExtPos + 1);

				auto versionPos = fileName.rfind('-') + 1;
				auto versionEndPos = fileName.find('.', versionPos);
				versionEndPos = fileName.find('.', versionEndPos + 1);
				versionEndPos = fileName.find('.', versionEndPos + 1);

				fileInfo.isIso = (fileExt == "iso");
				fileInfo.version = fileName.substr(versionPos, versionEndPos - versionPos);

				fileInfo.fileName = fileName;
				fileInfo.distrubution = distName;
				fileInfo.url = fileInfo.distrubution + "/" + fileName;
				if (fileElement->Attribute("size"))
					fileInfo.size = std::atoll(fileElement->Attribute("size"));
				else
					fileInfo.size = 0;

				if (fileInfo.isIso)
				{
					fileInfo.buildLog = fileName.substr(0, versionEndPos) + ".build.log";
					images[distName].push_back(fileInfo);
				}

				fileElement = fileElement->NextSiblingElement("file");
			}

			distElement = distElement->NextSiblingElement("directory");
		}
	}

	sourcePage->setImages(images);
	//sourcePage->notify();
}

std::string WebWorker::CleanUpHTML(const std::string& html)
{
	// Source: https://www.html-tidy.org/developer/
	std::string cleanHTML;
//  const char* input = html.c_str();
//  TidyBuffer output = {0};
//  TidyBuffer errbuf = {0};
//  int rc = -1;
//  Bool ok;
//
//  TidyDoc tdoc = tidyCreate();                     // Initialize "document"
//
//  ok = tidyOptSetBool( tdoc, TidyXhtmlOut, yes );  // Convert to XHTML
//  if ( ok )
//    rc = tidySetErrorBuffer( tdoc, &errbuf );      // Capture diagnostics
//  if ( rc >= 0 )
//    rc = tidyParseString( tdoc, input );           // Parse the input
//  if ( rc >= 0 )
//    rc = tidyCleanAndRepair( tdoc );               // Tidy it up!
//  if ( rc >= 0 )
//    rc = tidyRunDiagnostics( tdoc );               // Kvetch
//  if ( rc > 1 )                                    // If error, force output.
//    rc = ( tidyOptSetBool(tdoc, TidyForceOutput, yes) ? rc : -1 );
//  if ( rc >= 0 )
//    rc = tidySaveBuffer( tdoc, &output );          // Pretty Print
//
//
//  if ( rc >= 0 )
//    cleanHTML = (const char *)output.bp;
//  else
//  	std::cout << "A severe error (" << rc << ") occurred while cleaning up HTML." << std::endl;
//
//  tidyBufFree( &output );
//  tidyBufFree( &errbuf );
//  tidyRelease( tdoc );

	return cleanHTML;
}
