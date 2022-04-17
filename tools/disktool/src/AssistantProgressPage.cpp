/*
 * AssistantProgressPage.cpp
 *
 *  Created on: Mar 20, 2022
 *      Author: magnus
 */

#include "AssistantProgressPage.h"

#include <iostream>

AssistantProgressPage::AssistantProgressPage() :
	AssistantPage("/org/CPOS/DiskTool/ui/AssistPageProgress.glade"),
	m_progressBar(nullptr),
	m_statusLabel(nullptr)
{
	try
	{
		LoadWidget("vbox", m_assistantPage);
		LoadWidget("progressbar", m_progressBar);
		LoadWidget("status-label", m_statusLabel);
	}
	catch (const char *msg)
	{
		std::cerr << "Building assistant progress page failed: " << std::endl << "\t" << msg << std::endl;
	}
}

AssistantProgressPage::~AssistantProgressPage()
{
}

void AssistantProgressPage::UpdateProgressBar(const double& fraction)
{
	m_progressBar->set_fraction(fraction);
}

void AssistantProgressPage::UpdateStatusLabel(const Glib::ustring& text)
{
	m_statusLabel->set_text(text);
}
