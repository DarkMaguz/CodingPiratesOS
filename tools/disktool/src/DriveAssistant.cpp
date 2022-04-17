/*
 * DriveAssistant.cpp
 *
 *  Created on: Mar 8, 2022
 *      Author: magnus
 */

#include "DriveAssistant.h"

#include <iostream>

DriveAssistant::DriveAssistant(DriveInfo& drive) :
	m_drive(drive)
{
	append_page(*m_pageSource.GetPage());
	append_page(*m_pageConfiguration.GetPage());
	append_page(*m_pageConfirm.GetPage());
	append_page(*m_pageProgress.GetPage());
	append_page(*m_pageSummary.GetPage());

	set_page_type(*m_pageSource.GetPage(), Gtk::ASSISTANT_PAGE_INTRO);
	set_page_type(*m_pageConfiguration.GetPage(), Gtk::ASSISTANT_PAGE_CONTENT);
	set_page_type(*m_pageConfirm.GetPage(), Gtk::ASSISTANT_PAGE_CONFIRM);
	set_page_type(*m_pageProgress.GetPage(), Gtk::ASSISTANT_PAGE_PROGRESS);
	set_page_type(*m_pageSummary.GetPage(), Gtk::ASSISTANT_PAGE_SUMMARY);

  signal_apply().connect(sigc::mem_fun(*this, &DriveAssistant::onAssistantApply));
  signal_cancel().connect(sigc::mem_fun(*this, &DriveAssistant::onAssistantCancel));
  signal_close().connect(sigc::mem_fun(*this, &DriveAssistant::onAssistantClose));
  signal_prepare().connect(sigc::mem_fun(*this, &DriveAssistant::onAssistantPrepare));

  m_pageSource.SignalPageComplete().connect(sigc::mem_fun(*this, &DriveAssistant::onSourcePageComplete));
  m_pageConfiguration.SignalPageComplete().connect(sigc::mem_fun(*this, &DriveAssistant::onConfigPageComplete));
  m_pageConfirm.SignalPageComplete().connect(sigc::mem_fun(*this, &DriveAssistant::onConfirmPageComplete));
//  m_pageSummary.SignalPageComplete().connect(sigc::mem_fun(*this, &DriveAssistant::onSummaryPageComplete));

  onConfigPageComplete(true);
  onProgressPageComplete(true);
  //onSummaryPageComplete(true);


	show_all_children();
}

DriveAssistant::~DriveAssistant()
{
}

void DriveAssistant::onAssistantApply(void)
{
	std::cout << "onAssistantApply()" << std::endl;
	std::cout << "m_pageSource->GetActiveStack()" << m_pageSource.GetActiveStack() << std::endl;
	switch (m_pageSource.GetActiveStack())
	{
		case SOURCE_TYPE::ONLINE:

			break;
		case SOURCE_TYPE::OFFLINE:

			break;
		default:
			break;
	}
}

void DriveAssistant::onAssistantCancel(void)
{
	std::cout << "onAssistantCancel()" << std::endl;
	hide();
}

void DriveAssistant::onAssistantClose(void)
{
	std::cout << "onAssistantClose()" << std::endl;
	hide();
}

void DriveAssistant::onAssistantPrepare(Gtk::Widget* widget)
{
	std::cout << "onAssistantPrepare()" << std::endl;
}

void DriveAssistant::onSourcePageComplete(bool isComplete)
{
	set_page_complete(*m_pageSource.GetPage(), isComplete);
}

void DriveAssistant::onConfigPageComplete(bool isComplete)
{
	set_page_complete(*m_pageConfiguration.GetPage(), isComplete);
}

void DriveAssistant::onConfirmPageComplete(bool isComplete)
{
	set_page_complete(*m_pageConfirm.GetPage(), isComplete);
}

void DriveAssistant::onProgressPageComplete(bool isComplete)
{
	set_page_complete(*m_pageProgress.GetPage(), isComplete);
}

void DriveAssistant::onSummaryPageComplete(bool isComplete)
{
	set_page_complete(*m_pageSummary.GetPage(), isComplete);
}
