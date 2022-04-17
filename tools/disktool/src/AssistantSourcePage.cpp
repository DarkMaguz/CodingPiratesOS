/*
 * AssistantSourcePage.cpp
 *
 *  Created on: Mar 9, 2022
 *      Author: magnus
 */

#include "AssistantSourcePage.h"

#include <curlpp/cURLpp.hpp>
#include <curlpp/Easy.hpp>
#include <curlpp/Options.hpp>

#include <string>
#include <sstream>
#include <iostream>
#include <exception>
#include <filesystem>

AssistantSourcePage::AssistantSourcePage() :
	AssistantPage("/org/CPOS/DiskTool/ui/AssistPageSource.glade"),
	m_stack(nullptr),
	m_stackSwitcher(nullptr),
	m_onlineSpinner(nullptr),
	m_distroComboBox(nullptr),
	m_fileComboBox(nullptr),
	m_saveOnlineFileButton(nullptr),
	m_onlineFileChooser(Gtk::FileChooserNative::create("save as", Gtk::FileChooserAction::FILE_CHOOSER_ACTION_SAVE, "Save", "Cancel")),
	m_saveErrorDialog(nullptr),
	m_offlineFileChooserButton(nullptr),
	m_workerThread(nullptr),
	m_webWorker(this)
{
  try
	{
		LoadWidget("vbox", m_assistantPage);
		LoadWidget("stack", m_stack);
		LoadWidget("stack-switcher", m_stackSwitcher);
		LoadWidget("spinner-online", m_onlineSpinner);
		LoadWidget("combo-box-distro", m_distroComboBox);
		LoadWidget("combo-box-file", m_fileComboBox);
		LoadWidget("save-online-file-button", m_saveOnlineFileButton);
		LoadWidget("save-error-dialog", m_saveErrorDialog);
		LoadWidget("offline-file-chooser-button", m_offlineFileChooserButton);

		m_stack->property_visible_child().signal_changed().connect(sigc::mem_fun(*this, &AssistantSourcePage::onSourcePageChange));

		m_saveOnlineFileButton->set_sensitive(false);
		m_saveOnlineFileButton->set_label("...");

		m_distroComboBox->signal_changed().connect(sigc::mem_fun(*this, &AssistantSourcePage::onDistroComboBoxChange));
		m_fileComboBox->signal_changed().connect(sigc::mem_fun(*this, &AssistantSourcePage::onFileComboBoxChange));
		m_saveOnlineFileButton->signal_clicked().connect(sigc::mem_fun(*this, &AssistantSourcePage::onOnlineFileSet));
		m_offlineFileChooserButton->signal_file_set().connect(sigc::mem_fun(*this, &AssistantSourcePage::onOfflineFileSet));
	}
	catch (const char *msg)
	{
		std::cerr << "Building assistant source page failed: " << std::endl << "\t" << msg << std::endl;
	}

	m_onlineSourceDispatcher.connect(sigc::mem_fun(*this, &AssistantSourcePage::onOnlineSourcesReady));

	loadOnlineImages();
}

AssistantSourcePage::~AssistantSourcePage()
{
	if (m_workerThread)
		delete m_workerThread;
}

void AssistantSourcePage::notify(void)
{
	m_onlineSourceDispatcher.emit();
}

int AssistantSourcePage::GetActiveStack(void) const
{
	const auto activePage = m_stack->get_visible_child();
	const auto activeChild = m_stack->child_property_position(*activePage);
	return activeChild;
}

bool AssistantSourcePage::isOnline(void) const
{
	return GetActiveStack() == SOURCE_TYPE::ONLINE;
}

const std::string AssistantSourcePage::GetFileURI(void) const
{
	std::string uri;

	switch (GetActiveStack())
	{
		case SOURCE_TYPE::ONLINE:
		{
			uri = CurrentImage().url;
			break;
		}
		case SOURCE_TYPE::OFFLINE:
		{
			uri = m_offlineFileChooserButton->get_uri();
			break;
		}
		default:
			break;
	}

	return uri;
}

const std::string AssistantSourcePage::GetSavePath(void) const
{
	return m_onlineFileChooser->get_uri();
}

void AssistantSourcePage::setImages(std::map<std::string, std::vector<FileInfo>>& imgs)
{
	imagesMutex.lock();
	images = imgs;
	imagesMutex.unlock();
	m_onlineSourceDispatcher.emit();
}

const FileInfo AssistantSourcePage::CurrentImage(void) const
{
	auto distImages = images.at(m_distroComboBox->get_active_text());
	for (auto img : distImages)
		if (img.fileName == m_fileComboBox->get_active_text())
			return img;
	return FileInfo();
}

int AssistantSourcePage::SavePathState(void) const
{
	if (m_onlineFileChooser->get_current_folder().empty() ||
			m_onlineFileChooser->get_current_name().empty() ||
			m_onlineFileChooser->get_uri().empty())
		return PATH_STATE::INCOMPLEET;

	std::filesystem::path folderPath = m_onlineFileChooser->get_current_folder().c_str();
	auto spaceInfo = std::filesystem::space(folderPath);
	if (spaceInfo.available < CurrentImage().size)
		return PATH_STATE::SPACE;

	auto file = Gio::File::create_for_path(folderPath);
	auto fi = file->query_info();
	if (!fi->get_attribute_boolean("access::can-write"))
		return PATH_STATE::PERMISION;

	return PATH_STATE::VALID;
}

void AssistantSourcePage::loadOnlineImages(void)
{
	if (!m_workerThread)
	{
		m_onlineSpinner->start();
    // Start a new worker thread.
		m_workerThread = new std::thread(
      [this]
      {
				m_webWorker.Worker();
      });
	}
}

void AssistantSourcePage::UpdateDistroComboBox(void)
{
	m_distroComboBox->remove_all();
	m_fileComboBox->remove_all();
	int counter = 0;
	for (auto dist : images)
	{
		m_distroComboBox->append(dist.first, dist.first);
	}
	m_distroComboBox->set_active_id("master");
}

void AssistantSourcePage::onOnlineSourcesReady(void)
{
	if (m_workerThread)
	{
		m_workerThread->join();
		delete m_workerThread;
		m_workerThread = nullptr;
	}
	UpdateDistroComboBox();
	m_onlineSpinner->stop();
}

void AssistantSourcePage::onSourcePageChange(void)
{
	EvaluatePageCompleteness();
}

void AssistantSourcePage::onDistroComboBoxChange(void)
{
	std::cout << "onDistroComboBoxChange" << std::endl;
	auto selected = m_distroComboBox->get_active_text();
	if (selected.empty())
		return;
	m_fileComboBox->remove_all();
	for (auto file : images[m_distroComboBox->get_active_text()])
	{
		m_fileComboBox->append(file.fileName);
	}
	m_fileComboBox->set_active(0);
}

void AssistantSourcePage::onFileComboBoxChange(void)
{
	std::cout << "onFileComboBoxChange" << std::endl;
	auto selectedFileName = m_fileComboBox->get_active_text();
	m_saveOnlineFileButton->set_sensitive(!selectedFileName.empty());
	m_saveOnlineFileButton->set_label("...");

	EvaluatePageCompleteness();
}

void AssistantSourcePage::onOnlineFileSet(void)
{
	std::cout << "onOnlineFileSet" << std::endl;
	m_onlineFileChooser->set_current_name(m_fileComboBox->get_active_text());

	int response;
	while ((response = m_onlineFileChooser->run()) == Gtk::ResponseType::RESPONSE_ACCEPT)
	{
		auto state = SavePathState();

		if (state == VALID)
		{
			m_saveOnlineFileButton->set_label(m_onlineFileChooser->get_current_name());
			break;
		}

		if (state == INCOMPLEET)
			m_saveErrorDialog->set_secondary_text("Invalid destination has been selected");

		if (state == SPACE)
			m_saveErrorDialog->set_secondary_text("Not enough free disk space at selected destination");

		if (state == PERMISION)
			m_saveErrorDialog->set_secondary_text("You do not have required permissions at selected destination");

		m_saveErrorDialog->run();
		m_saveErrorDialog->hide();
	}

	if (response != Gtk::ResponseType::RESPONSE_ACCEPT)
	{
		m_onlineFileChooser->set_current_folder("");
		m_onlineFileChooser->set_current_name("");
		m_onlineFileChooser->set_uri("");
	}

	EvaluatePageCompleteness();
}

void AssistantSourcePage::onOfflineFileSet(void)
{
	EvaluatePageCompleteness();
}

void AssistantSourcePage::EvaluatePageCompleteness(void)
{
	bool isComplete = false;

	switch (GetActiveStack())
	{
		case SOURCE_TYPE::ONLINE:
			isComplete = !m_fileComboBox->get_active_text().empty()
				&& !m_onlineFileChooser->get_current_folder().empty()
				&& !m_onlineFileChooser->get_current_name().empty()
				&& !m_onlineFileChooser->get_uri().empty();
			break;
		case SOURCE_TYPE::OFFLINE:
			isComplete = !m_offlineFileChooserButton->get_filename().empty();
			break;
		default:
			break;
	}

	m_signalPageComplete.emit(isComplete);
}
