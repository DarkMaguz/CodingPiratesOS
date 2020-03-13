#!/usr/bin/python3

import threading
import time
import subprocess
import json

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import GLib, Gtk, GObject

_lock = threading.Lock()

# Return list of tuples for each device. Each tuple holds "Device", "Removable", "Size", "Type", "Mount" and children.
def getDevices():
    devices = list()
    lsblk = subprocess.run(["lsblk", "-J"], capture_output=True, text=True)
    lsblk_output = json.loads(lsblk.stdout)
    for dev in lsblk_output["blockdevices"]:
        if dev["children"] != None:
            children = list()
            for child in dev["children"]:
                children.append((child["name"], child["rm"], child["size"], child["type"], child["mountpoint"], None))
        devices.append((dev["name"], dev["rm"], dev["size"], dev["type"], dev["mountpoint"], children))
    return devices

class MainWindow(Gtk.Window):

    def __init__(self):
        Gtk.Window.__init__(self, title="CPOS Disk Tool")
        self.set_border_width(10)
        self.set_default_size(800,600)

        #Setting up the self.grid in which the elements are to be positionned
        #self.grid = Gtk.Grid()
        #self.grid.set_column_homogeneous(True)
        #self.grid.set_row_homogeneous(True)
        self.vbox_main = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.vbox_main.set_homogeneous(False)
        self.add(self.vbox_main)

        #Creating the TreeStore model
        self.device_treestore = Gtk.TreeStore(str, bool, str, str, str)

        #creating the treeview, making it use the filter as a model, and adding the columns
        self.treeview = Gtk.TreeView.new_with_model(self.device_treestore)
        for i, column_title in enumerate(["Device", "Removable", "Size", "Type", "Mount"]):
            renderer = Gtk.CellRendererText()
            column = Gtk.TreeViewColumn(column_title, renderer, text=i)
            self.treeview.append_column(column)
        #self.treeview.

        #setting up the layout, putting the treeview in a scrollwindow, and the buttons in a row
        self.scrollable_treestore = Gtk.ScrolledWindow()
        #self.scrollable_treestore.set_vexpand(True)
        #self.grid.attach(self.scrollable_treestore, 0, 0, 8, 10)
        self.scrollable_treestore.add(self.treeview)
        #self.vbox_main.pack_start(self.scrollable_treestore, True, True, 6)
        #self.vbox_main.pack_start(self.treeview, True, True, 6)

        self.tree_selection = self.treeview.get_selection()
        self.tree_selection.set_mode(Gtk.SelectionMode.SINGLE)
        self.tree_selection.connect("changed", self.on_tree_selection_changed)

        self.hbox_show_rm = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        self.hbox_show_rm.set_homogeneous(False)
        self.lable_show_rm = Gtk.Label(label="Show non-removable drives")
        self.hbox_show_rm.pack_start(self.lable_show_rm, True, False, 6)
        self.switch_show_rm = Gtk.Switch()
        self.hbox_show_rm.pack_start(self.switch_show_rm, False, False, 6)

        self.hbox_persistance = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        self.hbox_persistance.set_homogeneous(False)
        self.lable_persistance = Gtk.Label(label="Make persistance partition")
        self.hbox_persistance.pack_start(self.lable_persistance, True, False, 6)
        self.switch_persistance = Gtk.Switch()
        self.hbox_persistance.pack_start(self.switch_persistance, False, False, 6)

        self.hbox_pconf_nuke = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        self.hbox_pconf_nuke.set_homogeneous(False)
        self.TextView_pconf = Gtk.TextView()
        self.hbox_pconf_nuke.pack_start(self.TextView_pconf, True, True, 6)
        self.button_nuke = Gtk.Button(label="Nuke this drive")
        #self.button1.connect("clicked", self.on_button1_clicked)
        self.hbox_pconf_nuke.pack_start(self.button_nuke, False, False, 6)

        self.vbox_main.pack_start(self.scrollable_treestore, True, True, 6)
        self.vbox_main.pack_start(self.hbox_show_rm, True, True, 6)
        self.vbox_main.pack_start(self.hbox_persistance, True, True, 6)
        self.vbox_main.pack_start(self.hbox_pconf_nuke, True, True, 6)

        self.hbox_show_rm.set_homogeneous(False)
        self.hbox_persistance.set_homogeneous(False)
        self.hbox_pconf_nuke.set_homogeneous(False)
        self.vbox_main.set_homogeneous(False)

        self.show_all()

    def on_tree_selection_changed(self, selection):
        model, treeiter = selection.get_selected()
        if treeiter is not None:
            if self.device_treestore.iter_parent(treeiter) != None:
                self.tree_selection.unselect_iter(treeiter)
            #else:
            #    print(model[treeiter][0])

    def update_device_liststor(self):
        with _lock:
            model, treeiter = self.tree_selection.get_selected()
            current_selection = None
            if treeiter != None:
                current_selection = model[treeiter][0]

            self.device_treestore.clear()
            for dev in getDevices():
                parent_iter = self.device_treestore.append(None, dev[:-1])
                if treeiter != None:
                    if current_selection == dev[0]:
                        self.tree_selection.select_iter(parent_iter)
                if dev[-1] != None:
                    for child in dev[-1]:
                        child_iter = self.device_treestore.append(parent_iter, child[:-1])
            self.treeview.expand_all()

win = MainWindow()
win.update_device_liststor()

def updater():
    while True:
        GLib.idle_add(win.update_device_liststor)
        time.sleep(100)

thread = threading.Thread(target=updater)
thread.daemon = True
thread.start()

win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()
