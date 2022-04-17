/*
 * DriveAssistant.h
 *
 *  Created on: Mar 8, 2022
 *      Author: magnus
 */

#ifndef SRC_DRIVEASSISTANT_H_
#define SRC_DRIVEASSISTANT_H_

#include "DriveInfo.h"
#include "AssistantSourcePage.h"
#include "AssistantConfigPage.h"
#include "AssistantConfirmPage.h"
#include "AssistantProgressPage.h"
#include "AssistantSummaryPage.h"

#include <gtkmm.h>

class DriveAssistant: public Gtk::Assistant
{
	public:
		DriveAssistant(DriveInfo& drive);
		virtual ~DriveAssistant();

	private:
	  void onAssistantApply(void);
	  void onAssistantCancel(void);
	  void onAssistantClose(void);
	  void onAssistantPrepare(Gtk::Widget* widget);

	  void onSourcePageComplete(bool isComplete);
	  void onConfigPageComplete(bool isComplete);
	  void onConfirmPageComplete(bool isComplete);
	  void onProgressPageComplete(bool isComplete);
	  void onSummaryPageComplete(bool isComplete);

		AssistantSourcePage m_pageSource;
		AssistantConfigPage m_pageConfiguration;
		AssistantConfirmPage m_pageConfirm;
		AssistantProgressPage m_pageProgress;
		AssistantSummaryPage m_pageSummary;

		DriveInfo m_drive;
};

#endif /* SRC_DRIVEASSISTANT_H_ */
