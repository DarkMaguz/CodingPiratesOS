/*
 * AssistantPage.cpp
 *
 *  Created on: Mar 20, 2022
 *      Author: magnus
 */

#include "AssistantPage.h"

#include <iostream>

AssistantPage::AssistantPage(const Glib::ustring &resourcePath) :
	m_assistantPage(nullptr),
	m_refBuilder(Gtk::Builder::create())
{
	try
	{
		m_refBuilder->add_from_resource(resourcePath);
	}
  catch(const Gio::ResourceError& ex)
  {
    std::cerr << "ResourceError: " << ex.what() << std::endl;
  }
  catch(const Glib::FileError& ex)
  {
    std::cerr << "FileError: " << ex.what() << std::endl;
  }
  catch(const Glib::MarkupError& ex)
  {
    std::cerr << "MarkupError: " << ex.what() << std::endl;
  }
  catch(const Gtk::BuilderError& ex)
  {
    std::cerr << "BuilderError: " << ex.what() << std::endl;
  }
}

AssistantPage::~AssistantPage()
{
	for (auto garbage : m_gc)
		if (garbage)
			delete garbage;
}

Gtk::Box *AssistantPage::GetPage(void)
{
	return m_assistantPage;
}

AssistantPage::type_signalPageComplete AssistantPage::SignalPageComplete(void)
{
	return m_signalPageComplete;
}

void AssistantPage::EvaluatePageCompleteness(void)
{
	m_signalPageComplete.emit(true);
}
