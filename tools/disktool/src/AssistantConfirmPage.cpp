/*
 * AssistantConfirmPage.cpp
 *
 *  Created on: Mar 20, 2022
 *      Author: magnus
 */

#include "AssistantConfirmPage.h"

#include <iostream>

AssistantConfirmPage::AssistantConfirmPage() :
	AssistantPage("/org/CPOS/DiskTool/ui/AssistPageConfirm.glade")
{
	try
	{
		LoadWidget("vbox", m_assistantPage);
		LoadWidget("confirm-switch", m_confirmSwitch);

		m_confirmSwitch->property_state().signal_changed().connect(sigc::mem_fun(*this, &AssistantConfirmPage::onConfirmSwitchStateChange));
	}
	catch (const char *msg)
	{
		std::cerr << "Building assistant confirm page failed: " << std::endl << "\t" << msg << std::endl;
	}
}

AssistantConfirmPage::~AssistantConfirmPage()
{
}

void AssistantConfirmPage::onConfirmSwitchStateChange(void)
{
	m_signalPageComplete.emit(m_confirmSwitch->property_state());
}
