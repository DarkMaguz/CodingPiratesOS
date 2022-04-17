/*
 * AssistantPage.h
 *
 *  Created on: Mar 20, 2022
 *      Author: magnus
 */


#include <gtkmm.h>

#include <vector>

#ifndef SRC_ASSISTANTPAGE_H_
#define SRC_ASSISTANTPAGE_H_

class AssistantPage
{
	public:
		AssistantPage(const Glib::ustring &resourcePath);
		virtual ~AssistantPage();

		Gtk::Box *GetPage(void);

		typedef sigc::signal<void, bool> type_signalPageComplete;
		type_signalPageComplete SignalPageComplete(void);

	protected:
		template <class T_Widget> inline
		void LoadWidget(const Glib::ustring& name, T_Widget*& widget)
		{
			m_refBuilder->get_widget(name, widget);
			m_gc.push_back(widget);
			if (!widget)
				throw Glib::ustring::compose("%1 - %2 - not found!", typeid(widget).name(), name).c_str();
		}

		type_signalPageComplete m_signalPageComplete;

		Gtk::Box *m_assistantPage;

		Glib::RefPtr<Gtk::Builder> m_refBuilder;
		std::vector<Gtk::Widget *> m_gc;

	private:
		virtual void EvaluatePageCompleteness(void);
};

#endif /* SRC_ASSISTANTPAGE_H_ */
