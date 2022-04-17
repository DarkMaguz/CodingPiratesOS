/*
 * AssistantConfigPage.cpp
 *
 *  Created on: Mar 16, 2022
 *      Author: magnus
 */

#include "AssistantConfigPage.h"

#include <iostream>
#include <string>
#include <vector>

#include <giomm.h>

AssistantConfigPage::AssistantConfigPage() :
	AssistantPage("/org/CPOS/DiskTool/ui/AssistPageConfig.glade"),
	m_persistenceSwitch(nullptr),
	m_revealer(nullptr),
	m_guideButton(nullptr),
	m_etcSwitch(nullptr),
	m_homeSwitch(nullptr),
	m_customSwitch(nullptr),
	m_configTextView(nullptr),
	m_guideRevealer(nullptr),
	m_guideTextView(nullptr)
{
  try
	{
  	LoadWidget("vbox", m_assistantPage);
		LoadWidget("persistence-switch", m_persistenceSwitch);
		LoadWidget("persistence-revealer", m_revealer);
		LoadWidget("guide-button", m_guideButton);
		LoadWidget("home-switch", m_homeSwitch);
		LoadWidget("etc-switch", m_etcSwitch);
		LoadWidget("custom-switch", m_customSwitch);
		LoadWidget("config-textview", m_configTextView);
		LoadWidget("guide-revealer", m_guideRevealer);
		LoadWidget("guide-textview", m_guideTextView);

		m_refConfigTextBuffer = m_configTextView->get_buffer();

		m_persistenceSwitch->property_state().signal_changed().connect(sigc::mem_fun(*this, &AssistantConfigPage::onPersistenceSwitchStateChange));
		m_guideButton->signal_clicked().connect(sigc::mem_fun(this, &AssistantConfigPage::onGuideDiaglogButtonClick));
		m_homeSwitch->property_state().signal_changed().connect(sigc::mem_fun(*this, &AssistantConfigPage::onHomeSwitchStateChange));
		m_etcSwitch->property_state().signal_changed().connect(sigc::mem_fun(*this, &AssistantConfigPage::onEtcSwitchStateChange));
		m_customSwitch->property_state().signal_changed().connect(sigc::mem_fun(*this, &AssistantConfigPage::onCustomSwitchStateChange));
	}
	catch (const char *msg)
	{
		std::cerr << "Building assistant config page failed: " << std::endl << "\t" << msg << std::endl;
	}
}

AssistantConfigPage::~AssistantConfigPage()
{
}

void AssistantConfigPage::onPersistenceSwitchStateChange(void)
{
	m_revealer->set_reveal_child(!m_revealer->get_reveal_child());
	EvaluatePageCompleteness();
}

void AssistantConfigPage::onHomeSwitchStateChange(void)
{
	UpdateConfigText();
}

void AssistantConfigPage::onEtcSwitchStateChange(void)
{
	UpdateConfigText();
}

void AssistantConfigPage::onCustomSwitchStateChange(void)
{
	if (m_customSwitch->property_state())
	{
		m_configTextView->set_sensitive(true);
		m_homeSwitch->set_sensitive(false);
		m_etcSwitch->set_sensitive(false);
	}
	else
	{
		m_configTextView->set_sensitive(false);
		m_homeSwitch->set_sensitive(true);
		m_etcSwitch->set_sensitive(true);
	}
	UpdateConfigText();
}

void AssistantConfigPage::onGuideDiaglogButtonClick(void)
{
	m_guideRevealer->set_reveal_child(!m_guideRevealer->get_reveal_child());
}

void AssistantConfigPage::UpdateConfigText(void)
{
	if (!m_customSwitch->property_state())
	{
		m_refConfigTextBuffer->set_text("");
		if (m_homeSwitch->property_state())
			m_refConfigTextBuffer->insert(m_refConfigTextBuffer->end(), "/home\n");
		if (m_etcSwitch->property_state())
			m_refConfigTextBuffer->insert(m_refConfigTextBuffer->end(), "/etc\n");
	}
	EvaluatePageCompleteness();
}

void AssistantConfigPage::EvaluatePageCompleteness(void)
{
	bool isComplete = true;

	// TODO validate configuration

	m_signalPageComplete.emit(isComplete);
}



















