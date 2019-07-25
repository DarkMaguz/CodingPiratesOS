#!/usr/bin/python3

import sys
import time
import math
import tempfile

from PIL import Image
from PIL import ImageChops
from PIL import ImageStat

from interruptingcow import timeout

from vncdotool import api

debug=False

class vncdowrap(object):
    """docstring for vncdowrap."""

    client = None

    def __init__(self, host='qemu:0', password=None):
        super(vncdowrap, self).__init__()
        self.host = host
        self.password = password

    def __del__(self):
    	if self.client:
    		self.client.disconnect()

    def recon(self):
    	if self.client:
    		self.client.disconnect()
    	self.client = api.connect(self.host, self.password)

    def keyPress(self, key):
        self.recon()
        self.client.keyPress(key)

    def mouseMove(self, x, y):
        self.recon()
        self.client.mouseMove(x, y)

    def mousePress(self, button):
        self.recon()
        self.client.mousePress(button)

    def mouseDrag(self, x, y, step=1):
        self.recon()
        self.client.mouseDrag(x, y, step)

    def captureScreen(self, imgPath):
        self.recon()
        self.client.captureScreen(imgPath)

    #rms = lambda stat, sum: math.sqrt((1/len(stat.rms)) * sum)
    def rms(self, stat):
        sum = 0
        for v in stat.rms:
            sum += v**2
        return math.sqrt((1/len(stat.rms)) * sum)

    def _expectScreen(self, cmpImgPath, maxrms=0):
        with tempfile.TemporaryDirectory() as tmpDirName:
            screenImgPath = tmpDirName + '/screendump.png'
            self.captureScreen(screenImgPath)
            screenImg = Image.open(screenImgPath)
            cmpImg = Image.open(cmpImgPath)
            diff = ImageChops.difference(screenImg, cmpImg)
            stat = ImageStat.Stat(diff.histogram())
            #print(self.rms(stat))
            assert self.rms(stat) <= maxrms, "RMS is above tolerance"

    def expectScreen(self, cmpImgPath, maxrms=0, runTime=0):
        if runTime < 1:
            self._expectScreen(cmpImgPath, maxrms)
        else:
            timeStarted = time.time()
            with timeout(runTime, exception=RuntimeError('Timeout: Expected a screen that differs from the one curently displayed!')):
                while True:
                    try:
                        self._expectScreen(cmpImgPath, maxrms)
                        return
                    except AssertionError as e:
                        if debug:
                            print(f'%4f e: %s' %(time.time() - timeStarted, e))
