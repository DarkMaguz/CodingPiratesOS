/*
 * AssistantConfigPage.h
 *
 *  Created on: Mar 16, 2022
 *      Author: magnus
 */

#ifndef SRC_ASSISTANTCONFIGPAGE_H_
#define SRC_ASSISTANTCONFIGPAGE_H_

#include "AssistantPage.h"
#include <gtkmm.h>

#include <vector>

class AssistantConfigPage : public AssistantPage
{
	public:
		AssistantConfigPage();
		virtual ~AssistantConfigPage();

	private:
		void onPersistenceSwitchStateChange(void);

		void onHomeSwitchStateChange(void);
		void onEtcSwitchStateChange(void);
		void onCustomSwitchStateChange(void);

		void onGuideDiaglogButtonClick(void);

		void UpdateConfigText(void);

		void EvaluatePageCompleteness(void);

		Gtk::Switch *m_persistenceSwitch;
		Gtk::Revealer *m_revealer;

		Gtk::Button *m_guideButton;
		Gtk::Switch *m_homeSwitch;
		Gtk::Switch *m_etcSwitch;
		Gtk::Switch *m_customSwitch;
		Gtk::TextView *m_configTextView;
		Glib::RefPtr<Gtk::TextBuffer> m_refConfigTextBuffer;

		Gtk::Revealer *m_guideRevealer;
		Gtk::TextView *m_guideTextView;
};

#endif /* SRC_ASSISTANTCONFIGPAGE_H_ */
