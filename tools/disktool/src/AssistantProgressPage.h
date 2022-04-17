/*
 * AssistantProgressPage.h
 *
 *  Created on: Mar 20, 2022
 *      Author: magnus
 */

#ifndef SRC_ASSISTANTPROGRESSPAGE_H_
#define SRC_ASSISTANTPROGRESSPAGE_H_

#include "AssistantPage.h"
#include <gtkmm.h>

class AssistantProgressPage: public AssistantPage
{
	public:
		AssistantProgressPage();
		virtual ~AssistantProgressPage();

		void UpdateProgressBar(const double& fraction);
		void UpdateStatusLabel(const Glib::ustring& text);

	private:
		Gtk::ProgressBar* m_progressBar;
		Gtk::Label* m_statusLabel;
};

#endif /* SRC_ASSISTANTPROGRESSPAGE_H_ */
