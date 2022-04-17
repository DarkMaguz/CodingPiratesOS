/*
 * AssistantSummaryPage.cpp
 *
 *  Created on: Mar 20, 2022
 *      Author: magnus
 */

#include "AssistantSummaryPage.h"

#include <iostream>

AssistantSummaryPage::AssistantSummaryPage() :
	AssistantPage("/org/CPOS/DiskTool/ui/AssistPageSummary.glade")
{
	try
	{
		LoadWidget("vbox", m_assistantPage);
	}
	catch (const char *msg)
	{
		std::cerr << "Building assistant summary page failed: " << std::endl << "\t" << msg << std::endl;
	}
	//m_signalPageComplete.emit(true);
}

AssistantSummaryPage::~AssistantSummaryPage()
{
}

