/*
 * AssistantSourcePage.h
 *
 *  Created on: Mar 9, 2022
 *      Author: magnus
 */

#ifndef SRC_ASSISTANTSOURCEPAGE_H_
#define SRC_ASSISTANTSOURCEPAGE_H_

#include "AssistantPage.h"
#include "WebWorker.h"

#include <gtkmm.h>
#include <glibmm.h>

#include <vector>
#include <thread>

enum SOURCE_TYPE {
	ONLINE,
	OFFLINE
};

enum PATH_STATE {
	VALID,
	INCOMPLEET,
	SPACE,
	PERMISION
};

class AssistantSourcePage : public AssistantPage
{
		friend class WebWorker;
	public:
		AssistantSourcePage();
		virtual ~AssistantSourcePage();

		void notify(void);

		int GetActiveStack(void) const;
		bool isOnline(void) const;
		const std::string GetFileURI(void) const;
		const std::string GetSavePath(void) const;

	protected:
		void setImages(std::map<std::string, std::vector<FileInfo>>& images);

	private:
		const FileInfo CurrentImage(void) const;
		int SavePathState(void) const;

		void loadOnlineImages(void);
		void UpdateDistroComboBox(void);

	  void onSourcePageChange(void);
	  void onOnlineSourcesReady(void);

	  void onDistroComboBoxChange(void);
	  void onFileComboBoxChange(void);

	  void onOnlineFileSet(void);
	  void onOfflineFileSet(void);

	  void EvaluatePageCompleteness(void);

		Gtk::Stack *m_stack;
		Gtk::StackSwitcher *m_stackSwitcher;

		Gtk::Spinner *m_onlineSpinner;

		Gtk::ComboBoxText *m_distroComboBox;
		Gtk::ComboBoxText *m_fileComboBox;
		Gtk::Button *m_saveOnlineFileButton;
		Glib::RefPtr<Gtk::FileChooserNative> m_onlineFileChooser;
		Gtk::MessageDialog *m_saveErrorDialog;

		Gtk::FileChooserButton *m_offlineFileChooserButton;

	  Glib::Dispatcher m_onlineSourceDispatcher;
	  std::thread* m_workerThread;
	  WebWorker m_webWorker;
	  std::map<std::string, std::vector<FileInfo>> images;
	  std::mutex imagesMutex;

};

#endif /* SRC_ASSISTANTSOURCEPAGE_H_ */
