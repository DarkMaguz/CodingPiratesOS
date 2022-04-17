/*
 * AssistantConfirmPage.h
 *
 *  Created on: Mar 20, 2022
 *      Author: magnus
 */

#ifndef SRC_ASSISTANTCONFIRMPAGE_H_
#define SRC_ASSISTANTCONFIRMPAGE_H_

#include "AssistantPage.h"
#include <gtkmm.h>

class AssistantConfirmPage: public AssistantPage
{
	public:
		AssistantConfirmPage();
		virtual ~AssistantConfirmPage();

	private:
		void onConfirmSwitchStateChange(void);
		Gtk::Switch *m_confirmSwitch;
};

#endif /* SRC_ASSISTANTCONFIRMPAGE_H_ */
