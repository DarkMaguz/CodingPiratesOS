/*
 * main.cpp
 *
 *  Created on: Dec 8, 2021
 *      Author: magnus
 */

#include <iostream>
#include <vector>
#include <string>
#include <cctype>
#include <map>
#include <chrono>
#include <algorithm>
#include <sstream>
#include <stdlib.h>
#include <iomanip>

#include <gtkmm/application.h>

#include "MainWindow.h"


int main(int argc, char **argv)
{
  auto app = Gtk::Application::create(argc, argv, "org.coding-pirates.disktool");

  MainWindow mw;

  //Shows the window and returns when it is closed.
  return app->run(mw);
}
