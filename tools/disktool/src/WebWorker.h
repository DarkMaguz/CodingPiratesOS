/*
 * WebWorker.h
 *
 *  Created on: Mar 13, 2022
 *      Author: magnus
 */

#ifndef SRC_WEBWORKER_H_
#define SRC_WEBWORKER_H_

#include <vector>
#include <string>
#include <map>

struct FileInfo
{
	bool isIso;
	std::string fileName;
	std::string url;
	std::string version;
	std::string distrubution;
	std::string buildLog;
	uint64_t size;
};

struct WorkerResult
{
	std::map<std::string, std::vector<std::string>> images;
	std::vector<std::string> distributions;
};

class AssistantSourcePage;

class WebWorker
{
	public:
		WebWorker(AssistantSourcePage *sourcePage);
		virtual ~WebWorker();

		void Worker(void);

	private:
		std::string CleanUpHTML(const std::string& html);
		AssistantSourcePage *sourcePage;

		//std::vector<xmlpp::Document *> gc;
//		xmlpp::Document *doc2;
};

#endif /* SRC_WEBWORKER_H_ */
